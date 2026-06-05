package main

type Cell struct {
  x uint32
  y uint32
  alive bool
  nextState bool
  neighbours []*Cell
}

func newCell(x uint32, y uint32, alive bool) *Cell {
  return &Cell{x: x, y: y, alive: alive}
}

func (cell *Cell) toChar() rune {
  if cell.alive {
    return 'o'
  } else {
    return ' '
  }
}

func (cell *Cell) aliveNeighbours() uint32 {
  // The following is the fastest
  aliveNeighbours := uint32(0)
  for _, neighbour := range cell.neighbours {
    if neighbour.alive {
      aliveNeighbours++
    }
  }
  return aliveNeighbours

  // The following is slower
  // aliveNeighbours := uint32(0)
  // count := len(cell.neighbours)
  // for i := range count {
  //   neighbour := cell.neighbours[i]
  //   if neighbour.alive {
  //     aliveNeighbours++
  //   }
  // }
  // return aliveNeighbours
}
