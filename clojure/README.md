# Clojure

## Install

```bash
brew install openjdk clojure
export PATH="$(brew --prefix openjdk)/bin:$PATH"
```

## Build

(no build step required)

## Run

```bash
clojure -M play.clj
```

## Notes

- No support for pointers/shared references (data is immutable); fallback to
  storing coordinate keys ("x-y") in `cell.neighbours` and refetching cells from
  `world.cells` — a significant performance penalty (see `alive-neighbours`).
- No support for mutable locals; fallback to `loop`/`recur` (see `run` in
  play.clj).
- No support for custom exception classes; emulated with `ex-info` (see
  `location-occupied-exception`).
