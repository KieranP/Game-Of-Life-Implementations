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
  width: u32,
  height: u32,
  tick: u32,
  cells: map[string]^Cell
}

new_world :: proc(width: u32, height: u32) -> ^World {
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
  // The following is slower
  // rendering: [dynamic]u8
  // for y in 0..<world.height {
  //   for x in 0..<world.width {
  //     cell, ok := world_cell_at(world, x, y)
  //     if ok {
  //       append(&rendering, cell_to_char(cell))
  //     }
  //   }
  //   append(&rendering, "\n")
  // }
  // return string(rendering[:])

  // The following is the fastest
  render_size := int(world.width * world.height + world.height)
  rendering := strings.builder_make_len_cap(0, render_size)
  for y in 0..<world.height {
    for x in 0..<world.width {
      cell, ok := world_cell_at(world, x, y)
      if ok {
        strings.write_byte(&rendering, cell_to_char(cell))
      }
    }
    strings.write_byte(&rendering, '\n')
  }
  return strings.to_string(rendering)
}

world_cell_key :: proc(buf: []u8, x: u32, y: u32) -> string {
  n := len(strconv.write_uint(buf[:], u64(x), 10))
  buf[n] = '-'
  n += 1
  n += len(strconv.write_uint(buf[n:], u64(y), 10))
  return string(buf[:n])
}

world_cell_at :: proc(world: ^World, x: u32, y: u32) -> (^Cell, bool) {
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

world_add_cell :: proc(world: ^World, x: u32, y: u32, alive: bool = false) -> bool {
  _, ok := world_cell_at(world, x, y)
  if ok {
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
    x := int(cell.x)
    y := int(cell.y)

    for set in DIRECTIONS {
      nx := x + set[0]
      ny := y + set[1]
      if (nx < 0 || ny < 0) {
        continue // Out of bounds
      }

      ux := u32(nx)
      uy := u32(ny)
      if ux >= world.width || uy >= world.height {
        continue // Out of bounds
      }

      neighbour, ok := world_cell_at(world, ux, uy)
      if ok {
        append(&cell.neighbours, neighbour)
      }
    }
  }
}
