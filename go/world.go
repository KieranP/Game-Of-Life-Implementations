package main

import (
  "fmt"
  "math/rand"
  "strconv"
  "strings"
)

type LocationOccupied struct {
  x, y uint32
}

func (e LocationOccupied) Error() string {
  return fmt.Sprintf("LocationOccupied(%d-%d)", e.x, e.y)
}

var DIRECTIONS = [8][2]int{
  {-1, 1},  {0, 1},  {1, 1},  // above
  {-1, 0},           {1, 0},  // sides
  {-1, -1}, {0, -1}, {1, -1}, // below
}

type World struct {
  tick uint32
  width uint32
  height uint32
  cells map[string]*Cell
}

func new_world(width uint32, height uint32) *World {
  world := new(World)
  world.width = width
  world.height = height
  world.cells = make(map[string]*Cell, width*height)

  world.populate_cells()
  world.prepopulate_neighbours()

  return world
}

func (world *World) dotick() {
  // First determine the action for all cells
  for _, cell := range world.cells {
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
  for _, cell := range world.cells {
    cell.alive = cell.next_state
  }

  world.tick++
}

func (world *World) render() string {
  // The following is slower
  // rendering := ""
  // for y := range(world.height) {
  //   for x := range(world.width) {
  //     cell, ok := world.cell_at(x, y)
  //     if ok {
  //       rendering += string(cell.to_char())
  //     }
  //   }
  //   rendering += "\n"
  // }
  // return rendering

  // The following is slower
  // rendering := []string{}
  // for y := range(world.height) {
  //   for x := range(world.width) {
  //     cell, ok := world.cell_at(x, y)
  //     if ok {
  //       rendering = append(rendering, string(cell.to_char()))
  //     }
  //   }
  //   rendering = append(rendering, "\n")
  // }
  // return strings.Join(rendering, "")

  // The following is the fastest
  render_size := int(world.width * world.height + world.height)
  rendering := strings.Builder{}
  rendering.Grow(render_size)
  for y := range(world.height) {
    for x := range(world.width) {
      cell, ok := world.cell_at(x, y)
      if ok {
        rendering.WriteRune(cell.to_char())
      }
    }
    rendering.WriteRune('\n')
  }
  return rendering.String()
}

func (world *World) make_key(buf []byte, x uint32, y uint32) int {
  // The following is slower
  // s := fmt.Sprintf("%d-%d", x, y)
  // copy(buf, s)
  // return len(s)

  // The following is slower
  // s := strconv.Itoa(int(x)) + "-" + strconv.Itoa(int(y))
  // copy(buf, s)
  // return len(s)

  // The following is slower
  // s := strings.Join([]string{strconv.Itoa(int(x)), strconv.Itoa(int(y))}, "-")
  // copy(buf, s)
  // return len(s)

  // The following is the fastest
  b := strconv.AppendUint(buf[:0], uint64(x), 10)
  b = append(b, '-')
  b = strconv.AppendUint(b, uint64(y), 10)
  return len(b)
}

func (world *World) cell_at(x uint32, y uint32) (*Cell, bool) {
  var buf [24]byte
  n := world.make_key(buf[:], x, y)
  key := string(buf[:n])

  cell, ok := world.cells[key]
  return cell, ok
}

func (world *World) populate_cells() {
  for y := range(world.height) {
    for x := range(world.width) {
      alive := rand.Intn(100) <= 20
      world.add_cell(x, y, alive)
    }
  }
}

func (world *World) add_cell(x uint32, y uint32, alive bool) bool {
  _, ok := world.cell_at(x, y)
  if ok {
    panic(LocationOccupied{ x: x, y: y })
  }

  var buf [24]byte
  n := world.make_key(buf[:], x, y)
  key := string(buf[:n])

  cell := new_cell(x, y, alive)
  world.cells[key] = cell
  return true
}

func (world *World) prepopulate_neighbours() {
  for _, cell := range world.cells {
    x := int(cell.x)
    y := int(cell.y)

    for _, set := range DIRECTIONS {
      nx := x + set[0]
      ny := y + set[1]
      if nx < 0 || ny < 0 {
        continue // Out of bounds
      }

      ux := uint32(nx)
      uy := uint32(ny)
      if ux >= world.width || uy >= world.height {
        continue // Out of bounds
      }

      neighbour, ok := world.cell_at(ux, uy)
      if ok {
        cell.neighbours = append(cell.neighbours, neighbour)
      }
    }
  }
}
