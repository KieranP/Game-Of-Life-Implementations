#!/bin/bash

source ../helpers.sh

echo -n "Ballerina - "
bal --version | head -n 1
compile bal build
benchmark bal run target/bin/ballerina.jar
