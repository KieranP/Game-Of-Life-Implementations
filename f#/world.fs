module World

open System
open System.Text
open System.Collections.Generic

exception LocationOccupied of x:int * y:int with
  override this.Message =
    sprintf "LocationOccupied(%d-%d)" this.x this.y

type Cell(x, y, ?alive) =
  member val x = x
  member val y = y
  member val alive = defaultArg alive false with get,set
  member val next_state = false with get,set
  member val neighbours = [] with get,set

  member this.to_char() =
    if this.alive then "o" else " "

type World(width, height) =
  let cells = new Dictionary<string, Cell>()

  let DIRECTIONS = [
    [-1; 1];  [0; 1];  [1; 1]; // above
    [-1; 0];           [1; 0]; // sides
    [-1; -1]; [0; -1]; [1; -1] // below
  ]

  member val tick = 0 with get,set

  member this._tick() =
    // First determine the action for all cells
    for cell in cells.Values do
      let alive_neighbours = this.alive_neighbours_around(cell)
      if (not cell.alive && alive_neighbours = 3) then
        cell.next_state <- true
      elif (alive_neighbours < 2 || alive_neighbours > 3) then
        cell.next_state <- false
      else
        cell.next_state <- cell.alive

    // Then execute the determined action for all cells
    for cell in cells.Values do
      cell.alive <- cell.next_state

    this.tick <- this.tick + 1

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  member this.render() =
    // The following works but is slower
    // let mutable rendering = ""
    // for y in [0..height-1] do
    //   for x in [0..width-1] do
    //     let cell = this.cell_at(x, y)
    //     if cell.IsSome then
    //       rendering <- rendering + cell.Value.to_char()
    //   rendering <- rendering + "\n"
    // rendering

    // The following works but is slower
    // let mutable rendering = []
    // for y in [0..height-1] do
    //   rendering <- rendering @ [
    //     for x in [0..width-1] do
    //       let cell = this.cell_at(x, y)
    //       if cell.IsSome then
    //         cell.Value.to_char()
    //   ] @ ["\n"]
    // rendering |> String.concat ""

    // The following was the fastest method
    let rendering = new StringBuilder()
    for y in [0..height-1] do
      for x in [0..width-1] do
        let cell = this.cell_at(x, y)
        if cell.IsSome then
          rendering.Append(cell.Value.to_char())
          |> ignore
      rendering.Append("\n")
      |> ignore
    rendering.ToString()

  member this.populate_cells() =
    let random = Random()

    for y in [0..height-1] do
      for x in [0..width-1] do
        let alive = random.NextDouble() <= 0.2
        this.add_cell(x, y, alive)
        |> ignore

  member private this.cell_at(x, y): option<Cell> =
    let ok, v = cells.TryGetValue($"{x}-{y}")
    if ok then Some(v) else None

  member private this.add_cell(x, y, ?alive) =
    let alive = defaultArg alive false

    if this.cell_at(x, y).IsSome then
      raise(LocationOccupied(x, y))

    let cell = new Cell(x, y, alive)
    cells.Add($"{x}-{y}", cell)
    cell

  member this.prepopulate_neighbours() =
    for cell in cells.Values do
      for set in DIRECTIONS do
        let neighbour = this.cell_at(
          cell.x + set.[0],
          cell.y + set[1]
        )

        if neighbour.IsSome then
          cell.neighbours <- neighbour.Value :: cell.neighbours

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  member private this.alive_neighbours_around(cell) =
    // The following works but is slower
    // let alive_neighbours = List.filter (fun (n: Cell) -> n.alive) cell.neighbours
    // alive_neighbours.Length

    // The following was the fastest method
    let mutable alive_neighbours = 0
    for neighbour in cell.neighbours do
      if neighbour.alive then
        alive_neighbours <- alive_neighbours + 1
    alive_neighbours

    // The following works but is slower
    // let mutable alive_neighbours = 0
    // for i in 0..cell.neighbours.Length-1 do
    //   let neighbour = cell.neighbours[i]
    //   if neighbour.alive then
    //     alive_neighbours <- alive_neighbours + 1
    // alive_neighbours
