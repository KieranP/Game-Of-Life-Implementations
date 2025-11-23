#!/bin/bash

source ../helpers.sh

echo -n "OCaml - "
ocaml --version | head -n 1
compile ocamlopt -O3 -o play cell.ml world.ml play.ml
benchmark ./play
