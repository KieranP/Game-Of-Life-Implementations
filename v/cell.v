struct Cell {
pub:
  x u32
  y u32
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

fn (self Cell) alive_neighbours() u32 {
  // The following is the fastest
  return u32(self.neighbours.count(it.alive))

  // The following is slower
  // return u32(
  //   self.neighbours.filter(fn (neighbour &Cell) bool {
  //     return neighbour.alive
  //   }).len
  // )

  // The following is about the same speed
  // mut alive_neighbours := u32(0)
  // for _, neighbour in self.neighbours {
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours

  // The following is slower
  // mut alive_neighbours := u32(0)
  // count := self.neighbours.len
  // for i in 0..count {
  //   neighbour := self.neighbours[i]
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours
}
