#!/bin/bash

source ../helpers.sh

echo -n "PHP (w/o JIT) - "
php --version | head -n 1
sample php play.php

echo ""

echo -n "PHP (w/ JIT) - "
php --version | head -n 1
sample php -c jit.ini play.php
