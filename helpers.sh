#!/bin/bash

# Benchmark mode comes from the calling script's first argument
# (iterations|memory), then an inherited MODE, then "iterations".
case "$1" in
  iterations|memory)
    MODE="$1"
    ;;
  *)
    MODE="${MODE:-iterations}"
    ;;
esac
export MODE

function compile {
  output=$("$@" 2>&1)
  exit_code=$?

  if [ $exit_code -ne 0 ]; then
    echo "$output"
    exit $exit_code
  fi
}

function benchmark {
  if [ "${COMPILEONLY}" = "true" ]; then
    return
  fi

  keep_awake

  if [ "${MODE}" = "memory" ]; then
    benchmark_memory "$@"
  else
    benchmark_iterations "$@"
  fi
}

# Prevent system sleep for the lifetime of the calling script (macOS).
# Exported guard ensures nested scripts don't spawn duplicates.
function keep_awake {
  if [ -n "$CAFFEINATED" ]; then
    return
  fi

  if command -v caffeinate >/dev/null 2>&1; then
    caffeinate -dims -w $$ &
    export CAFFEINATED=1
  fi
}

function benchmark_iterations {
  if [ "${QUICK}" = "true" ]; then
    TIMEOUT_SECS=5
    LOOP_COUNT=2
  else
    TIMEOUT_SECS=30
    LOOP_COUNT=3
  fi

  for i in $(seq 1 $LOOP_COUNT); do
    # tr converts pty \r\n endings and bare \r (progress spinners)
    # into newlines, so fragments can never splice into result lines
    output=$(run_pty env MINIMAL=1 timeout -s9 $TIMEOUT_SECS "$@" 2>&1 | tr '\r' '\n')
    result=$(echo "$output" | grep -E '\)\s*$' | tail -n 1)

    if [ -n "$result" ]; then
      echo "$result"
    else
      echo "!! no benchmark result captured; last output was:" >&2
      echo "$output" | grep . | tail -n 3 >&2
    fi
  done
}

function benchmark_memory {
  if [ "${QUICK}" = "true" ]; then
    TIMEOUT_SECS=5
  else
    TIMEOUT_SECS=30
  fi

  output=$(MINIMAL=1 node ../sample.js $TIMEOUT_SECS "$@" 2>&1)
  result=$(echo "$output" | grep "Max RSS")

  if [ -n "$result" ]; then
    echo "$result"
  else
    echo "!! no memory result captured; last output was:" >&2
    echo "$output" | grep . | tail -n 3 >&2
  fi
}

# Run a command attached to a pseudo-TTY so runtimes line-buffer stdout,
# otherwise buffered trailing output is lost when the process is killed.
function run_pty {
  if [ "$(uname)" = "Darwin" ]; then
    # sed strips the "^D" + backspaces the pty echoes when stdin closes
    script -q /dev/null "$@" < /dev/null | sed $'1s/^\\^D\b\b//'
  else
    script -qec "$(printf '%q ' "$@")" /dev/null < /dev/null
  fi
}

# Run benchmark.sh in each implementation folder (or a comma-separated
# subset), skipping the first N via SKIP=N. MODE is inherited.
function run_all {
  folders=$1

  keep_awake

  SKIP=${SKIP:-0}
  counter=0

  if [ -n "$folders" ]; then
    IFS=',' read -ra dirs <<< "$folders"
  else
    dirs=(*/)
  fi

  for dir in "${dirs[@]}"; do
    ((counter++))
    if [ $counter -le $SKIP ]; then
      continue
    fi

    if [ ! -d "$dir" ]; then
      echo "Skipping '$dir' (not a directory)" >&2
      continue
    fi

    if [ -f "$dir/benchmark.sh" ]; then
      cd "$dir"
      ./benchmark.sh
      echo ""
      cd - >/dev/null
    fi
  done
}
