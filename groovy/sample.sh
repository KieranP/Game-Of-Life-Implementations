#!/bin/bash

source ../helpers.sh

echo -n "Groovy - "
groovyc --version | head -n 1
compile groovyc --compile-static *.groovy
sample groovy Play
