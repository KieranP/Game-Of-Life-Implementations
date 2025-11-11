export class Cell {
  public x: u32
  public y: u32
  public alive: bool
  public next_state: bool
  public neighbours: Cell[]

  constructor(x: u32, y: u32, alive: bool = false) {
    this.x = x
    this.y = y
    this.alive = alive
    this.next_state = alive
    this.neighbours = []
  }

  public to_char(): string {
    return this.alive ? 'o' : ' '
  }

  public alive_neighbours(): u32 {
    // The following is slower
    // return this.neighbours.filter(function(neighbour) {
    //   return neighbour.alive
    // }).length

    // The following is the fastest
    let alive_neighbours: u32 = 0
    let count = this.neighbours.length
    for (let i = 0; i < count; i++) {
      const neighbour = this.neighbours[i]
      if (neighbour.alive) {
        alive_neighbours += 1
      }
    }
    return alive_neighbours
  }
}
