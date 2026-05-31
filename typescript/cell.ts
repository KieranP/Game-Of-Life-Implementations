export class Cell {
  next_state?: boolean
  readonly neighbours: Cell[] = []

  constructor(public readonly x: number, public readonly y: number, public alive: boolean = false) {}

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
