# Kotlin

## Install

```bash
brew install kotlin
```

## Build

```bash
kotlinc *.kt
```

## Run

```bash
kotlin PlayKt
```

## Notes

- `UInt` is much slower (render ~40%, as `toString` goes through
  `Integer.toUnsignedString`); fallback to `Int` (see `Cell#x`/`y`).
