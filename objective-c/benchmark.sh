#!/bin/bash

source ../helpers.sh

echo -n "Objective-C - "
clang --version | head -n 1
compile clang -O3 -fobjc-arc -framework Foundation -o play *.m
benchmark ./play
