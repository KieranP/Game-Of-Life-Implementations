# OCaml

## Install

```bash
brew install ocaml
```

## Build

```bash
ocamlopt -O3 -o play cell.ml world.ml play.ml
```

## Run

```bash
./play
```

## Notes

- No support for unsigned integers; fallback to `int` (see `cell#x`/`y`).
