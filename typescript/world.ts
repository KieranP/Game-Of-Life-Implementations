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

  readonly #width: number
  readonly #height: number
  readonly #cells = new Map<string, Cell>()

  constructor(width: number, height: number) {
    this.#width = width
    this.#height = height

    this.#populateCells()
    this.#prepopulateNeighbours()
  }

  doTick(): void {
    // First determine the action for all cells
    for (const cell of this.#cells.values()) {
      const aliveNeighbours = cell.aliveNeighbours()
      if (!cell.alive && aliveNeighbours === 3) {
        cell.nextState = true
      } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
        cell.nextState = false
      } else {
        cell.nextState = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (const cell of this.#cells.values()) {
      cell.alive = cell.nextState ?? cell.alive
    }

    this.tick += 1
  }

  render(): string {
    // The following is the fastest
    let rendering = ''
    for (let y = 0; y < this.#height; y++) {
      for (let x = 0; x < this.#width; x++) {
        const cell = this.#cellAt(x, y)
        if (cell) {
          rendering += cell.toChar()
        }
      }
      rendering += "\n"
    }
    return rendering

    // The following is slower
    // let rendering: Array<string> = []
    // for (let y = 0; y < this.#height; y++) {
    //   for (let x = 0; x < this.#width; x++) {
    //     const cell = this.#cellAt(x, y)
    //     if (cell) {
    //       rendering.push(cell.toChar())
    //     }
    //   }
    //   rendering.push("\n")
    // }
    // return rendering.join("")
  }

  #makeKey(x: number, y: number): string {
    // The following is the fastest
    return `${x}-${y}`

    // The following is slower
    // return x + "-" + y

    // The following is slower
    // return [x, y].join("-")
  }

  #cellAt(x: number, y: number) {
    const key = this.#makeKey(x, y)
    return this.#cells.get(key)
  }

  #populateCells() {
    for (let y = 0; y < this.#height; y++) {
      for (let x = 0; x < this.#width; x++) {
        const alive = Math.random() <= 0.2
        this.#addCell(x, y, alive)
      }
    }
  }

  #addCell(x: number, y: number, alive: boolean = false) {
    const existing = this.#cellAt(x, y)
    if (existing) {
      throw new LocationOccupied(x, y)
    }

    const key = this.#makeKey(x, y)
    const cell = new Cell(x, y, alive)
    this.#cells.set(key, cell)
    return true
  }

  #prepopulateNeighbours() {
    for (const cell of this.#cells.values()) {
      const x = cell.x
      const y = cell.y

      for (const [relX, relY] of DIRECTIONS) {
        const nx = x + relX
        const ny = y + relY
        if (nx < 0 || ny < 0) {
          continue // Out of bounds
        }

        if (nx >= this.#width || ny >= this.#height) {
          continue // Out of bounds
        }

        const neighbour = this.#cellAt(nx, ny)
        if (neighbour) {
          cell.neighbours.push(neighbour)
        }
      }
    }
  }
}
