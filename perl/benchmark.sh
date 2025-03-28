#!/bin/bash

source ../helpers.sh

echo -n "Perl - "
perl --version | sed -n 2p
benchmark perl play.pl
