#!/bin/bash

source ../helpers.sh

echo -n "Julia - "
julia --version | head -n 1
benchmark julia -O3 play.jl
