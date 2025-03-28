#!/bin/bash

source ../helpers.sh

echo -n "VLang - "
v --version | head -n 1
compile v -prod -o play .
benchmark ./play
