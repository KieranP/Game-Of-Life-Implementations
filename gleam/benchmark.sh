#!/bin/bash

source ../helpers.sh

echo -n "Gleam - "
gleam --version | head -n 1
compile gleam build
benchmark gleam run
