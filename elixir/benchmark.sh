#!/bin/bash

source ../helpers.sh

echo -n "Elixir - "
elixirc --version | sed -n '3p'
rm -f *.beam
benchmark elixirc *.ex
