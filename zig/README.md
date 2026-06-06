# Zig

## Install

```bash
brew install zig
```

## Build

```bash
zig build-exe -O ReleaseSafe play.zig
```

## Run

```bash
./play
```

## Notes

- No support for native exceptions; emulated with payload-less error values (see `World#addCell`).
