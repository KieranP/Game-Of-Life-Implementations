#!/bin/bash

source ../helpers.sh

echo -n "Julia - "
julia --version | head -n 1
sample julia -O3 play.jl
