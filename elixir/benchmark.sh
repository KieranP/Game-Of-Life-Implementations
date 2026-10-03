#!/bin/bash

source ../helpers.sh

echo -n "Elixir - "
elixirc --version | sed -n '3p'
rm -f *.beam
compile elixirc cell.ex world.ex
benchmark elixir play.ex
