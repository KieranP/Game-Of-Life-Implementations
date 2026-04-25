#!/bin/bash

source ../helpers.sh

echo -n "Fortran - "
gfortran --version | head -n 1
compile gfortran -O3 -o play cell.f90 hashmap.f90 world.f90 play.f90
sample ./play
