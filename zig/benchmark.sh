#!/bin/bash

source ../helpers.sh

echo -n "Zig - "
zig version
compile zig build-exe -O ReleaseFast play.zig
benchmark ./play
