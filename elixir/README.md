# Elixir

## Install

```bash
brew install elixir
```

## Build

(no build step required)

## Run

```bash
rm *.beam; elixirc *.ex
```

## Notes

- Elixir does not support pointers to other memory spaces. In otherwords, cell.neighbours cannot point to the same memory space as the matching Cell in world.cells. Therefore, in this implementation, cell.neighbours is a list of Cell coordinates ("x-y") rather than pointers, and we need to refetch the neighbouring cells from world.cell when determining alive neighbours. Since one of the goals of this repo is to keep the various implementations as similar as possible, this limitation introduces a signficant but unavoidable performance penalty compared to other languages.
