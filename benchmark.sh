#!/bin/bash

SKIP=${SKIP:-0}
counter=0

for dir in */; do
  ((counter++))

  if [ $counter -le $SKIP ]; then
    continue
  fi

  if [ -d "$dir" ]; then
    benchmark_script="$dir/benchmark.sh"
    if [ -f "$benchmark_script" ]; then
      cd "$dir"
      ./benchmark.sh
      echo ""
      cd ".."
    fi
  fi
done
