# Lua

## Install

```bash
brew install lua luajit
```

## Build

(No build step required)

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

- No support for native exceptions; emulated with assert (see `World:add_cell`).
