# Elixir

## Install

```bash
brew install elixir
```

## Build

```bash
rm -f *.beam
elixirc cell.ex world.ex
```

## Run

```bash
elixir play.ex
```

## Notes

- No support for pointers/shared references (data is immutable); fallback to
  storing coordinate keys ("x-y") in `cell.neighbours` and refetching cells from
  `world.cells` — a significant performance penalty (see
  `Cell.alive_neighbours`).
- No support for continuous loops; fallback to recursive function calls (see
  `Play.loop`).
