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
  for i in {1..3}; do
    output=$(MINIMAL=1 timeout -s9 30 "$@" 2>&1)
    echo "$output" | grep -E '\)\s*$' | tail -n 1
  done
}
