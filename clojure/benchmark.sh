#!/bin/bash

source ../helpers.sh

echo -n "Clojure - "
clojure --version | head -n 1
benchmark clojure -M play.clj
