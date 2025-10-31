package main

Cell :: struct {
  x: int,
  y: int,
  alive: bool,
  next_state: bool,
  neighbours: [dynamic]^Cell
}

new_cell :: proc(x: int, y: int, alive: bool) -> ^Cell {
  cell := new(Cell)
  cell.x = x
  cell.y = y
  cell.alive = alive

  return cell
}

cell_to_char :: proc(cell: ^Cell) -> rune {
  return cell.alive ? 'o' : ' '
}

cell_alive_neighbours :: proc(cell: ^Cell) -> int {
  // The following was the fastest method
  alive_neighbours := 0
  for neighbour in cell.neighbours {
    if neighbour.alive {
      alive_neighbours += 1
    }
  }
  return alive_neighbours

  // The following also works but is slower
  // alive_neighbours := 0
  // for i := 0; i < len(cell.neighbours); i += 1 {
  //   neighbour := cell.neighbours[i]
  //   if neighbour.alive {
  //     alive_neighbours += 1
  //   }
  // }
  // return alive_neighbours
}
