module World

open Cell
open System
open System.Text
open System.Collections.Generic

exception LocationOccupied of x:uint * y:uint with
  override this.Message =
    sprintf "LocationOccupied(%d-%d)" this.x this.y

type World(width: uint, height: uint) =
  let cells = Dictionary<string, Cell>()

  let directions = [
    (-1, 1);  (0, 1);  (1, 1); // above
    (-1, 0);           (1, 0); // sides
    (-1, -1); (0, -1); (1, -1) // below
  ]

  member val Tick = 0u with get,set

  member this.DoTick() =
    let cellValues = cells.Values

    // First determine the action for all cells
    for cell in cellValues do
      let aliveNeighbours = cell.AliveNeighbours()
      if (not cell.Alive && aliveNeighbours = 3) then
        cell.NextState <- Some true
      elif (aliveNeighbours < 2 || aliveNeighbours > 3) then
        cell.NextState <- Some false
      else
        cell.NextState <- Some cell.Alive

    // Then execute the determined action for all cells
    for cell in cellValues do
      cell.Alive <- cell.NextState |> Option.defaultValue false

    this.Tick <- this.Tick + 1u

  member this.Render() =
    // The following is slower
    // let mutable rendering = ""
    // for y in 0u..height-1u do
    //   for x in 0u..width-1u do
    //     let cell = this.CellAt(x, y)
    //     if cell.IsSome then
    //       rendering <- rendering + string(cell.Value.ToChar())
    //   rendering <- rendering + "\n"
    // rendering

    // The following is slower
    // let mutable rendering = []
    // for y in 0u..height-1u do
    //   rendering <- rendering @ [
    //     for x in 0u..width-1u do
    //       let cell = this.CellAt(x, y)
    //       if cell.IsSome then
    //         cell.Value.ToChar()
    //   ] @ ['\n']
    // String.Concat(rendering)

    // The following is the fastest
    let renderSize = int (width * height + height)
    let rendering = StringBuilder(renderSize)
    for y in 0u..height-1u do
      for x in 0u..width-1u do
        let cell = this.CellAt(x, y)
        if cell.IsSome then
          rendering.Append(cell.Value.ToChar()) |> ignore
      rendering.Append('\n') |> ignore
    rendering.ToString()

  member private this.MakeKey(x, y) =
    // The following is slower
    // $"{x}-{y}"

    // The following is the fastest
    x.ToString() + "-" + y.ToString()

    // The following is slower
    // String.concat "-" [x.ToString(); y.ToString()]

  member this.PopulateCells() =
    let random = Random()

    for y in 0u..height-1u do
      for x in 0u..width-1u do
        let alive = random.NextDouble() <= 0.2
        this.AddCell(x, y, alive)
        |> ignore

  member private this.CellAt(x, y): Cell option =
    let key = this.MakeKey(x, y)
    cells.TryGetValue key
    |> function
    | true, v -> Some v
    | _ -> None

  member private this.AddCell(x, y, ?alive) =
    let alive = defaultArg alive false

    let existing = this.CellAt(x, y)
    if existing.IsSome then
      raise(LocationOccupied(x, y))

    let key = this.MakeKey(x, y)
    let cell = Cell(x, y, alive)
    cells.Add(key, cell)
    true

  member this.PrepopulateNeighbours() =
    for cell in cells.Values do
      let x = int cell.X
      let y = int cell.Y

      for (relX, relY) in directions do
        let nx = x + relX
        let ny = y + relY

        if nx >= 0 && ny >= 0 then
          let ux = uint nx
          let uy = uint ny

          if ux < width && uy < height then
            let neighbour = this.CellAt(ux, uy)
            if neighbour.IsSome then
              cell.Neighbours <- neighbour.Value :: cell.Neighbours
