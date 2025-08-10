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
      const alive_neighbours = this.#alive_neighbours_around(cell)
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

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  render(): string {
    // The following was the fastest method
    let rendering = ''
    for (let y = 0; y < this.#height; y++) {
      for (let x = 0; x < this.#width; x++) {
        const cell = this.#cell_at(x, y)!
        rendering += cell.to_char()
      }
      rendering += "\n"
    }
    return rendering

    // The following works but is slower
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
    return cell
  }

  #prepopulate_neighbours() {
    for (const cell of this.#cells.values()) {
      for (const [x, y] of DIRECTIONS) {
        const neighbour = this.#cell_at(
          (cell.x + x),
          (cell.y + y)
        )

        if (neighbour != null) {
          cell.neighbours.push(neighbour)
        }
      }
    }
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  #alive_neighbours_around(cell: Cell) {
    // The following works but is slower
    // return cell.neighbours.filter(function(neighbour) {
    //   return neighbour.alive
    // }).length

    // The following works but is slower
    // let alive_neighbours = 0
    // for (const neighbour of cell.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    // The following was the fastest method
    let alive_neighbours = 0
    for (let i = 0; i < cell.neighbours.length; i++) {
      const neighbour = cell.neighbours[i]
      if (neighbour?.alive) {
        alive_neighbours += 1
      }
    }
    return alive_neighbours
  }
}

class Cell {
  x: number
  y: number
  alive: boolean
  next_state: boolean | null = null
  neighbours: Cell[] = []

  constructor(x: number, y: number, alive: boolean = false) {
    this.x = x
    this.y = y
    this.alive = alive
  }

  to_char() {
    return (this.alive ? 'o' : ' ')
  }
}
