# Haskell

## Install

```bash
brew install ghc cabal-install
cabal update
cabal install --lib random containers deepseq
```

## Build

```bash
ghc -O2 -main-is Play.run Play.hs -o play
```

## Run

```bash
./play
```

## Notes

- No support for pointers/shared references (data is immutable); fallback to storing coordinate keys ("x-y") in `cell.neighbours` and refetching cells from `world.cells` — a significant performance penalty (see `Cell.aliveNeighbours`).
- No support for continuous loops; fallback to recursive function calls (see `Play.loop`).
- No support for random numbers in the standard library; fallback to the `random` package (see `World.populateCells`).
