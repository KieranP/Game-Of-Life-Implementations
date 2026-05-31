#!/bin/bash

source ../helpers.sh

echo -n "Zig - "
zig version
compile zig build-exe -O ReleaseSafe play.zig
benchmark ./play
