# Erlang

## Install

```bash
brew install erlang
```

## Build

```bash
erlc -W cell.erl world.erl
```

## Run

```bash
escript play.erl
```

## Notes

- Erlang doesn't have continuous loops (i.e. while(true) {}), so we need to use recursive function calls instead.
- Erlang's data structures are immutable, so cell.neighbours cannot point to the same memory space as the matching Cell in world.cells. Therefore, in this implementation, cell.neighbours is a list of Cell coordinates ("x-y") rather than pointers, and we need to refetch the neighbouring cells from world.cells when determining alive neighbours. Since one of the goals of this repo is to keep the various implementations as similar as possible, this limitation introduces a significant but unavoidable performance penalty compared to other languages.
