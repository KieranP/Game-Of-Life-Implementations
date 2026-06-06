# PHP

## Install

```bash
brew install php
```

## Build

(no build step required)

## Run

### Without JIT

```bash
php play.php
```

### With JIT

```bash
php -c jit.ini play.php
```

## Notes

- No support for unsigned integers; fallback to `int` (see `Cell#x`/`y`).
