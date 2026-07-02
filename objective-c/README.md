# Objective-C

## Install

Objective-C compiles with `clang`, included in the Xcode Command Line Tools:

```bash
xcode-select --install
```

## Build

```bash
clang -O3 -framework Foundation -o play *.m
```

## Run

```bash
./play
```

## Notes

- Method arguments interleave into the selector name (see `-[World makeKeyWithX:y:]`).
