class World {

  #width
  #height
  #cells
  #cached_directions

  constructor(width, height) {
    this.tick = 0
    this.#width = width
    this.#height = height
    this.#cells = new Map()
    this.#cached_directions = [
      [-1, 1],  [0, 1],  [1, 1], // above
      [-1, 0],           [1, 0], // sides
      [-1, -1], [0, -1], [1, -1] // below
    ]

    this.#populate_cells()
    this.#prepopulate_neighbours()
  }

  _tick() {
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
      cell.alive = cell.next_state
    }

    this.tick += 1
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  render() {
    // The following was the fastest method
    let rendering = ''
    for (let y = 0; y <= this.#height; y++) {
      for (let x = 0; x <= this.#width; x++) {
        const cell = this.#cell_at(x, y)
        rendering += cell.to_char().replace(' ', '&nbsp;')
      }
      rendering += "<br />"
    }
    return rendering

    // The following works but is slower
    // let rendering = []
    // for (let y = 0; y <= this.#height; y++) {
    //   for (let x = 0; x <= this.#width; x++) {
    //     const cell = this.#cell_at(x, y)
    //     rendering.push(cell.to_char().replace(' ', '&nbsp;'))
    //   }
    //   rendering.push("<br />")
    // }
    // return rendering.join("")
  }

  #populate_cells() {
    for (let y = 0; y <= this.#height; y++) {
      for (let x = 0; x <= this.#width; x++) {
        const alive = (Math.random() <= 0.2)
        this.#add_cell(x, y, alive)
      }
    }
  }

  #prepopulate_neighbours() {
    for (const cell of this.#cells.values()) {
      this.#neighbours_around(cell)
    }
  }

  #add_cell(x, y, alive = false) {
    if (this.#cell_at(x, y) != null) {
      throw new World.LocationOccupied
    }

    const cell = new Cell(x, y, alive)
    this.#cells.set(`${x}-${y}`, cell)
    return this.#cell_at(x, y)
  }

  #cell_at(x, y) {
    return this.#cells.get(`${x}-${y}`)
  }

  #neighbours_around(cell) {
    if (cell.neighbours == null) {
      cell.neighbours = new Array
      for (const set of this.#cached_directions) {
        const neighbour = this.#cell_at(
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
  // foreach and for. Use whatever implementation runs the fastest
  #alive_neighbours_around(cell) {
    // The following works but is slower
    // const neighbours = this.#neighbours_around(cell)
    // return neighbours.filter(function(neighbour) {
    //   return neighbour.alive
    // }).length

    // The following also works but is slower
    // let alive_neighbours = 0
    // for (const neighbour of this.#neighbours_around(cell)) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    // The following was the fastest method
    let alive_neighbours = 0
    const neighbours = this.#neighbours_around(cell)
    for (let i = 0; i < neighbours.length; i++) {
      const neighbour = neighbours[i]
      if (neighbour.alive) {
        alive_neighbours += 1
      }
    }
    return alive_neighbours
  }

}

World.LocationOccupied = function() {}

class Cell {

  constructor(x, y, alive = false) {
    this.x = x
    this.y = y
    this.alive = alive
    this.next_state = null
    this.neighbours = null
  }

  to_char() {
    return (this.alive ? 'o' : ' ')
  }

}
