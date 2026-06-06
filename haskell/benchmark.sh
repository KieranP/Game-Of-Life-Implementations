#!/bin/bash

source ../helpers.sh

echo -n "Haskell - "
ghc --version

compile ghc -O2 -main-is Play.run Play.hs -o play
benchmark ./play
