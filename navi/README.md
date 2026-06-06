# Navi

## Install

```bash
curl -sSL https://navi-lang.org/install | bash
```

## Build

(no build step required)

## Run

```bash
navi run
```

## Notes

- No support for unsigned integers; fallback to `int` (see `Cell#x`/`y`).
- No support for printf-style formatting (see `Play#_f`).
