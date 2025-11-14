import { Cell } from './cell'

class LocationOccupied extends Error {
  constructor(message: string) {
    super(`LocationOccupied(${message})`)
  }
}

const DIRECTIONS = [
  [-1, 1],  [0, 1],  [1, 1], // above
  [-1, 0],           [1, 0], // sides
  [-1, -1], [0, -1], [1, -1] // below
]

export class World {
  public tick: u32 = 0

  private width: u32
  private height: u32
  private cells: Map<string, Cell>

  constructor(width: u32, height: u32) {
    this.width = width
    this.height = height
    this.cells = new Map<string, Cell>()

    this.populate_cells()
    this.prepopulate_neighbours()
  }

  public _tick(): void {
    const cells = this.cells.values()
    const cell_count = cells.length

    // First determine the action for all cells
    for (let i = 0; i < cell_count; i++) {
      const cell = cells.at(i)
      const alive_neighbours = cell.alive_neighbours()
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false
      } else {
        cell.next_state = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (let i = 0; i < cell_count; i++) {
      const cell = cells.at(i)
      cell.alive = cell.next_state
    }

    this.tick += 1
  }

  public render(): string {
    // The following is slower
    // let rendering = ""
    // for (let y: u32 = 0; y < this.height; y++) {
    //   for (let x: u32 = 0; x < this.width; x++) {
    //     const cell = this.cell_at(x, y)
    //     if (cell) {
    //       rendering += cell.to_char()
    //     }
    //   }
    //   rendering += "\n"
    // }
    // return rendering

    // The following is the fastest
    let rendering: string[] = []
    for (let y: u32 = 0; y < this.height; y++) {
      for (let x: u32 = 0; x < this.width; x++) {
        const cell = this.cell_at(x, y)
        if (cell) {
          rendering.push(cell.to_char())
        }
      }
      rendering.push("\n")
    }
    return rendering.join("")
  }

  private cell_at(x: u32, y: u32): Cell | null {
    const key = `${x}-${y}`
    if (this.cells.has(key)) {
      return this.cells.get(key)
    } else {
      return null
    }
  }

  private populate_cells(): void {
    for (let y: u32 = 0; y < this.height; y++) {
      for (let x: u32 = 0; x < this.width; x++) {
        const alive = (Math.random() <= 0.2)
        this.add_cell(x, y, alive)
      }
    }
  }

  private add_cell(x: u32, y: u32, alive: bool = false): bool {
    const key = `${x}-${y}`
    if (this.cell_at(x, y) != null) {
      throw new LocationOccupied(key)
    }

    const cell = new Cell(x, y, alive)
    this.cells.set(key, cell)
    return true
  }

  private prepopulate_neighbours(): void {
    const cells = this.cells.values()
    const cell_count = cells.length

    for (let i = 0; i < cell_count; i++) {
      const cell = cells.at(i)
      const x = cell.x
      const y = cell.y

      for (let j = 0; j < DIRECTIONS.length; j++) {
        const dir = DIRECTIONS[j]
        const nx = (x + dir[0])
        const ny = (y + dir[1])
        if (nx < 0 || ny < 0) {
          continue // Out of bounds
        }

        if (nx >= this.width || ny >= this.height) {
          continue // Out of bounds
        }

        const neighbour = this.cell_at(nx, ny)
        if (neighbour) {
          cell.neighbours.push(neighbour)
        }
      }
    }
  }
}
