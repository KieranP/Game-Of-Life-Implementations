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

## Notes

- No support for shared mutable references, so there are two variants: safe (`Rc`/`RefCell`/`Weak`) and unsafe (raw pointers) (see `src/safe`, `src/unsafe`).
- No support for native exceptions; emulated with panic (see `World::add_cell`).
