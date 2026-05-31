#!/bin/bash

source ../helpers.sh

echo -n "Go - "
go version | head -n 1
compile go build -o play *.go
sample ./play
