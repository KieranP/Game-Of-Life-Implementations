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

### Safe, with Rc/RefCell (slower)

```bash
./target/release/play-safe
```

### Unsafe, with raw pointers (faster)

```bash
./target/release/play-unsafe
```

## Notes

- Formatted with `rustfmt`, which enforces 4-space indentation rather than the
  project's 2.
- No support for shared mutable references, so there are two variants: safe
  (`Rc`/`RefCell`/`Weak`) and unsafe (raw pointers) (see src/safe, src/unsafe).
- No support for native exceptions; emulated with `panic` (see
  `World::add_cell`).
