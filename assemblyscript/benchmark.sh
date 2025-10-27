#!/bin/bash

source ../helpers.sh

compile npm run asbuild

echo -n "AssemblyScript - Wasmer - "
wasmer --version | head -n 1
benchmark wasmer run build/release.wasm

echo ""

echo -n "AssemblyScript - Wasmtime - "
wasmtime --version | head -n 1
benchmark wasmtime run build/release.wasm
