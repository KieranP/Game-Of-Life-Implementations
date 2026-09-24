# VLang

## Install

```bash
brew install vlang
```

## Build

```bash
v -prod -o play .
```

## Run

```bash
./play
```

## Notes

- Identifiers cannot start with an underscore, so the `_f` helper is named `f`
  (see `f` in play.v).
- No support for native exceptions; emulated with `panic` (see
  `World.add_cell`).
