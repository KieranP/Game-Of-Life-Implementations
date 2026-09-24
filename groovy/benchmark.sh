#!/bin/bash

source ../helpers.sh

echo -n "Groovy - "
groovy --version | head -n 1
benchmark groovy --compile-static Play
