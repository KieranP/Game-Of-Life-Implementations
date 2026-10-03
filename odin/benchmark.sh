#!/bin/bash

source ../helpers.sh

echo -n "Odin - "
odin version | awk '{print $NF}'
compile odin build . -o:speed --out=play
benchmark ./play
