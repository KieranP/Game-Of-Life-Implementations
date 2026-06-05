export class Cell {
  public readonly x: u32
  public readonly y: u32
  public alive: bool
  public nextState: bool
  public readonly neighbours: Cell[]

  constructor(x: u32, y: u32, alive: bool = false) {
    this.x = x
    this.y = y
    this.alive = alive
    this.nextState = alive
    this.neighbours = []
  }

  public toChar(): string {
    return this.alive ? 'o' : ' '
  }

  public aliveNeighbours(): u32 {
    // The following is slower
    // return this.neighbours.filter(function(neighbour) {
    //   return neighbour.alive
    // }).length

    // The following is the fastest
    let aliveNeighbours: u32 = 0
    const count = this.neighbours.length
    for (let i = 0; i < count; i++) {
      const neighbour = this.neighbours[i]
      if (neighbour.alive) {
        aliveNeighbours += 1
      }
    }
    return aliveNeighbours
  }
}
