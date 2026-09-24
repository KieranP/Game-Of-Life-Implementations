#!/bin/bash

source ../helpers.sh

echo -n "OCaml - "
ocaml --version | head -n 1
compile ocamlopt -O3 -I +runtime_events runtime_events.cmxa -o play cell.ml world.ml play.ml
benchmark ./play
