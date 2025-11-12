#!/bin/bash

SKIP=${SKIP:-0}
counter=0

if [ -n "$1" ]; then
  FOLDERS="$1"
fi

if [ -n "$FOLDERS" ]; then
  IFS=',' read -ra DIRS <<< "$FOLDERS"
  for dir in "${DIRS[@]}"; do
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
        cd - >/dev/null
      fi
    else
      echo "Skipping '$dir' (not a directory)" >&2
    fi
  done
else
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
        cd - >/dev/null
      fi
    fi
  done
fi
