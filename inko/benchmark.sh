#!/bin/bash

source ../helpers.sh

echo -n "Inko - "
inko --version | head -n 1
compile inko build --release --include . play.inko
benchmark ./build/release/play
