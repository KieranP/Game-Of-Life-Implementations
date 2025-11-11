import strings
import rand

struct LocationOccupied {
  Error
  x u32
  y u32
}

fn (e LocationOccupied) msg() string {
  return 'LocationOccupied(${e.x}-${e.y})'
}

const directions = [
  [-1, 1],  [0, 1],  [1, 1], // above
  [-1, 0],           [1, 0], // sides
  [-1, -1], [0, -1], [1, -1] // below
]

struct World {
  width u32
  height u32
mut:
  cells map[string]&Cell = {}
pub mut:
  tick u32
}

pub fn new_world(width u32, height u32) World {
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
    alive_neighbours := cell.alive_neighbours()
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

pub fn (w World) render() string {
  // The following is slower
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

  // The following is slower
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

  // The following is the fastest
  render_size := int(w.width * w.height + w.height)
  mut rendering := strings.new_builder(render_size)
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

fn (w World) cell_at(x u32, y u32) ?&Cell {
  return w.cells['$x-$y'] or {
    return none
  }
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

fn (mut w World) add_cell(x u32, y u32, alive bool) bool {
  if _ := w.cell_at(x, y) {
    panic(IError(LocationOccupied{ x: x, y: y }))
  }

  cell := &Cell {
    x: x,
    y: y,
    alive: alive
  }

  w.cells['$x-$y'] = cell
  return true
}

fn (mut w World) prepopulate_neighbours() {
  for _, mut cell in w.cells {
    x := int(cell.x)
    y := int(cell.y)

    for set in directions {
      nx := x + set[0]
      ny := y + set[1]
      if nx < 0 || ny < 0 {
        continue // Out of bounds
      }

      ux := u32(nx)
      uy := u32(ny)
      if ux >= w.width || uy >= w.height {
        continue // Out of bounds
      }

      if neighbour := w.cell_at(ux, uy) {
        cell.neighbours << neighbour
      }
    }
  }
}
