#!/bin/bash

source ../helpers.sh

echo -n "Python - Python3 - "
python3 --version | head -n 1
sample python3 play.py

echo ""

echo -n "Python - PyPy3 - "
pypy3 --version | sed -n 2p
sample pypy3 play.py
