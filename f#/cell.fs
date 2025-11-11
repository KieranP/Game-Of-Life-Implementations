module Cell

type Cell(x: uint, y: uint, ?alive: bool) =
  member val x = x
  member val y = y
  member val alive = defaultArg alive false with get,set
  member val next_state = false with get,set
  member val neighbours: Cell list = [] with get,set

  member this.to_char() =
    if this.alive then 'o' else ' '

  member this.alive_neighbours() =
    // The following is slower
    // let alive_neighbours = List.filter (fun (n: Cell) -> n.alive) this.neighbours
    // alive_neighbours.Length

    // The following is the fastest
    let mutable alive_neighbours = 0
    for neighbour in this.neighbours do
      if neighbour.alive then
        alive_neighbours <- alive_neighbours + 1
    alive_neighbours

    // The following is slower
    // let mutable alive_neighbours = 0
    // let count = this.neighbours.Length-1
    // for i in 0..count do
    //   let neighbour = this.neighbours[i]
    //   if neighbour.alive then
    //     alive_neighbours <- alive_neighbours + 1
    // alive_neighbours
