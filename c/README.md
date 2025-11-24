# C

## Install

```bash
brew install gcc
```

## Build

```bash
gcc -std=c23 -O3 -march=native -flto -o play *.c lib/*.c
```

## Run

```bash
./play
```

## Notes

- C does not have a built-in HashMap, so I have added a very basic implementation
