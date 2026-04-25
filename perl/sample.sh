#!/bin/bash

source ../helpers.sh

echo -n "Perl - "
perl --version | sed -n 2p
sample perl play.pl
