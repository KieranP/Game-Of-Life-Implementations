export class Cell {
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

  to_char(): string {
    return (this.alive ? 'o' : ' ')
  }

  alive_neighbours(): number {
    // The following is slower
    // return this.neighbours.filter(function(neighbour) {
    //   return neighbour.alive
    // }).length

    // The following is the fastest
    let alive_neighbours = 0
    for (const neighbour of this.neighbours) {
      if (neighbour.alive) {
        alive_neighbours += 1
      }
    }
    return alive_neighbours

    // The following is slower
    // let alive_neighbours = 0
    // let count = this.neighbours.length
    // for (let i = 0; i < count; i++) {
    //   const neighbour = this.neighbours[i]
    //   if (neighbour?.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours
  }
}
