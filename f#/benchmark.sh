#!/bin/bash

source ../helpers.sh

echo -n "F# - "
dotnet --version | head -n 1
compile dotnet build
benchmark bin/play
