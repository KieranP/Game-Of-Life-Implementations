#!/bin/bash

# Usage: ./benchmark.sh [iterations|memory] [folder1,folder2,...]

source ./helpers.sh

case "$1" in
  iterations|memory)
    shift
    ;;
esac

if [ -n "$1" ]; then
  FOLDERS="$1"
fi

run_all "$FOLDERS"
