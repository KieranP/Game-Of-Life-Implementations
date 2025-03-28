#!/bin/bash

source ../helpers.sh

echo -n "Swift - "
swiftc --version | head -n 1
compile swiftc -O -whole-module-optimization -o play *.swift
benchmark ./play
