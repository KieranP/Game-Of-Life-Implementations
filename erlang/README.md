# Erlang

## Install

```bash
brew install erlang
```

## Build

```bash
erlc -W cell.erl world.erl
```

## Run

```bash
escript play.erl
```

## Notes

- No support for pointers/shared references (data is immutable); fallback to storing coordinate keys ("x-y") in `cell.neighbours` and refetching cells from `world.cells` — a significant performance penalty (see `cell:alive_neighbours`).
- No support for continuous loops; fallback to recursive function calls (see `loop` in play.erl).
- No support for custom exception classes; emulated with error tuples (see `world:add_cell`).
