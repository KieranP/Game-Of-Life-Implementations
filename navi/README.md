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
- No infinity literal or float max constant in the standard library; fallback to `1.0 / 0.0` (see `INFINITY` in play.nv).
