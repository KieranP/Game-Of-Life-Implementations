#!/bin/bash

source ../helpers.sh

echo -n "Scala - "
scalac --version | head -n 1
compile scalac *.scala
benchmark scala run -cp . -M Play
