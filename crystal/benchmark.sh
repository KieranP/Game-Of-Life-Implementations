#!/bin/bash

source ../helpers.sh

echo -n "Crystal - "
crystal --version | head -n 1
compile crystal build play.cr --release
benchmark ./play
