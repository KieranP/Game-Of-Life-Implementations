#!/bin/bash

source ../helpers.sh

echo -n "Ruby - CRuby (w/o JIT) - "
ruby --version | head -n 1
benchmark ruby play.rb

echo ""

echo -n "Ruby - CRuby (w/ YJIT) - "
ruby --yjit --version | head -n 1
benchmark ruby --yjit play.rb

echo ""

echo -n "Ruby - CRuby (w/ ZJIT) - "
# A missing-ZJIT warning would splice into the header; the benchmark shows it
ruby --zjit --version 2>/dev/null | head -n 1
benchmark ruby --zjit play.rb
