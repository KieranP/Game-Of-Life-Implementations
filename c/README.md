# C

## Install

```bash
brew install gcc
```

## Build

```bash
gcc -std=c23 -O3 -o play *.c lib/*.c
```

## Run

```bash
./play
```

## Notes

- No built-in HashMap, so I have added a very basic implementation
- No support for native exceptions; emulated with exit (see `add_cell`).
- No support for optional/nullable booleans (see `Cell.next_state`).
