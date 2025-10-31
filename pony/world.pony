use "collections"
use "random"
use "time"

class World
  var tick: U64 = 0

  let _width: USize
  let _height: USize
  let _cells: Map[String, Cell ref] = _cells.create()

  let _directions: Array[Array[ISize]] = [
    [-1; 1];  [0; 1];  [1; 1]  // above
    [-1; 0];           [1; 0]  // sides
    [-1; -1]; [0; -1]; [1; -1] // below
  ]

  new create(width: USize, height: USize) =>
    _width = width
    _height = height

    populate_cells()
    prepopulate_neighbours()

  fun ref do_tick() =>
    // First determine the action for all cells
    for (key, cell) in _cells.pairs() do
      let alive_neighbours = cell.alive_neighbours()
      if (not cell.alive) and (alive_neighbours == 3) then
        cell.next_state = true
      elseif (alive_neighbours < 2) or (alive_neighbours > 3) then
        cell.next_state = false
      else
        cell.next_state = cell.alive
      end
    end

    // Then execute the determined action for all cells
    for (key, cell) in _cells.pairs() do
      cell.alive = cell.next_state
    end

    tick = tick + 1

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  fun ref render(): String ref =>
    // The following was the fastest method
    var rendering = String()
    for y in Range(0, _height) do
      for x in Range(0, _width) do
        try
          var cell = _cell_at(x, y)?
          rendering.append(cell.to_char())
        end
      end
      rendering.append("\n")
    end
    rendering

    // The following works but it slower
    // var rendering: Array[String] = []
    // for y in Range(0, _height) do
    //   for x in Range(0, _width) do
    //     try
    //       var cell = _cell_at(x, y)?
    //       rendering.push(cell.to_char())
    //     end
    //   end
    //   rendering.push("\n")
    // end
    // String.join(rendering.values())

  fun ref _cell_at(x: USize, y: USize): Cell ref ? =>
    let key = x.string() + " " + y.string()
    _cells(consume key)?

  fun ref populate_cells() =>
    let rand = Rand(Time.nanos())
    for y in Range(0, _height) do
      for x in Range(0, _width) do
        let alive = rand.int(100) <= 20
        _add_cell(x, y, alive)
      end
    end

  fun ref _add_cell(x: USize, y: USize, alive: Bool = false): Bool =>
    // Pony doesn't support runtime exceptions

    let key = x.string() + " " + y.string()
    let cell = Cell(x, y, alive)
    _cells.insert(consume key, cell)
    true

  fun ref prepopulate_neighbours() =>
    for (key, cell) in _cells.pairs() do
      for set in _directions.values() do
        try
          let neighbour = _cell_at(
            (cell.x.isize() + set(0)?).usize(),
            (cell.y.isize() + set(1)?).usize()
          )?

          cell.neighbours.push(neighbour)
        end
      end
    end
