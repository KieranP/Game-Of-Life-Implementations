#!/bin/bash

source ../helpers.sh

echo -n "C++ - "
g++ --version | head -n 1
compile g++ -std=c++26 -O3 -march=native -flto -o play play.cpp
benchmark ./play
