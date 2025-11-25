#!/bin/bash

source ../helpers.sh

echo -n "C# - "
dotnet --version | head -n 1
compile dotnet build -c Release
benchmark bin/play
