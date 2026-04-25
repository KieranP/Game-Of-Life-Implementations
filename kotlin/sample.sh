#!/bin/bash

source ../helpers.sh

echo -n "Kotlin - "
kotlinc -version | head -n 1
compile kotlinc *.kt
sample kotlin PlayKt
