#!/bin/bash

source ../helpers.sh

echo -n "Ruby - CRuby (w/o JIT) - "
ruby --version | head -n 1
sample ruby play.rb

echo ""

echo -n "Ruby - CRuby (w/ JIT) - "
ruby --version | head -n 1
sample ruby --jit play.rb
