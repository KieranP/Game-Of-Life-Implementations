#!/bin/bash

source ../helpers.sh

echo -n "Nim - "
nim --version | head -n 1
compile nim c -d:release --passC:"-O3" --passC:"-march=native" --passC:"-flto" play.nim
benchmark ./play
