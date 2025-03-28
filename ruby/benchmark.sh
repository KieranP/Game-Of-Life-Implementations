#!/bin/bash

source ../helpers.sh

echo -n "Ruby - CRuby (No JIT) - "
ruby --version | head -n 1
benchmark ruby play.rb

echo ""

echo -n "Ruby - CRuby (With JIT) - "
ruby --version | head -n 1
benchmark ruby --jit play.rb

echo ""

echo -n "Ruby - JRuby - "
echo "TODO"

echo ""

echo -n "Ruby - TruffleRuby - "
echo "TODO"
