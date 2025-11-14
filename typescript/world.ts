import { Cell } from './cell.js'

class LocationOccupied extends Error {
  constructor(x: number, y: number) {
    super(`LocationOccupied(${x}-${y})`)
  }
}

const DIRECTIONS = [
  [-1, 1],  [0, 1],  [1, 1], // above
  [-1, 0],           [1, 0], // sides
  [-1, -1], [0, -1], [1, -1] // below
] as const

export class World {
  tick = 0

  #width: number
  #height: number
  #cells = new Map<string, Cell>()

  constructor(width: number, height: number) {
    this.#width = width
    this.#height = height

    this.#populate_cells()
    this.#prepopulate_neighbours()
  }

  _tick(): void {
    // First determine the action for all cells
    for (const cell of this.#cells.values()) {
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
    for (const cell of this.#cells.values()) {
      cell.alive = cell.next_state as boolean
    }

    this.tick += 1
  }

  render(): string {
    // The following is the fastest
    let rendering = ''
    for (let y = 0; y < this.#height; y++) {
      for (let x = 0; x < this.#width; x++) {
        const cell = this.#cell_at(x, y)!
        rendering += cell.to_char()
      }
      rendering += "\n"
    }
    return rendering

    // The following is slower
    // let rendering: Array<string> = []
    // for (let y = 0; y < this.#height; y++) {
    //   for (let x = 0; x < this.#width; x++) {
    //     const cell = this.#cell_at(x, y)!
    //     rendering.push(cell.to_char())
    //   }
    //   rendering.push("\n")
    // }
    // return rendering.join("")
  }

  #cell_at(x: number, y: number) {
    return this.#cells.get(`${x}-${y}`)
  }

  #populate_cells() {
    for (let y = 0; y < this.#height; y++) {
      for (let x = 0; x < this.#width; x++) {
        const alive = (Math.random() <= 0.2)
        this.#add_cell(x, y, alive)
      }
    }
  }

  #add_cell(x: number, y: number, alive: boolean = false) {
    if (this.#cell_at(x, y) != null) {
      throw new LocationOccupied(x, y)
    }

    const cell = new Cell(x, y, alive)
    this.#cells.set(`${x}-${y}`, cell)
    return true
  }

  #prepopulate_neighbours() {
    for (const cell of this.#cells.values()) {
      const x = cell.x
      const y = cell.y

      for (const [rel_x, rel_y] of DIRECTIONS) {
        const nx = x + rel_x
        const ny = y + rel_y
        if (nx < 0 || ny < 0) {
          continue // Out of bounds
        }

        if (nx >= this.#width || ny >= this.#height) {
          continue // Out of bounds
        }

        const neighbour = this.#cell_at(nx, ny)
        if (neighbour != null) {
          cell.neighbours.push(neighbour)
        }
      }
    }
  }
}
