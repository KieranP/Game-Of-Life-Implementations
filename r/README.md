# R

## Install

```bash
brew install r
```

## Run

```bash
Rscript play.r
```

## Notes

- Identifiers cannot start with an underscore, so the `_f` helper is named `f` (see `f` in play.r).
- No support for unsigned integers; fallback to `numeric` (see `cell$x`/`y`).
