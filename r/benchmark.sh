#!/bin/bash

source ../helpers.sh

echo -n "R - Rscript - "
Rscript --version 2>&1 | head -n 1
benchmark Rscript play.r
