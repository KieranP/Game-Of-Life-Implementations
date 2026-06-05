export class Cell {
  nextState?: boolean
  readonly neighbours: Cell[] = []

  constructor(public readonly x: number, public readonly y: number, public alive: boolean = false) {}

  toChar(): string {
    return (this.alive ? 'o' : ' ')
  }

  aliveNeighbours(): number {
    // The following is slower
    // return this.neighbours.filter(function(neighbour) {
    //   return neighbour.alive
    // }).length

    // The following is the fastest
    let aliveNeighbours = 0
    for (const neighbour of this.neighbours) {
      if (neighbour.alive) {
        aliveNeighbours += 1
      }
    }
    return aliveNeighbours

    // The following is slower
    // let aliveNeighbours = 0
    // let count = this.neighbours.length
    // for (let i = 0; i < count; i++) {
    //   const neighbour = this.neighbours[i]
    //   if (neighbour?.alive) {
    //     aliveNeighbours += 1
    //   }
    // }
    // return aliveNeighbours
  }
}
