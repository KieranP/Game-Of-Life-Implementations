class LocationOccupied extends Error {}

export class World {

  public tick: number
  private width: number
  private height: number
  private cells: {[key: string]: Cell}
  private cached_directions: number[][]

  public constructor(width: number, height: number) {
    this.width = width
    this.height = height
    this.tick = 0
    this.cells = {}
    this.cached_directions = [
      [-1, 1],  [0, 1],  [1, 1], // above
      [-1, 0],           [1, 0], // sides
      [-1, -1], [0, -1], [1, -1] // below
    ]

    this.populate_cells()
    this.prepopulate_neighbours()
  }

  public _tick(): void {
    const cells = Object.values(this.cells)

    // First determine the action for all cells
    for (const cell of cells) {
      const alive_neighbours = this.alive_neighbours_around(cell)
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = 1
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = 0
      }
    }

    // Then execute the determined action for all cells
    for (const cell of cells) {
      if (cell.next_state == 1) {
        cell.alive = true
      } else if (cell.next_state == 0) {
        cell.alive = false
      }
    }

    this.tick += 1
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public render(): string {
    let rendering = ''
    for (let y = 0; y <= this.height; y++) {
      for (let x = 0; x <= this.width; x++) {
        const cell = this.cell_at(x, y)
        rendering += cell.to_char()
      }
      rendering += "\n"
    }
    return rendering

    // The following works but is slower
    // let rendering = []
    // for (let y = 0; y <= this.height; y++) {
    //   for (let x = 0; x <= this.width; x++) {
    //     const cell = this.cell_at(x, y)
    //     rendering.push(cell.to_char())
    //   }
    //   rendering.push("\n")
    // }
    // return rendering.join("")
  }

  private populate_cells(): void {
    for (let y = 0; y <= this.height; y++) {
      for (let x = 0; x <= this.width; x++) {
        const alive = (Math.random() <= 0.2)
        this.add_cell(x, y, alive)
      }
    }
  }

  private prepopulate_neighbours(): void {
    for (const cell of Object.values(this.cells)) {
      this.neighbours_around(cell)
    }
  }

  private add_cell(x: number, y: number, alive: boolean = false): Cell {
    if (this.cell_at(x, y) != null) {
      throw new LocationOccupied
    }

    const cell = new Cell(x, y, alive)
    this.cells[`${x}-${y}`] = cell
    return this.cell_at(x, y)
  }

  private cell_at(x: number, y: number): Cell {
    return this.cells[`${x}-${y}`]
  }

  private neighbours_around(cell: Cell): Cell[] {
    if (cell.neighbours == null) {
      cell.neighbours = new Array
      for (const set of this.cached_directions) {
        const neighbour = this.cell_at(
          (cell.x + set[0]),
          (cell.y + set[1])
        )
        if (neighbour != null) {
          cell.neighbours.push(neighbour)
        }
      }
    }

    return cell.neighbours
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Retain whatever implementation runs the fastest
  private alive_neighbours_around(cell: Cell): number {
    // The following works but is slower
    // const neighbours = this.neighbours_around(cell)
    // return neighbours.filter(function(neighbour) {
    //   return neighbour.alive
    // }).length

    // The following also works but is slower
    // let alive_neighbours = 0
    // for (const neighbour of this.neighbours_around(cell)) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    let alive_neighbours = 0
    const neighbours = this.neighbours_around(cell)
    for (let i = 0; i < neighbours.length; i++) {
      const neighbour = neighbours[i]
      if (neighbour.alive) {
        alive_neighbours += 1
      }
    }
    return alive_neighbours
  }

}

class Cell {

  public x: number
  public y: number
  public alive: boolean
  public next_state: number | null
  public neighbours: Cell[] | null

  public constructor(x: number, y: number, alive: boolean = false) {
    this.x = x
    this.y = y
    this.alive = alive
    this.next_state = null
    this.neighbours = null
  }

  public to_char(): string {
    return (this.alive ? 'o' : ' ')
  }

}
