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
    alive_neighbours := cell_alive_neighbours(cell)
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
  total_size := world.width * world.height + world.height
  rendering := strings.builder_make_len(total_size)
  for y in 0..<world.height {
    for x in 0..<world.width {
      cell, _ := world_cell_at(world, x, y)
      strings.write_rune(&rendering, cell_to_char(cell))
    }
    strings.write_rune(&rendering, '\n')
  }
  return strings.to_string(rendering)
}

world_cell_key :: proc(buf: []u8, x: int, y: int) -> string {
  n := len(strconv.write_int(buf[:], i64(x), 10))
  buf[n] = '-'
  n += 1
  n += len(strconv.write_int(buf[n:], i64(y), 10))
  return string(buf[:n])
}

world_cell_at :: proc(world: ^World, x: int, y: int) -> (^Cell, bool) {
  buf: [32]u8
  key := world_cell_key(buf[:], x, y)
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

world_add_cell :: proc(world: ^World, x: int, y: int, alive: bool = false) -> bool {
  if _, ok := world_cell_at(world, x, y); ok {
    panic(fmt.aprintf("LocationOccupied(%d-%d)", x, y))
  }

  buf: [32]u8
  key := world_cell_key(buf[:], x, y)

  cell := new_cell(x, y, alive)
  key = strings.clone(key)
  world.cells[key] = cell
  return true
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
