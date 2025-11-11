use "collections"
use "random"
use "time"

class World
  var tick: U32 = 0

  let _width: U32
  let _height: U32
  let _cells: Map[String, Cell ref] = _cells.create()

  let _directions: Array[Array[ISize]] = [
    [-1; 1];  [0; 1];  [1; 1]  // above
    [-1; 0];           [1; 0]  // sides
    [-1; -1]; [0; -1]; [1; -1] // below
  ]

  new create(width: U32, height: U32) =>
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

  fun ref render(): String ref =>
    // The following is the fastest
    var rendering = String()
    for y in Range[U32](0, _height) do
      for x in Range[U32](0, _width) do
        try
          var cell = _cell_at(x, y)?
          rendering.append(cell.to_char())
        end
      end
      rendering.append("\n")
    end
    rendering

    // The following is slower
    // var rendering: Array[String] = []
    // for y in Range[U32](0, _height) do
    //   for x in Range[U32](0, _width) do
    //     try
    //       var cell = _cell_at(x, y)?
    //       rendering.push(cell.to_char())
    //     end
    //   end
    //   rendering.push("\n")
    // end
    // String.join(rendering.values())

  fun ref _cell_at(x: U32, y: U32): Cell ref ? =>
    let key = x.string() + " " + y.string()
    _cells(consume key)?

  fun ref populate_cells() =>
    let rand = Rand(Time.nanos())
    for y in Range[U32](0, _height) do
      for x in Range[U32](0, _width) do
        let alive = rand.int(100) <= 20
        _add_cell(x, y, alive)
      end
    end

  fun ref _add_cell(x: U32, y: U32, alive: Bool = false): Bool =>
    // Pony doesn't support runtime exceptions

    let key = x.string() + " " + y.string()
    let cell = Cell(x, y, alive)
    _cells.insert(consume key, cell)
    true

  fun ref prepopulate_neighbours() =>
    for (key, cell) in _cells.pairs() do
      let x = cell.x.isize()
      let y = cell.y.isize()

      for set in _directions.values() do
        try
          let nx = (x + set(0)?)
          let ny = (y + set(1)?)
          if (nx < 0) or (ny < 0) then
            continue // Out of bounds
          end

          let ux = nx.u32()
          let uy = ny.u32()
          if (ux >= _width) or (uy >= _height) then
            continue // Out of bounds
          end

          let neighbour = _cell_at(ux, uy)?
          cell.neighbours.push(neighbour)
        end
      end
    end
