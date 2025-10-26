package main

import (
  "fmt"
  "math/rand"
  "strconv"
  "strings"
)

type LocationOccupied struct {
  x, y int
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
  tick int64
  width int
  height int
  cells map[string]*Cell
}

func new_world(width int, height int) *World {
  world := new(World)
  world.width = width
  world.height = height
  world.cells = make(map[string]*Cell, width*height)

  world.populate_cells()
  world.prepopulate_neighbours()

  return world
}

func (world *World) _tick() {
  // First determine the action for all cells
  for _, cell := range world.cells {
    alive_neighbours := world.alive_neighbours_around(cell)
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

// Implement first using string concatenation. Then implement any
// special string builders, and use whatever runs the fastest
func (world *World) render() string {
  // The following works but is slower
  // rendering := ""
  // for y := range(world.height) {
  //   for x := range(world.width) {
  //     cell, _ := world.cell_at(x, y)
  //     rendering += string(cell.to_char())
  //   }
  //   rendering += "\n"
  // }
  // return rendering

  // The following works but is slower
  // rendering := []string{}
  // for y := range(world.height) {
  //   for x := range(world.width) {
  //     cell, _ := world.cell_at(x, y)
  //     rendering = append(rendering, string(cell.to_char()))
  //   }
  //   rendering = append(rendering, "\n")
  // }
  // return strings.Join(rendering, "")

  // The following was the fastest method
  rendering := strings.Builder{}
  rendering.Grow(world.width * world.height + world.height)
  for y := range(world.height) {
    for x := range(world.width) {
      cell, _ := world.cell_at(x, y)
      rendering.WriteRune(cell.to_char())
    }
    rendering.WriteRune('\n')
  }
  return rendering.String()
}

func (world *World) cell_at(x int, y int) (*Cell, bool) {
  key := strconv.Itoa(x) + "-" + strconv.Itoa(y)
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

func (world *World) add_cell(x int, y int, alive bool) *Cell {
  if _, ok := world.cell_at(x, y); ok {
    panic(LocationOccupied{ x: x, y: y })
  }

  cell := new_cell(x, y, alive)
  key := strconv.Itoa(x) + "-" + strconv.Itoa(y)
  world.cells[key] = cell
  return cell
}

func (world *World) prepopulate_neighbours() {
  for _, cell := range world.cells {
    for _, set := range DIRECTIONS {
      neighbour, ok := world.cell_at(
        cell.x + set[0],
        cell.y + set[1],
      )

      if ok {
        cell.neighbours = append(cell.neighbours, neighbour)
      }
    }
  }
}

// Implement first using filter/lambda if available. Then implement
// foreach and for. Use whatever implementation runs the fastest
func (world *World) alive_neighbours_around(cell *Cell) int {
  // The following was the fastest method
  alive_neighbours := 0
  for _, neighbour := range cell.neighbours {
    if neighbour.alive {
      alive_neighbours++
    }
  }
  return alive_neighbours

  // The following also works but is slower
  // alive_neighbours := 0
  // for i := range(len(cell.neighbours)) {
  //   neighbour := cell.neighbours[i]
  //   if neighbour.alive {
  //     alive_neighbours++
  //   }
  // }
  // return alive_neighbours
}

type Cell struct {
  x int
  y int
  alive bool
  next_state bool
  neighbours []*Cell
}

func new_cell(x int, y int, alive bool) *Cell {
  var cell = new(Cell)
  cell.x = x
  cell.y = y
  cell.alive = alive

  return cell
}

func (cell *Cell) to_char() rune {
  if cell.alive {
    return 'o'
  } else {
    return ' '
  }
}
