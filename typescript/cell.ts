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

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  alive_neighbours(): number {
    // The following works but is slower
    // return this.neighbours.filter(function(neighbour) {
    //   return neighbour.alive
    // }).length

    // The following was the fastest method
    let alive_neighbours = 0
    for (const neighbour of this.neighbours) {
      if (neighbour.alive) {
        alive_neighbours += 1
      }
    }
    return alive_neighbours

    // The following works but is slower
    // let alive_neighbours = 0
    // for (let i = 0; i < this.neighbours.length; i++) {
    //   const neighbour = this.neighbours[i]
    //   if (neighbour?.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours
  }
}
