module World

open Cell
open System
open System.Text
open System.Collections.Generic

exception LocationOccupied of x:uint * y:uint with
  override this.Message =
    sprintf "LocationOccupied(%d-%d)" this.x this.y

type World(width: uint, height: uint) =
  let cells = new Dictionary<string, Cell>()

  let DIRECTIONS = [
    [-1; 1];  [0; 1];  [1; 1]; // above
    [-1; 0];           [1; 0]; // sides
    [-1; -1]; [0; -1]; [1; -1] // below
  ]

  member val tick = 0u with get,set

  member this._tick() =
    let cell_values = cells.Values

    // First determine the action for all cells
    for cell in cell_values do
      let alive_neighbours = cell.alive_neighbours()
      if (not cell.alive && alive_neighbours = 3) then
        cell.next_state <- true
      elif (alive_neighbours < 2 || alive_neighbours > 3) then
        cell.next_state <- false
      else
        cell.next_state <- cell.alive

    // Then execute the determined action for all cells
    for cell in cell_values do
      cell.alive <- cell.next_state

    this.tick <- this.tick + 1u

  member this.render() =
    // The following is slower
    // let mutable rendering = ""
    // for y in [0u..height-1u] do
    //   for x in [0u..width-1u] do
    //     let cell = this.cell_at(x, y)
    //     if cell.IsSome then
    //       rendering <- rendering + string(cell.Value.to_char())
    //   rendering <- rendering + "\n"
    // rendering

    // The following is slower
    // let mutable rendering = []
    // for y in [0u..height-1u] do
    //   rendering <- rendering @ [
    //     for x in [0u..width-1u] do
    //       let cell = this.cell_at(x, y)
    //       if cell.IsSome then
    //         cell.Value.to_char()
    //   ] @ ['\n']
    // String.Concat(rendering)

    // The following is the fastest
    let render_size = int (width * height + height)
    let rendering = new StringBuilder(render_size)
    for y in [0u..height-1u] do
      for x in [0u..width-1u] do
        let cell = this.cell_at(x, y)
        if cell.IsSome then
          rendering.Append(cell.Value.to_char())
          |> ignore
      rendering.Append('\n')
      |> ignore
    rendering.ToString()

  member this.populate_cells() =
    let random = Random()

    for y in [0u..height-1u] do
      for x in [0u..width-1u] do
        let alive = random.NextDouble() <= 0.2
        this.add_cell(x, y, alive)
        |> ignore

  member private this.cell_at(x, y): option<Cell> =
    let ok, v = cells.TryGetValue($"{x}-{y}")
    if ok then Some(v) else None

  member private this.add_cell(x, y, ?alive) =
    let alive = defaultArg alive false

    let existing = this.cell_at(x, y)
    if existing.IsSome then
      raise(LocationOccupied(x, y))

    let cell = new Cell(x, y, alive)
    cells.Add($"{x}-{y}", cell)
    true

  member this.prepopulate_neighbours() =
    for cell in cells.Values do
      let x = int(cell.x)
      let y = int(cell.y)

      for set in DIRECTIONS do
        let nx = x + set[0]
        let ny = y + set[1]

        if nx >= 0 && ny >= 0 then
          let ux = uint(nx)
          let uy = uint(ny)

          if ux < width && uy < height then
            let neighbour = this.cell_at(ux, uy)
            if neighbour.IsSome then
              cell.neighbours <- neighbour.Value :: cell.neighbours
