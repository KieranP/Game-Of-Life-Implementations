# Gleam

## Install

```bash
brew install gleam
```

## Build

```bash
gleam build
```

## Run

```bash
gleam run
```

## Notes

- Identifiers cannot start with an underscore, so the `_f` helper is named `f` (see `f` in play.gleam).
- No support for pointers/shared references (data is immutable); fallback to storing coordinate keys ("x-y") in `cell.neighbours` and refetching cells from `world.cells` — a significant performance penalty (see `cell.alive_neighbours`).
- No support for continuous loops; fallback to recursive function calls (see `loop` in play.gleam).
- No support for native exceptions; emulated with `Result` error values (see `world.add_cell`).
- No support for unsigned integers; fallback to `Int` (see `cell.x`/`y`).
- No support for printf-style formatting (see `f` in play.gleam).
- No support for environment variables or monotonic time in the standard library; fallback to Erlang FFI (see play_ffi.erl).
