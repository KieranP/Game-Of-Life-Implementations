#!/bin/bash

source ../helpers.sh

echo -n "Java - "
java --version | head -n 1
compile javac *.java
benchmark java Play
