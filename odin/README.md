# Odin

## Install

```bash
brew install odin
```

## Build

```bash
odin build . -o:speed --out=play
```

## Run

```bash
./play
```

## Notes

- No support for native exceptions; emulated with panic (see `world_add_cell`).
