package main

import (
  "fmt"
  "math/rand/v2"
  "strconv"
  "strings"
)

type LocationOccupied struct {
  x uint32
  y uint32
}

func (e LocationOccupied) Error() string {
  return fmt.Sprintf("LocationOccupied(%d-%d)", e.x, e.y)
}

var directions = [...][2]int{
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

func newWorld(width uint32, height uint32) *World {
  world := &World{width: width, height: height, cells: make(map[string]*Cell, width*height)}

  world.populateCells()
  world.prepopulateNeighbours()

  return world
}

func (world *World) doTick() {
  // First determine the action for all cells
  for _, cell := range world.cells {
    aliveNeighbours := cell.aliveNeighbours()
    if !cell.alive && aliveNeighbours == 3 {
      cell.nextState = true
    } else if aliveNeighbours < 2 || aliveNeighbours > 3 {
      cell.nextState = false
    } else {
      cell.nextState = cell.alive
    }
  }

  // Then execute the determined action for all cells
  for _, cell := range world.cells {
    cell.alive = cell.nextState
  }

  world.tick++
}

func (world *World) render() string {
  // The following is slower
  // rendering := ""
  // for y := range world.height {
  //   for x := range world.width {
  //     cell, ok := world.cellAt(x, y)
  //     if ok {
  //       rendering += string(cell.toChar())
  //     }
  //   }
  //   rendering += "\n"
  // }
  // return rendering

  // The following is slower
  // rendering := []string{}
  // for y := range world.height {
  //   for x := range world.width {
  //     cell, ok := world.cellAt(x, y)
  //     if ok {
  //       rendering = append(rendering, string(cell.toChar()))
  //     }
  //   }
  //   rendering = append(rendering, "\n")
  // }
  // return strings.Join(rendering, "")

  // The following is the fastest
  renderSize := int(world.width * world.height + world.height)
  rendering := strings.Builder{}
  rendering.Grow(renderSize)
  for y := range world.height {
    for x := range world.width {
      cell, ok := world.cellAt(x, y)
      if ok {
        rendering.WriteRune(cell.toChar())
      }
    }
    rendering.WriteRune('\n')
  }
  return rendering.String()
}

func (world *World) makeKey(buf []byte, x uint32, y uint32) int {
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

func (world *World) cellAt(x uint32, y uint32) (*Cell, bool) {
  var buf [24]byte
  n := world.makeKey(buf[:], x, y)
  key := string(buf[:n])

  cell, ok := world.cells[key]
  return cell, ok
}

func (world *World) populateCells() {
  for y := range world.height {
    for x := range world.width {
      alive := rand.Float64() <= 0.2
      world.addCell(x, y, alive)
    }
  }
}

func (world *World) addCell(x uint32, y uint32, alive bool) bool {
  _, ok := world.cellAt(x, y)
  if ok {
    panic(LocationOccupied{ x: x, y: y })
  }

  var buf [24]byte
  n := world.makeKey(buf[:], x, y)
  key := string(buf[:n])

  cell := newCell(x, y, alive)
  world.cells[key] = cell
  return true
}

func (world *World) prepopulateNeighbours() {
  for _, cell := range world.cells {
    x := int(cell.x)
    y := int(cell.y)

    for _, set := range directions {
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

      neighbour, ok := world.cellAt(ux, uy)
      if ok {
        cell.neighbours = append(cell.neighbours, neighbour)
      }
    }
  }
}
