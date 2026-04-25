#!/bin/bash

source ../helpers.sh

echo -n "Scala - "
scalac --version | head -n 1
compile scalac *.scala
sample scala run -cp . -M Play
