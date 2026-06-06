# Groovy

## Install

```bash
brew install java groovy
```

## Build

```bash
groovyc --compile-static *.groovy
```

## Run

```bash
groovy Play
```

## Notes

- No support for unsigned integers; fallback to `int` (see `Cell#x`/`y`).
