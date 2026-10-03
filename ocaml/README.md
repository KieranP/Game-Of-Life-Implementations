# OCaml

## Install

```bash
brew install ocaml
```

## Build

```bash
ocamlopt -I +runtime_events runtime_events.cmxa -o play cell.ml world.mli world.ml play.ml
```

## Run

```bash
./play
```

## Notes

- No support for unsigned integers; fallback to `int` (see `cell#x`/`y`).
