# Fortran

## Install

```bash
brew install gcc
```

## Build

```bash
gfortran -O3 -o play cell.f90 hashmap.f90 world.f90 play.f90
```

## Run

```bash
./play
```

## Notes

- Identifiers are case-insensitive, so where variables are `world` and `cell` in other implementations, they are `w` and `c` so as not to conflict with the `World` and `Cell` types.
- Identifiers cannot start with an underscore, so the `_f` helper is named `f` (see `f` in play.f90).
- No built-in HashMap, so I have added a very basic implementation
- No support for native exceptions; emulated with stop (see `add_cell`).
- No support for unsigned integers; fallback to `integer` (see `Cell%x`/`y`).
- No support for optional/nullable booleans (see `Cell%next_state`).
