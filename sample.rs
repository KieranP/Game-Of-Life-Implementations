// Build: rustc -O --edition 2024 -o sample sample.rs
// Usage: ./sample [TIMEOUT] [CMD], e.g. ./sample 30 ./play

use std::collections::HashMap;
use std::env;
use std::io;
use std::os::unix::process::{CommandExt, ExitStatusExt};
use std::process::{Child, Command, ExitCode, ExitStatus, Stdio};
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread;
use std::time::{Duration, Instant};

// Signal numbers and SIG_IGN, the same on macOS and Linux
const SIGHUP: i32 = 1;
const SIGINT: i32 = 2;
const SIGTERM: i32 = 15;
const SIG_IGN: usize = 1;
const STOP_SIGNALS: [i32; 3] = [SIGHUP, SIGINT, SIGTERM];

const BYTES_PER_MB: u64 = 1024 * 1024;
const GRAPH_WIDTH: u64 = 50;

// How often the loop checks for child exit, signals and timeout between samples
const POLL_INTERVAL: Duration = Duration::from_millis(10);

static STOP_REQUESTED: AtomicBool = AtomicBool::new(false);

// std has no way to catch a signal, so this is the one call through libc
unsafe extern "C" {
    fn signal(signum: i32, handler: usize) -> usize;
}

extern "C" fn on_stop_signal(_signum: i32) {
    STOP_REQUESTED.store(true, Ordering::SeqCst);
}

// If the sampler is interrupted, hung up or terminated, also kill the child tree.
// A signal the caller ignores, as nohup does SIGHUP, stays ignored.
fn install_stop_handlers() {
    let handler = on_stop_signal as extern "C" fn(i32) as usize;
    for signum in STOP_SIGNALS {
        unsafe {
            if signal(signum, handler) == SIG_IGN {
                signal(signum, SIG_IGN);
            }
        }
    }
}

// Children inherit SIG_IGN, so a second Ctrl-C can't kill the ps or kill run by cleanup
fn ignore_stop_signals() {
    for signum in STOP_SIGNALS {
        unsafe {
            signal(signum, SIG_IGN);
        }
    }
}

struct ProcessInfo {
    ppid: u32,
    rss: u64,
}

struct RssSampler {
    command: String,
    timeout: Duration,
    interval: Duration,

    child: Child,
    samples: Vec<u64>,
}

impl RssSampler {
    fn spawn(
        command: &str,
        command_args: &[String],
        timeout: Duration,
        interval: Duration,
    ) -> io::Result<Self> {
        // Its own process group keeps Ctrl-C off the child, so the tree is intact to kill.
        // Background groups stop on terminal reads (Wasmer froze), so stdin is null.
        let child = Command::new(command)
            .args(command_args)
            .process_group(0)
            .stdin(Stdio::null())
            .spawn()?;

        Ok(Self {
            command: command.to_string(),
            timeout,
            interval,
            child,
            samples: Vec::new(),
        })
    }

    fn run(&mut self) -> ExitCode {
        let started = Instant::now();
        let deadline = started + self.timeout;
        let mut next_tick = started;

        loop {
            if STOP_REQUESTED.load(Ordering::SeqCst) {
                ignore_stop_signals();
                if let Err(e) = self.kill_tree() {
                    eprintln!("Failed to kill child process tree on signal: {e}");
                }

                self.print_summary();
                return ExitCode::SUCCESS;
            }

            if let Some(status) = self.exit_status() {
                if !status.success() {
                    eprintln!("{} failed: {status}", self.command);
                    return Self::failure_exit_code(status);
                }

                self.print_summary();
                return ExitCode::SUCCESS;
            }

            let now = Instant::now();
            if now >= deadline {
                if let Err(e) = self.kill_tree() {
                    eprintln!("Failed to kill child process tree on timeout: {e}");
                }

                self.print_summary();
                return ExitCode::SUCCESS;
            }

            if now >= next_tick {
                self.tick();

                // Ticks that would overlap a slow sample are skipped, as setInterval does
                let now = Instant::now();
                while next_tick <= now {
                    next_tick += self.interval;
                }
            }

            let now = Instant::now();
            let wake = next_tick.min(deadline).saturating_duration_since(now);
            thread::sleep(wake.min(POLL_INTERVAL));
        }
    }

    fn exit_status(&mut self) -> Option<ExitStatus> {
        self.child.try_wait().ok().flatten()
    }

    fn child_exited(&mut self) -> bool {
        self.exit_status().is_some()
    }

    // Shell convention: 128 + the signal number for a child killed by a signal
    fn failure_exit_code(status: ExitStatus) -> ExitCode {
        let code = status
            .code()
            .unwrap_or_else(|| 128 + status.signal().unwrap_or(0));
        ExitCode::from(u8::try_from(code).unwrap_or(1))
    }

    fn tick(&mut self) {
        if self.child_exited() {
            return;
        }

        match self.sample_rss() {
            Ok(rss) => self.samples.push(rss),
            // A Ctrl-C landing while ps is still being spawned can reach it
            Err(_) if self.child_exited() || STOP_REQUESTED.load(Ordering::SeqCst) => {}
            Err(e) => eprintln!("Failed to sample rss: {e}"),
        }
    }

