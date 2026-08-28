# Nim

## Install

```bash
brew install nim
```

## Build

```bash
nim c -d:release --passC:"-O3" play.nim
```

## Run

```bash
./play
```

## Notes

- Identifiers cannot start with an underscore, so the `_f` helper is named `f` (see `f` in play.nim).
