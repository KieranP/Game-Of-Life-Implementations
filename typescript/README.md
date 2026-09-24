# TypeScript

## Install

```bash
brew install typescript
```

## Build

```bash
tsc
```

## Run

### Bun

```bash
brew install oven-sh/bun/bun
bun run play.js
```

### Deno

```bash
brew install deno
deno run --allow-env play.js
```

### Node

```bash
brew install node
node play.js
```

## Notes

- No support for integer types; fallback to `number` (a 64-bit float) (see
  `Cell#x`/`y`).
