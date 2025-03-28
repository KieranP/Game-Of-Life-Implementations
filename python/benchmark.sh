#!/bin/bash

source ../helpers.sh

echo -n "Python - Python3 - "
python3 --version | head -n 1
benchmark python3 play.py

echo ""

echo -n "Python - PyPy3 - "
pypy3 --version | sed -n 2p
benchmark pypy3 play.py
