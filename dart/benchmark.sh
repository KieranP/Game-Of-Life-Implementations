#!/bin/bash

source ../helpers.sh

echo -n "Dart - "
dart --version | head -n 1
compile dart compile exe -o play play.dart
benchmark ./play
