#!/bin/bash

source ../helpers.sh

echo -n "Pony - "
ponyc --version | head -n 1
compile ponyc -b play
benchmark ./play
