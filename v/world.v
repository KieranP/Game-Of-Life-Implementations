import strings
import rand

struct LocationOccupied {
	Error
}

struct World {
  width int
  height int
  cached_directions [][]int = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ]
mut:
  cells map[string]&Cell = {}
pub mut:
  tick int
}

pub fn new_world(width int, height int) World {
  mut w := World {
    width: width,
    height: height
  }

  w.populate_cells()
  w.prepopulate_neighbours()
  return w
}

pub fn (mut w World) tick() {
  // First determine the action for all cells
  for _, mut cell in w.cells {
    alive_neighbours := w.alive_neighbours_around(mut *cell)
    if !cell.alive && alive_neighbours == 3 {
      cell.next_state = true
    } else if alive_neighbours < 2 || alive_neighbours > 3 {
      cell.next_state = false
    } else {
      cell.next_state = cell.alive
    }
  }

  // Then execute the determined action for all cells
  for _, mut cell in w.cells {
    cell.alive = cell.next_state
  }

  w.tick++
}

// Implement first using string concatenation. Then implement any
// special string builders, and use whatever runs the fastest
pub fn (w World) render() string {
  // The following works but is slower
  // mut rendering := ''
  // for y in 0 .. w.height {
  //   for x in 0 .. w.width {
  //     if cell := w.cell_at(x, y) {
  //       rendering += cell.to_char()
  //     }
  //   }
  //   rendering += '\n'
  // }
  // return rendering

  // The following works but is slower
  // mut rendering := []string{}
  // for y in 0 .. w.height {
  //   for x in 0 .. w.width {
  //     if cell := w.cell_at(x, y) {
  //       rendering << cell.to_char()
  //     }
  //   }
  //   rendering << '\n'
  // }
  // return rendering.join('')

  // The following was the fastest method
  mut rendering := strings.new_builder(0)
  for y in 0 .. w.height {
    for x in 0 .. w.width {
      if cell := w.cell_at(x, y) {
        rendering.write_string(cell.to_char())
      }
    }
    rendering.write_string('\n')
  }
  return rendering.str()
}

fn (mut w World) populate_cells() {
  for y in 0 .. w.height {
    for x in 0 .. w.width {
      num := rand.intn(100) or { 0 }
      alive := num <= 20
      w.add_cell(x, y, alive)
    }
  }
}

fn (mut w World) prepopulate_neighbours() {
  for _, mut cell in w.cells {
    w.neighbours_around(mut *cell)
  }
}

fn (mut w World) add_cell(x int, y int, alive bool) &Cell {
  if _ := w.cell_at(x, y) {
    panic(IError(LocationOccupied{}))
  }

  cell := &Cell {
    x: x,
    y: y,
    alive: alive
  }

  w.cells['$x-$y'] = cell
  return cell
}

fn (w World) cell_at(x int, y int) !&Cell {
  return unsafe { w.cells['$x-$y']! }
}

fn (w World) neighbours_around(mut cell Cell) []&Cell {
  return cell.neighbours or {
    mut neighbours := []&Cell{}

    for set in w.cached_directions {
      if neighbour := w.cell_at(
        (cell.x + set[0]),
        (cell.y + set[1])
      ) {
        neighbours << neighbour
      }
    }

    cell.neighbours = neighbours
    neighbours
  }
}

// Implement first using filter/lambda if available. Then implement
// foreach and for. Use whatever implementation runs the fastest
fn (w World) alive_neighbours_around(mut cell &Cell) int {
  neighbours := w.neighbours_around(mut *cell)

  // The following was the fastest method
  return neighbours.count(it.alive)

  // The following works but is slower
  // return neighbours.filter(fn (neighbour &Cell) bool {
  //   return neighbour.alive
  // }).len

  // The following works and is the same speed
  // mut alive_neighbours := 0
  // for _, neighbour in neighbours {
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours

  // The following works but is slower
  // mut alive_neighbours := 0
  // for i in 0 .. neighbours.len {
  //   neighbour := neighbours[i]
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours
}

struct Cell {
pub:
  x int
  y int
pub mut:
  alive bool
  next_state bool
  neighbours ?[]&Cell
}

fn (c Cell) to_char() string {
  if c.alive {
    return 'o'
  } else {
    return ' '
  }
}
