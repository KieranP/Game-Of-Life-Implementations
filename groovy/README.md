# Groovy

## Install

```bash
brew install groovy
```

## Build

(no build step required)

## Run

```bash
groovy --compile-static Play
```

## Notes

- No support for unsigned integers; fallback to `int` (see `Cell#x`/`y`).
