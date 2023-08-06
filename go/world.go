package main

import (
  "fmt"
  "math/rand"
  "strconv"
  "strings"
)

// GO doesn't have a concept of exception
var LocationOccupied = fmt.Errorf("LocationOccupied")

var cached_directions = [8][2]int{
  {-1, 1},  {0, 1},  {1, 1},  // above
  {-1, 0},           {1, 0},  // sides
  {-1, -1}, {0, -1}, {1, -1}, // below
}

type World struct {
  width int
  height int
  tick int64
	cells map[string]*Cell
}

// Like constructor
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
  // for y := 0; y < world.height; y++ {
  //   for x := 0; x < world.width; x++ {
  //     cell, _ := world.cell_at(x, y)
  //     rendering += string(cell.to_char())
  //   }
  //   rendering += "\n"
  // }
  // return rendering

  // The following works but is slower
  // rendering := []string{}
  // for y := 0; y < world.height; y++ {
  //   for x := 0; x < world.width; x++ {
  //     cell, _ := world.cell_at(x, y)
  //     rendering = append(rendering, string(cell.to_char()))
  //   }
  //   rendering = append(rendering, "\n")
  // }
  // return strings.Join(rendering, "")

  // The following was the fastest method
  rendering := strings.Builder{}
  rendering.Grow(world.width * world.height)
  for y := 0; y < world.height; y++ {
    for x := 0; x < world.width; x++ {
      cell, _ := world.cell_at(x, y)
      rendering.WriteRune(cell.to_char())
    }
    rendering.WriteRune('\n')
  }
  return rendering.String()
}

func (world *World) populate_cells() {
  for y := 0; y < world.height; y++ {
    for x := 0; x < world.width; x++ {
      alive := rand.Intn(100) <= 20
      world.add_cell(x, y, alive)
    }
  }
}

func (world *World) prepopulate_neighbours() {
  for _, cell := range world.cells {
    world.neighbours_around(cell)
  }
}

func (world *World) add_cell(x int, y int, alive bool) *Cell {
  if _, ok := world.cell_at(x, y); ok {
    panic(LocationOccupied)
  }

  cell := new_cell(x, y, alive)

  key := strconv.Itoa(x) + "-" + strconv.Itoa(y)
  world.cells[key] = cell
  return cell
}

func (world *World) cell_at(x int, y int) (*Cell, bool) {
  key := strconv.Itoa(x) + "-" + strconv.Itoa(y)
  cell, ok := world.cells[key]
  return cell, ok
}

func (world *World) neighbours_around(cell *Cell) []*Cell {
  if cell.neighbours == nil {
    for _, set := range cached_directions {
      neighbour, ok := world.cell_at(
        cell.x + set[0],
        cell.y + set[1],
      )

      if ok {
        cell.neighbours = append(cell.neighbours, neighbour)
      }
    }
  }
  return cell.neighbours
}

// Implement first using filter/lambda if available. Then implement
// foreach and for. Use whatever implementation runs the fastest
func (world *World) alive_neighbours_around(cell *Cell) int {
  neighbours := world.neighbours_around(cell)

  // The following was the fastest method
  alive_neighbours := 0
  for _, neighbour := range neighbours {
    if neighbour.alive {
      alive_neighbours++
    }
  }
  return alive_neighbours

  // The following also works but is slower
  // alive_neighbours := 0
  // for i := 0; i < len(neighbours); i++ {
  //   neighbour := neighbours[i]
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
