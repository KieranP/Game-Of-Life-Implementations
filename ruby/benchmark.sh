#!/bin/bash

source ../helpers.sh

echo -n "Ruby - CRuby (w/o JIT) - "
ruby --version | head -n 1
benchmark ruby play.rb

echo ""

echo -n "Ruby - CRuby (w/ JIT) - "
ruby --version | head -n 1
benchmark ruby --jit play.rb

# echo ""

# echo -n "Ruby - JRuby - "
# ruby --version | head -n 1
# benchmark ruby play.rb

# echo ""

# echo -n "Ruby - TruffleRuby - "
# ruby --version | head -n 1
# benchmark ruby play.rb
