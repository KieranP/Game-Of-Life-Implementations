#!/bin/bash

source ../helpers.sh

echo -n "Objective-C - "
clang --version | head -n 1
compile clang -O3 -framework Foundation -o play *.m
benchmark ./play
