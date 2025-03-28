#!/bin/bash

source ../helpers.sh

echo -n "Navi - "
navi --version | head -n 1
benchmark navi run
