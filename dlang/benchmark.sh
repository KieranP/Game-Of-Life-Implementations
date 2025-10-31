#!/bin/bash

source ../helpers.sh

echo -n "DLang - "
ldc2 --version | head -n 1
compile ldc2 -O3 --release -of=play *.d
benchmark ./play
