#!/bin/bash

source ../helpers.sh

echo -n "Inko - "
inko --version | head -n 1
compile inko build -i . -o play --opt aggressive play.inko
benchmark ./play
