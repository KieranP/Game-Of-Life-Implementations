#!/bin/bash

source ../helpers.sh

echo -n "Odin - "
odin version | head -n 1
compile odin build . -o:speed --out=play
benchmark ./play
