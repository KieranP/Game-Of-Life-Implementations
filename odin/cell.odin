package main

Cell :: struct {
  x: u32,
  y: u32,
  alive: bool,
  next_state: bool,
  neighbours: [dynamic]^Cell
}

new_cell :: proc(x: u32, y: u32, alive: bool) -> ^Cell {
  cell := new(Cell)
  cell.x = x
  cell.y = y
  cell.alive = alive

  return cell
}

cell_to_char :: proc(cell: ^Cell) -> u8 {
  return cell.alive ? 'o' : ' '
}

cell_alive_neighbours :: proc(cell: ^Cell) -> u32 {
  // The following is the fastest
  alive_neighbours := u32(0)
  for neighbour in cell.neighbours {
    if neighbour.alive {
      alive_neighbours += 1
    }
  }
  return alive_neighbours

  // The following is slower
  // alive_neighbours := u32(0)
  // count := len(cell.neighbours)
  // for i := 0; i < count; i += 1 {
  //   neighbour := cell.neighbours[i]
  //   if neighbour.alive {
  //     alive_neighbours += 1
  //   }
  // }
  // return alive_neighbours
}
