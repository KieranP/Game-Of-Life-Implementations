# Go

## Install

```bash
brew install go
```

## Build

```bash
go build -o play *.go
```

## Run

```bash
./play
```

## Notes

- No support for native exceptions; emulated with panic (see `World#addCell`).
- No support for optional/nullable booleans (see `Cell#nextState`).