    fn print_summary(&self) {
        println!("\n\n=== RSS Sampling Summary ===");
        match self.samples.iter().max() {
            None => {
                println!("No successful RSS samples collected.");
            }
            Some(&max) => {
                println!("Max RSS: {}", Self::format_bytes(max));
                println!();

                for line in Self::ascii_graph_for_samples(&self.samples) {
                    println!("{line}");
                }
            }
        }
        println!();
    }

    fn sample_rss(&self) -> io::Result<u64> {
        let processes = Self::list_processes()?;

        let pids = Self::process_tree(self.child.id(), &processes)
            .ok_or_else(|| io::Error::other("process-not-found"))?;
        Ok(pids.iter().map(|p| processes[p].rss).sum())
    }

    fn format_bytes(bytes: u64) -> String {
        if bytes == 0 {
            return String::from("0 MB");
        }

        let hundredths = (bytes * 100 + BYTES_PER_MB / 2) / BYTES_PER_MB;
        format!(
            "{}.{:02} MB ({bytes} B)",
            hundredths / 100,
            hundredths % 100
        )
    }

    fn ascii_graph_for_samples(samples: &[u64]) -> Vec<String> {
        let max = samples.iter().max().copied().unwrap_or(0);

        samples
            .iter()
            .enumerate()
            .map(|(idx, &sample)| {
                let bar_len = (sample * GRAPH_WIDTH + max / 2)
                    .checked_div(max)
                    .unwrap_or(0);
                let is_max = sample == max;
                let bar = (if is_max { "*" } else { "=" }).repeat(bar_len.max(1) as usize);
                let label = Self::format_bytes(sample);
                format!("{idx:>3}: {bar} {label}")
            })
            .collect()
    }

    fn kill_tree(&self) -> io::Result<()> {
        let pid = self.child.id();
        let processes = Self::list_processes()?;

        // Empty when the child has exited since the last check
        let mut pids = Self::process_tree(pid, &processes).unwrap_or_default();

        // Newest child processes first
        pids.sort_unstable_by(|a, b| b.cmp(a));

        // The child leads its own process group, which also holds descendants
        // already orphaned to init, out of reach of the tree walk
        let output = Self::tool("kill")
            .args(["-9", "--"])
            .args(pids.iter().map(u32::to_string))
            .arg(format!("-{pid}"))
            .output()?;

        // Processes that exited since the ps call are not an error
        for line in String::from_utf8_lossy(&output.stderr).lines() {
            if !line.contains("No such process") {
                eprintln!("Failed to kill process: {line}");
            }
        }

        Ok(())
    }

    // Its own process group, so a second Ctrl-C can't kill ps or kill mid-cleanup
    fn tool(program: &str) -> Command {
        let mut command = Command::new(program);
        command.process_group(0);
        command
    }

    // One ps call, the same source pidtree and pidusage read on macOS
    fn list_processes() -> io::Result<HashMap<u32, ProcessInfo>> {
        let output = Self::tool("ps")
            .args(["-A", "-o", "pid=,ppid=,rss=,state="])
            .output()?;
        if !output.status.success() {
            return Err(io::Error::other(format!(
                "ps exited with {}",
                output.status
            )));
        }

        let mut processes = HashMap::new();
        for line in String::from_utf8_lossy(&output.stdout).lines() {
            let fields: Vec<&str> = line.split_whitespace().collect();
            // An exited child stays listed as a zombie with 0 RSS until it is reaped
            if let [pid, ppid, rss_kb, state] = fields[..]
                && !state.starts_with('Z')
                && let (Ok(pid), Ok(ppid), Ok(rss_kb)) =
                    (pid.parse(), ppid.parse(), rss_kb.parse::<u64>())
            {
                let rss = rss_kb * 1024;
                processes.insert(pid, ProcessInfo { ppid, rss });
            }
        }

        Ok(processes)
    }

    fn process_tree(root: u32, processes: &HashMap<u32, ProcessInfo>) -> Option<Vec<u32>> {
        if !processes.contains_key(&root) {
            return None;
        }

        let mut children: HashMap<u32, Vec<u32>> = HashMap::new();
        for (&pid, info) in processes {
            children.entry(info.ppid).or_default().push(pid);
        }

        let mut pids = vec![root];
        let mut idx = 0;
        while let Some(&pid) = pids.get(idx) {
            if let Some(kids) = children.get(&pid) {
                pids.extend(kids);
            }
            idx += 1;
        }

        Some(pids)
    }
}

fn main() -> ExitCode {
    let mut args = env::args();
    let program = args.next().unwrap_or_else(|| String::from("sample"));
    let timeout = args
        .next()
        .and_then(|t| t.parse::<f64>().ok())
        .and_then(|t| Duration::try_from_secs_f64(t).ok())
        .filter(|&t| Instant::now().checked_add(t).is_some());
    let (Some(timeout), Some(command)) = (timeout, args.next()) else {
        eprintln!("Usage: {program} [TIMEOUT] [CMD]");
        return ExitCode::FAILURE;
    };
    let command_args: Vec<String> = args.collect();
    let interval = Duration::from_millis(500);

    // Before the spawn, so a signal from here on still reaches the kill path
    install_stop_handlers();

    match RssSampler::spawn(&command, &command_args, timeout, interval) {
        Ok(mut sampler) => sampler.run(),
        Err(e) => {
            eprintln!("Failed to start {command}: {e}");
            ExitCode::FAILURE
        }
    }
}
