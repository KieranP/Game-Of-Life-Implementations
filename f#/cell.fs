module Cell

type Cell(x: uint, y: uint, ?alive: bool) =
  member val X = x
  member val Y = y
  member val Alive = defaultArg alive false with get,set
  member val NextState: bool option = None with get,set
  member val Neighbours: Cell list = [] with get,set

  member this.ToChar() =
    if this.Alive then 'o' else ' '

  member this.AliveNeighbours() =
    // The following is slower
    // let aliveNeighbours = List.filter (fun (n: Cell) -> n.Alive) this.Neighbours
    // uint aliveNeighbours.Length

    // The following is the fastest
    let mutable aliveNeighbours = 0u
    for neighbour in this.Neighbours do
      if neighbour.Alive then
        aliveNeighbours <- aliveNeighbours + 1u
    aliveNeighbours

    // The following is slower
    // let mutable aliveNeighbours = 0u
    // let count = this.Neighbours.Length
    // for i in 0..count-1 do
    //   let neighbour = this.Neighbours[i]
    //   if neighbour.Alive then
    //     aliveNeighbours <- aliveNeighbours + 1u
    // aliveNeighbours
