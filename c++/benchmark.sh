#!/bin/bash

source ../helpers.sh

echo -n "C++ - "
g++ --version | head -n 1
compile g++ -std=c++23 -O3 -o play play.cpp
benchmark ./play
