#!/bin/bash

source ../helpers.sh

echo -n "Ruby - CRuby (w/o JIT) - "
ruby --version | head -n 1
benchmark ruby play.rb

echo ""

echo -n "Ruby - CRuby (w/ YJIT) - "
ruby --version | head -n 1
benchmark ruby --yjit play.rb

echo ""

echo -n "Ruby - CRuby (w/ ZJIT) - "
ruby --version | head -n 1
benchmark ruby --zjit play.rb
