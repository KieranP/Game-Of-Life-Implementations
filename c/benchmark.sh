#!/bin/bash

source ../helpers.sh

echo -n "C - "
gcc --version | head -n 1
compile gcc -std=c23 -O3 -march=native -flto -o play *.c lib/*.c
benchmark ./play
