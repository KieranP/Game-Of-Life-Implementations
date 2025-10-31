struct Cell {
pub:
  x int
  y int
pub mut:
  alive bool
  next_state bool
  neighbours []&Cell
}

fn (self Cell) to_char() string {
  if self.alive {
    return 'o'
  } else {
    return ' '
  }
}

// Implement first using filter/lambda if available. Then implement
// foreach and for. Use whatever implementation runs the fastest
fn (self Cell) alive_neighbours() int {
  // The following was the fastest method
  return self.neighbours.count(it.alive)

  // The following works but is slower
  // return self.neighbours.filter(fn (neighbour &Cell) bool {
  //   return neighbour.alive
  // }).len

  // The following works and is the same speed
  // mut alive_neighbours := 0
  // for _, neighbour in self.neighbours {
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours

  // The following works but is slower
  // mut alive_neighbours := 0
  // for i in 0 .. self.neighbours.len {
  //   neighbour := self.neighbours[i]
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours
}
