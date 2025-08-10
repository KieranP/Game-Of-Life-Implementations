package main

import "core:fmt"
import "core:math/rand"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

DIRECTIONS := [8][2]int{
  {-1, 1},  {0, 1},  {1, 1},  // above
  {-1, 0},           {1, 0},  // sides
  {-1, -1}, {0, -1}, {1, -1}, // below
}

World :: struct {
  width: int,
  height: int,
  tick: i64,
  cells: map[string]^Cell
}

new_world :: proc(width: int, height: int) -> ^World {
  world := new(World)
  world.width = width
  world.height = height

  world_populate_cells(world)
  world_prepopulate_neighbours(world)

  return world
}

world_tick :: proc(world: ^World) {
  // First determine the action for all cells
  for _, cell in world.cells {
    alive_neighbours := world_alive_neighbours_around(world, cell)
    if !cell.alive && alive_neighbours == 3 {
      cell.next_state = true
    } else if alive_neighbours < 2 || alive_neighbours > 3 {
      cell.next_state = false
    } else {
      cell.next_state = cell.alive
    }
  }

  // Then execute the determined action for all cells
  for _, cell in world.cells {
    cell.alive = cell.next_state
  }

  world.tick += 1
}

world_render :: proc(world: ^World) -> string {
  // The following works but is slower
  // rendering: [dynamic]string
  // for y in 0..<world.height {
  //   for x in 0..<world.width {
  //     cell, _ := world_cell_at(world, x, y)
  //     append(&rendering, utf8.runes_to_string({cell_to_char(cell)}))
  //   }
  //   append(&rendering, "\n")
  // }
  // return strings.concatenate(rendering[:])

  // The following was the fastest method
  rendering := strings.builder_make()
  for y in 0..<world.height {
    for x in 0..<world.width {
      cell, _ := world_cell_at(world, x, y)
      strings.write_rune(&rendering, cell_to_char(cell))
    }
    strings.write_rune(&rendering, '\n')
  }
  return strings.to_string(rendering)
}

world_cell_key :: proc(x: int, y: int) -> string {
  buf1: [3]byte
  xs := strconv.itoa(buf1[:], x)

  buf2: [3]byte
  ys := strconv.itoa(buf2[:], y)

  return strings.join({xs, ys}, "-")
}

world_cell_at :: proc(world: ^World, x: int, y: int) -> (^Cell, bool) {
  key := world_cell_key(x, y)
  return world.cells[key]
}

world_populate_cells :: proc(world: ^World) {
  for y in 0..<world.height {
    for x in 0..<world.width {
      alive := (rand.float32() <= 0.2)
      world_add_cell(world, x, y, alive)
    }
  }
}

world_add_cell :: proc(world: ^World, x: int, y: int, alive: bool = false) -> ^Cell {
  if _, ok := world_cell_at(world, x, y); ok {
    panic(fmt.aprintf("LocationOccupied(%d-%d)", x, y))
  }

  cell := new_cell(x, y, alive)
  key := world_cell_key(x, y)
  world.cells[key] = cell
  return cell
}

world_prepopulate_neighbours :: proc(world: ^World) {
  for _, cell in world.cells {
    for set in DIRECTIONS {
      neighbour, ok := world_cell_at(
        world,
        cell.x + set[0],
        cell.y + set[1]
      )

      if ok {
        append(&cell.neighbours, neighbour)
      }
    }
  }
}

world_alive_neighbours_around :: proc(world: ^World, cell: ^Cell) -> int {
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
