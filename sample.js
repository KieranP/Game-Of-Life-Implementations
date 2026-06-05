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
    intervalMs = 500,
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
        await this.killTree();
      } catch (e) {
        console.error("Failed to kill child process tree on interupt:", e);
      }

      this.stopAndPrint();
    });

    this.child = spawn(this.command, this.commandArgs, {
      stdio: "inherit",
      detached: true,
    });

    this.child.on("exit", () => {
      this.stopAndPrint();
    });

    this.timeoutTimer = setTimeout(async () => {
      try {
        await this.killTree();
      } catch (e) {
        console.error("Failed to kill child process tree on timeout:", e);
      }

      this.stopAndPrint();
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
      const rss = await this.sampleRss();
      this.samples.push(rss);
    } catch (e) {
      console.error("Failed to sample rss:", e);
    } finally {
      this.sampling = false;
    }
  }

  stopAndPrint(exitCode = 0) {
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
      console.log(`Max RSS: ${this.formatBytes(max)}`);
      console.log("");

      const graphLines = this.asciiGraphForSamples(this.samples);
      graphLines.forEach((l) => console.log(l));
      console.log("");
    }

    process.exit(exitCode);
  }

  async sampleRss() {
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

  formatBytes(bytes) {
    if (bytes === null) return "N/A";
    if (bytes === 0) return "0 MB";
    const value = bytes / 1024 / 1024;
    return `${value.toFixed(2)} MB (${bytes} B)`;
  }

  asciiGraphForSamples(samples) {
    const max = samples.length ? Math.max(...samples) : 0;

    return samples.map((sample, idx) => {
      const ratio = max > 0 ? sample / max : 0;
      const barLen = Math.round(ratio * 50);
      const isMax = sample === max;
      const bar = (isMax ? "*" : "=").repeat(Math.max(1, barLen));
      const label = this.formatBytes(sample);
      return `${String(idx).padStart(3)}: ${bar} ${label}`;
    });
  }

  async killTree() {
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
