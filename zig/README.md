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

- Formatted with `zig fmt`, which enforces 4-space indentation rather than the project's 2.
- No support for native exceptions; emulated with payload-less error values (see `World#addCell`).
