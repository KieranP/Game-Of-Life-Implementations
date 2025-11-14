#!/bin/bash

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

  if [ "${QUICK}" = "true" ]; then
    TIMEOUT_SECS=5
    LOOP_COUNT=2
  else
    TIMEOUT_SECS=30
    LOOP_COUNT=3
  fi

  for i in $(seq 1 $LOOP_COUNT); do
    output=$(MINIMAL=1 timeout -s9 $TIMEOUT_SECS "$@" 2>&1)
    echo "$output" | grep -E '\)\s*$' | tail -n 1
  done
}
