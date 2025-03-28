#!/bin/bash

source ../helpers.sh

echo -n "PHP (w/o JIT) - "
php --version | head -n 1
benchmark php play.php

echo ""

echo -n "PHP (w/ JIT) - "
php --version | head -n 1
benchmark php -dopcache.enable_cli=1 -dopcache.jit_buffer_size=256M play.php
