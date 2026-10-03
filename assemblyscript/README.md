# AssemblyScript

## Install

```bash
brew install node
npm install
```

## Build

```bash
npm run asbuild
```

## Run

### Wasmer

```bash
brew install wasmer
wasmer run build/release.wasm
```

### Wasmtime

```bash
brew install wasmtime
wasmtime run build/release.wasm
```

## Notes

- No support for native exceptions; emulated with `throw`, which aborts (see
  `World#addCell`).
- No support for optional/nullable booleans (see `Cell#nextState`).
- No support for printf-style formatting (see `Play#_f`).
