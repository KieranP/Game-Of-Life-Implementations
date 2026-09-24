# Lua

## Install

```bash
brew install lua luajit
```

## Build

(no build step required)

## Run

### Lua

```bash
lua play.lua
```

### LuaJIT

```bash
luajit -O3 play.lua
```

## Notes

- No support for native exceptions; emulated with `assert` (see
  `World:add_cell`).
- No support for sub-second wall-clock time; fallback to CPU time via `os.clock`
  (see `Play:run`).
