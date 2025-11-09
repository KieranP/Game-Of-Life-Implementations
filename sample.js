#!/usr/bin/env node
import { spawn } from "node:child_process";
import pidtree from "pidtree";
import pidusage from "pidusage";

// Setup:
//   npm install
// Usage:
//   node sample.js [TIMEOUT] [CMD]
// Example:
//   node sample.js 30 ./play

class RssSampler {
  constructor(
    command,
    commandArgs = [],
    timeoutSeconds = 30,
    intervalMs = 1000,
  ) {
    this.command = command;
    this.commandArgs = commandArgs;
    this.timeoutSeconds = timeoutSeconds;
    this.intervalMs = intervalMs;

    this.child = null;
    this.samples = [];
    this.tickTimer = null;
    this.timeoutTimer = null;
    this.sampling = false;
    this.stopped = false;
  }

  async start() {
    // If the sampler is interupted, also kill child process tree
    process.on("SIGINT", async () => {
      try {
        await this.kill_tree();
      } catch (e) {
        console.error("Failed to kill child process tree on interupt:", e);
      }

      this.stop_and_print();
    });

    this.child = spawn(this.command, this.commandArgs, {
      stdio: "inherit",
      detached: true,
    });

    this.child.on("exit", () => {
      this.stop_and_print();
    });

    this.timeoutTimer = setTimeout(async () => {
      try {
        await this.kill_tree();
      } catch (e) {
        console.error("Failed to kill child process tree on timeout:", e);
      }

      this.stop_and_print();
    }, this.timeoutSeconds * 1000);

    await this.tick();
    this.tickTimer = setInterval(() => {
      this.tick();
    }, this.intervalMs);
  }

  async tick() {
    if (this.sampling || this.stopped) return;
    this.sampling = true;

    try {
      const rss = await this.sample_rss();
      this.samples.push(rss);
    } catch (e) {
      console.error("Failed to sample rss:", e);
    } finally {
      this.sampling = false;
    }
  }

  stop_and_print(exitCode = 0) {
    if (this.stopped) return;
    this.stopped = true;

    if (this.tickTimer) {
      clearInterval(this.tickTimer);
      this.tickTimer = null;
    }

    if (this.timeoutTimer) {
      clearTimeout(this.timeoutTimer);
      this.timeoutTimer = null;
    }

    const count = this.samples.length;
    const max = count > 0 ? Math.max(...this.samples) : null;

    console.log("\n\n=== RSS Sampling Summary ===");
    if (count === 0) {
      console.log("No successful RSS samples collected.\n");
    } else {
      console.log(`Max RSS: ${this.format_bytes(max)}`);
      console.log("");

      const graph_lines = this.ascii_graph_for_samples(this.samples);
      graph_lines.forEach((l) => console.log(l));
      console.log("");
    }

    process.exit(exitCode);
  }

  async sample_rss() {
    if (!this.child || !this.child.pid) return;
    const pid = this.child.pid;

    const pids = await pidtree(pid, { root: true });
    if (!pids || pids.length === 0) {
      throw new Error("process-not-found");
    }

    const usage = await pidusage(pids);
    const values = Object.values(usage);
    return values.reduce((acc, cur) => acc + cur.memory, 0);
  }

  format_bytes(bytes) {
    if (bytes === null) return "N/A";
    if (bytes === 0) return "0 MB";
    const value = bytes / 1024 / 1024;
    return `${value.toFixed(2)} MB (${bytes} B)`;
  }

  ascii_graph_for_samples(samples) {
    const max = samples.length ? Math.max(...samples) : 0;

    return samples.map((sample, idx) => {
      const ratio = sample / max;
      const barLen = Math.round(ratio * 50);
      const is_max = sample === max;
      const bar = (is_max ? "*" : "=").repeat(Math.max(1, barLen));
      const label = this.format_bytes(sample);
      return `${String(idx).padStart(3)}: ${bar} ${label}`;
    });
  }

  async kill_tree() {
    if (!this.child || !this.child.pid) return;
    const pid = this.child.pid;

    const pids = await pidtree(pid, { root: true });
    if (!pids || pids.length === 0) {
      throw new Error("process-not-found");
    }

    // Newest child processes first
    pids.sort((a, b) => b - a);

    for (const p of pids) {
      try {
        process.kill(p, "SIGKILL");
      } catch (e) {
        // Ignore "no such process" errors
        if (e?.code === "ESRCH") continue;
        console.error(`Failed to kill pid ${p}:`, e);
      }
    }
  }
}

const timeout = Number(process.argv[2]);
const cmd = process.argv[3];
const args = process.argv.slice(4);
const interval = 500;

const sampler = new RssSampler(cmd, args, timeout, interval);
sampler.start();
