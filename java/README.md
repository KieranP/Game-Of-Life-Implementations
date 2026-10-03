# Java

## Install

```bash
brew install openjdk
export PATH="$(brew --prefix openjdk)/bin:$PATH"
```

## Build

```bash
javac *.java
```

## Run

```bash
java Play
```

## Notes

- No support for unsigned integers; fallback to `int` (see `Cell#x`/`y`).
