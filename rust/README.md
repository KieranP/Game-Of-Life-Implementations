# Rust

## Install

```bash
brew install rust
```

## Build

```bash
cargo build --release
```

## Run

```bash
./target/release/play-unsafe # (Faster/Unsafe; uses raw memory pointers)
./target/release/play-safe   # (Slower/Safe: uses runtime Rc/RefCell)
```
