package main

type Cell struct {
  x uint32
  y uint32
  alive bool
  next_state bool
  neighbours []*Cell
}

func new_cell(x uint32, y uint32, alive bool) *Cell {
  var cell = new(Cell)
  cell.x = x
  cell.y = y
  cell.alive = alive

  return cell
}

func (cell *Cell) to_char() rune {
  if cell.alive {
    return 'o'
  } else {
    return ' '
  }
}

func (cell *Cell) alive_neighbours() uint32 {
  // The following is the fastest
  alive_neighbours := uint32(0)
  for _, neighbour := range cell.neighbours {
    if neighbour.alive {
      alive_neighbours++
    }
  }
  return alive_neighbours

  // The following is slower
  // alive_neighbours := uint32(0)
  // count := len(cell.neighbours)
  // for i := range(count) {
  //   neighbour := cell.neighbours[i]
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours
}
