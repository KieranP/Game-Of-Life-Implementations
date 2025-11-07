# Rust

## Installation

* `brew install rust`

## Usage

* `cargo build --release`
* `./target/release/play-unsafe` (Faster/Unsafe; uses raw memory pointers)
* `./target/release/play-safe` (Slower/Safe: uses runtime Rc/RefCell)
