package main

type Cell struct {
  x int
  y int
  alive bool
  next_state bool
  neighbours []*Cell
}

func new_cell(x int, y int, alive bool) *Cell {
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

// Implement first using filter/lambda if available. Then implement
// foreach and for. Use whatever implementation runs the fastest
func (cell *Cell) alive_neighbours() int {
  // The following was the fastest method
  alive_neighbours := 0
  for _, neighbour := range cell.neighbours {
    if neighbour.alive {
      alive_neighbours++
    }
  }
  return alive_neighbours

  // The following also works but is slower
  // alive_neighbours := 0
  // for i := range(len(cell.neighbours)) {
  //   neighbour := cell.neighbours[i]
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours
}
