use "collections"
use "random"
use "time"
use "itertools"

class World
  let width: USize
  let height: USize
  var tick: U64 = 0
  let _cells: Map[String, Cell ref] = _cells.create()
  let _cached_directions: Array[Array[ISize]] = [
    [-1; 1];  [0; 1];  [1; 1]  // above
    [-1; 0];           [1; 0]  // sides
    [-1; -1]; [0; -1]; [1; -1] // below
  ]

  new create(width': USize, height': USize) =>
    width = width'
    height = height'

    populate_cells()
    prepopulate_neighbours()

  fun ref do_tick() =>
    // First determine the action for all cells
    for (key, cell) in _cells.pairs() do
      let alive_neighbours = _alive_neighbours_around(cell)
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
    for y in Range(0, height) do
      for x in Range(0, width) do
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
    // for y in Range(0, height) do
    //   for x in Range(0, width) do
    //     try
    //       var cell = _cell_at(x, y)?
    //       rendering.push(cell.to_char())
    //     end
    //   end
    //   rendering.push("\n")
    // end
    // String.join(rendering.values())

  fun ref populate_cells() =>
    let rand = Rand(Time.nanos())
    for y in Range(0, height) do
      for x in Range(0, width) do
        let alive = rand.int(100) <= 20
        _add_cell(x, y, alive)
      end
    end

  fun ref prepopulate_neighbours() =>
    for (key, cell) in _cells.pairs() do
      _neighbours_around(cell)
    end

  fun ref _add_cell(x: USize, y: USize, alive: Bool = false): Cell ref =>
    // Pony doesn't support runtime exceptions

    let key = x.string() + " " + y.string()
    let cell = Cell(x, y, alive)
    _cells.insert(consume key, cell)
    cell

  fun ref _cell_at(x: USize, y: USize): Cell ref ? =>
    let key = x.string() + " " + y.string()
    _cells(consume key)?

  fun ref _neighbours_around(cell: Cell ref): Array[Cell ref] =>
    if cell.neighbours.size() == 0 then
      for set in _cached_directions.values() do
        try
          let neighbour = _cell_at(
            (cell.x.isize() + set(0)?).usize(),
            (cell.y.isize() + set(1)?).usize()
          )?

          cell.neighbours.push(neighbour)
        end
      end
    end

    cell.neighbours

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  fun ref _alive_neighbours_around(cell: Cell ref): USize =>
    let neighbours = _neighbours_around(cell)

    // The following works but it slower
    // Iter[Cell](neighbours.values())
    //   .filter({(cell) => cell.alive })
    //   .count()

    // The following was the fastest method
    var alive_neighbours: USize = 0
    for neighbour in neighbours.values() do
      if neighbour.alive then
        alive_neighbours = alive_neighbours + 1
      end
    end
    alive_neighbours

    // The following works but it slower
    // var alive_neighbours: USize = 0
    // for i in Range(0, neighbours.size()) do
    //   try
    //     let neighbour = neighbours(i)?
    //     if neighbour.alive then
    //       alive_neighbours = alive_neighbours + 1
    //     end
    //   end
    // end
    // alive_neighbours

class Cell
  let x: USize
  let y: USize
  var alive: Bool
  var next_state: Bool = false
  var neighbours: Array[Cell ref] = []

  new create(x': USize, y': USize, alive': Bool = false) =>
    x = x'
    y = y'
    alive = alive'

  fun to_char(): String val =>
    if alive then
      "o"
    else
      " "
    end
