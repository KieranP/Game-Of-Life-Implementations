# Inko

## Install

```bash
brew install inko
```

## Build

```bash
inko build --release --include . play.inko
```

## Run

```bash
./build/release/play
```

## Notes

- No support for native exceptions; emulated with panic (see `World#add_cell`).
- No support for unsigned integers; fallback to `Int` (see `Cell#x`/`y`).
- No support for printf-style formatting (see `Play#_f`).
