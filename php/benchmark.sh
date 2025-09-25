#!/bin/bash

source ../helpers.sh

echo -n "PHP (w/o JIT) - "
php --version | head -n 1
benchmark php play.php

echo ""

echo -n "PHP (w/ JIT) - "
php --version | head -n 1
benchmark php -c jit.ini play.php
