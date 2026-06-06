# Ballerina

## Install

```bash
brew install ballerina
```

## Build

```bash
bal build
```

## Run

```bash
bal run target/bin/ballerina.jar
```

## Notes

- No support for native exceptions; emulated with error values (see `World#addCell`).
- No support for printf-style formatting (see `Play#_f`).
