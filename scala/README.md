# Scala

## Install

```bash
brew install scala
```

## Build

```bash
scalac *.scala
```

## Run

```bash
scala run -cp . -M Play
```

## Notes

- No support for unsigned integers; fallback to `Int` (see `Cell#x`/`y`).
