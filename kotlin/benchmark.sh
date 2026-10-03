#!/bin/bash

source ../helpers.sh

echo -n "Kotlin - "
kotlinc -version 2>&1 | sed -n 's/^info: //p'
compile kotlinc *.kt
benchmark kotlin PlayKt
