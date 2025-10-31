#!/bin/bash

source ../helpers.sh

echo -n "Go - "
go version | head -n 1
compile go build -ldflags="-s -w" -o play *.go
benchmark ./play
