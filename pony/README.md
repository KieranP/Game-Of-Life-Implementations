# Pony

## Install

```bash
brew install ponyc
```

## Build

```bash
ponyc -b play
```

## Run

```bash
./play
```

## Notes

- Locals cannot reuse an enclosing method's name, so `alive_neighbours`
  accumulates into `alive_count` (see `Cell#alive_neighbours`).
- Actors only collect garbage between behaviours, so a `while true` loop would
  never free memory; fallback to a recursive behaviour (see `Play#_tick`).
- No support for native exceptions; emulated with `exit` (see `World#_add_cell`).
- No support for printf-style formatting (see `Play#_f`).
- No public infinity constant; fallback to `1 / 0` (see `Play#_lowest_tick`).
