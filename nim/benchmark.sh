#!/bin/bash

source ../helpers.sh

echo -n "Nim - "
nim --version | head -n 1
compile nim c -d:release play.nim
benchmark ./play
