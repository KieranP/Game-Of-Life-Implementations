#!/bin/bash

source ../helpers.sh

echo -n "Rust - Safe - "
rustc --version | head -n 1
compile cargo build --release
benchmark ./target/release/play-safe

echo ""

echo -n "Rust - Unsafe - "
rustc --version | head -n 1
compile cargo build --release
benchmark ./target/release/play-unsafe
