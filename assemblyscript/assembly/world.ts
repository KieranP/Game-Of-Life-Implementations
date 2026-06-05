import { Cell } from './cell'

class LocationOccupied extends Error {
  constructor(message: string) {
    super(`LocationOccupied(${message})`)
  }
}

const DIRECTIONS: StaticArray<StaticArray<i32>> = [
  [-1, 1],  [0, 1],  [1, 1], // above
  [-1, 0],           [1, 0], // sides
  [-1, -1], [0, -1], [1, -1] // below
]

export class World {
  public tick: u32 = 0

  private readonly width: u32
  private readonly height: u32
  private readonly cells: Map<string, Cell>

  constructor(width: u32, height: u32) {
    this.width = width
    this.height = height
    this.cells = new Map<string, Cell>()

    this.populateCells()
    this.prepopulateNeighbours()
  }

  public doTick(): void {
    const cells = this.cells.values()
    const cellCount = cells.length

    // First determine the action for all cells
    for (let i = 0; i < cellCount; i++) {
      const cell = cells.at(i)
      const aliveNeighbours = cell.aliveNeighbours()
      if (!cell.alive && aliveNeighbours == 3) {
        cell.nextState = true
      } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
        cell.nextState = false
      } else {
        cell.nextState = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (let i = 0; i < cellCount; i++) {
      const cell = cells.at(i)
      cell.alive = cell.nextState
    }

    this.tick += 1
  }

  public render(): string {
    // The following is slower
    // let rendering = ""
    // for (let y: u32 = 0; y < this.height; y++) {
    //   for (let x: u32 = 0; x < this.width; x++) {
    //     const cell = this.cellAt(x, y)
    //     if (cell) {
    //       rendering += cell.toChar()
    //     }
    //   }
    //   rendering += "\n"
    // }
    // return rendering

    // The following is slower
    // const rendering: string[] = []
    // for (let y: u32 = 0; y < this.height; y++) {
    //   for (let x: u32 = 0; x < this.width; x++) {
    //     const cell = this.cellAt(x, y)
    //     if (cell) {
    //       rendering.push(cell.toChar())
    //     }
    //   }
    //   rendering.push("\n")
    // }
    // return rendering.join("")

    // The following is the fastest
    const renderSize = this.width * this.height + this.height
    const rendering = new Array<string>(renderSize)
    let idx = 0
    for (let y: u32 = 0; y < this.height; y++) {
      for (let x: u32 = 0; x < this.width; x++) {
        const cell = this.cellAt(x, y)
        if (cell) {
          rendering[idx++] = cell.toChar()
        }
      }
      rendering[idx++] = "\n"
    }
    return rendering.join("")
  }

  private static makeKey(x: u32, y: u32): string {
    // The following is the fastest
    return `${x}-${y}`

    // The following is slower
    // return x.toString() + "-" + y.toString()

    // The following is slower
    // const parts: string[] = [x.toString(), "-", y.toString()]
    // return parts.join("")
  }

  private cellAt(x: u32, y: u32): Cell | null {
    const key = World.makeKey(x, y)
    if (this.cells.has(key)) {
      return this.cells.get(key)
    } else {
      return null
    }
  }

  private populateCells(): void {
    for (let y: u32 = 0; y < this.height; y++) {
      for (let x: u32 = 0; x < this.width; x++) {
        const alive = Math.random() <= 0.2
        this.addCell(x, y, alive)
      }
    }
  }

  private addCell(x: u32, y: u32, alive: bool = false): bool {
    const key = World.makeKey(x, y)
    const existing = this.cellAt(x, y)
    if (existing) {
      throw new LocationOccupied(key)
    }

    const cell = new Cell(x, y, alive)
    this.cells.set(key, cell)
    return true
  }

  private prepopulateNeighbours(): void {
    const cells = this.cells.values()
    const cellCount = cells.length

    for (let i = 0; i < cellCount; i++) {
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

        const neighbour = this.cellAt(nx, ny)
        if (neighbour) {
          cell.neighbours.push(neighbour)
        }
      }
    }
  }
}
