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
- No support for continuous loops (actor-based); fallback to a recursive
  behaviour (see `Main#tick`).
- No support for native exceptions; emulated with union-type error values (see
  `World#_add_cell`).
- No support for printf-style formatting (see `Main#_f`).
