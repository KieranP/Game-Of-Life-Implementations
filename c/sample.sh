#!/bin/bash

source ../helpers.sh

echo -n "C - "
gcc --version | head -n 1
compile gcc -std=c23 -O3 -o play *.c lib/*.c
sample ./play
