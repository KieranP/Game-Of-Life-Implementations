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

- Fortran does not have a built-in HashMap, so I have added a very basic implementation
- Fortran is case-insensitive, so where variables are `world` and `cell` in other implemenations, they are `w` and `c` in Fotran so as not to conflict with the `World` and `Cell` types.
