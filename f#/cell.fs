module Cell

type Cell(x: int, y: int, ?alive: bool) =
  member val x = x
  member val y = y
  member val alive = defaultArg alive false with get,set
  member val next_state = false with get,set
  member val neighbours: Cell list = [] with get,set

  member this.to_char() =
    if this.alive then 'o' else ' '

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  member this.alive_neighbours() =
    // The following works but is slower
    // let alive_neighbours = List.filter (fun (n: Cell) -> n.alive) this.neighbours
    // alive_neighbours.Length

    // The following was the fastest method
    let mutable alive_neighbours = 0
    for neighbour in this.neighbours do
      if neighbour.alive then
        alive_neighbours <- alive_neighbours + 1
    alive_neighbours

    // The following works but is slower
    // let mutable alive_neighbours = 0
    // for i in 0..this.neighbours.Length-1 do
    //   let neighbour = this.neighbours[i]
    //   if neighbour.alive then
    //     alive_neighbours <- alive_neighbours + 1
    // alive_neighbours
