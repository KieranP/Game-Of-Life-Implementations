# Dart

## Install

```bash
brew install dart-lang/dart/dart
```

## Build

```bash
dart compile exe -o play play.dart
```

## Run

```bash
./play
```

## Notes

- No support for unsigned integers; fallback to `int` (see `Cell#x`/`y`).
