#!/bin/bash

source ../helpers.sh

echo -n "Lisp (Common) - "
sbcl --version
benchmark sbcl --script play.lisp
