# Implementation

The following is a rough outline of how all implementations are written.

Language constraints may force specific implementations to vary from what is below.

For example, if a language does not support UInt32, then it may use Int32 instead.

Or if a language does not natively support classes, structs may be used.

But for the most part, each implementation will be similar to the following.

## File Structure

- play.ext
- world.ext
- cell.ext

## play.ext

```
class Play {
  private const WORLD_WIDTH: UInt32
  private const WORLD_HEIGHT: UInt32

  public static run(): void

  private static _f(value: Float64): Float64 // Or Double
}
```

## world.ext

```
class World {
  public var tick: UInt32

  private var width: UInt32
  private var height: UInt32
  private var cells: Map[String, Cell]
  private const DIRECTIONS: Array[Array[Int32, Int32]]

  public initialize(width: UInt32, height: UInt32): void

  public tick(): void // Or `dotick()` if `tick` clashes with variable name
  public render(): string

  private cell_at(x: UInt32, y: UInt32): Cell
  private populate_cells(): void
  private add_cell(x: UInt32, y: UInt32, alive: Bool = false): bool
  private prepopulate_neighbours(): void

  private class LocationOccupied inherits Exception
}
```

## cell.ext

```
class Cell {
  public var x: UInt32
  public var y: UInt32
  public var alive: Bool
  public var next_state: Bool | Nil
  public var neighbours: Array[Cell]

  initialize(x: UInt32, y: UInt32, alive: Bool = false): void

  public to_char(): Char // Or String
  public alive_neighbours(): UInt32
}
```
