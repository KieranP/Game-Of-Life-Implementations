# PonyLang

## Install

```bash
brew install ponyc
```

## Build

```bash
ponyc -b play
```

## Run

```bash
./play
```

## Notes

- No support for continuous loops (actor-based); fallback to a recursive behaviour (see `Main#tick`).
- No support for native exceptions; occupied locations are silently skipped (see `World#_add_cell`).
- No support for printf-style formatting (see `Main#_f`).
