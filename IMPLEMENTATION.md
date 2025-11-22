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

### play.ext

```
class Play {
  private const WORLD_WIDTH: UInt32
  private const WORLD_HEIGHT: UInt32

  public static run(): void

  private static _f(value: Float64): Float64 // Or Double
}
```

### world.ext

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

The `render` function should demonstrate several different ways of making the desired output. Comment out all but the fastest. Different approaches include:

1. String Concatenation

```
rendering = ""
rendering << cell.to_char()
rendering
```

2. Append Strings to Array and Join

```
rendering = []
rendering << cell.to_char()
rendering.join
```

3. String Builder (if the language has a built-in one)

```
render_size = width * height + height
rendering = StringBuilder.new(render_size)
rendering << cell.to_char()
rendering.to_s
```

4. Simulate String Builder (Preallocate U8 Array, Insert by Index)

```
render_size = width * height + height
rendering = Array.new(render_size)
idx = 0
rendering[idx] = cell.to_char()
String(rendering)
```

### cell.ext

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

The `alive_neighbours` function should demonstrate several different ways of calculating the desired output. Comment out all but the fastest. Different approaches include:

1. Lamdba/Anonymous Function

```
neighbours.count(&:alive)
```

2. Loop over neighbour array and increment counter

```
alive_neighbours = 0
for (neighbour in neighbours) {
  if (neighbour.alive) {
    alive_neighbours += 1
  }
}
alive_neighbours
```

3. Traditional for loop with index access

```
alive_neighbours = 0
count = neighbours.length
for (i = 0; i < count; i++) {
  neighbour = neighbours[i]
  if (neighbour.alive) {
    alive_neighbours += 1
  }
}
alive_neighbours
```
