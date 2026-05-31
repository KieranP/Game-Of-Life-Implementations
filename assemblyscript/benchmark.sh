#!/bin/bash

source ../helpers.sh

compile npm run asbuild

echo -n "AssemblyScript - Wasmer - "
wasmer --version | head -n 1
benchmark wasmer run --env MINIMAL=1 build/release.wasm

echo ""

echo -n "AssemblyScript - Wasmtime - "
wasmtime --version | head -n 1
benchmark wasmtime run --env MINIMAL=1 build/release.wasm
