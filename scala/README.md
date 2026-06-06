# Scala

## Install

```bash
brew install java scala
```

## Build

```bash
scalac *.scala
```

## Run

```bash
scala run -cp . -M play
```

## Notes

- No support for unsigned integers; fallback to `Int` (see `Cell#x`/`y`).
