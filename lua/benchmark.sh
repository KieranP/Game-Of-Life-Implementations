#!/bin/bash

source ../helpers.sh

echo -n "Lua - "
lua -v | head -n 1
benchmark lua play.lua

echo ""

echo -n "Lua - LuaJIT - "
luajit -v | head -n 1
benchmark luajit -O3 play.lua
