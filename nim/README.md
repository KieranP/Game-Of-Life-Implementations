# Nim

## Install

```bash
brew install nim
```

## Build

```bash
nim c -d:release --passC:"-O3" --passC:"-march=native" --passC:"-flto" play.nim
```

## Run

```bash
./play
```
