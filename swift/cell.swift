final public class Cell {
  public var x: Int
  public var y: Int
  public var alive: Bool
  public var next_state: Bool?
  public var neighbours: Array<Cell>

  public init(x: Int, y: Int, alive: Bool = false) {
    self.x = x
    self.y = y
    self.alive = alive
    self.next_state = nil
    self.neighbours = []
  }

  public func to_char() -> String {
    return alive ? "o" : " "
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  public func alive_neighbours() -> Int {
    // The following works but is slower
    // return neighbours.filter { $0.alive }.count

    // The following works but is slower
    // var alive_neighbours = 0;
    // for neighbour in neighbours {
    //   if neighbour.alive {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    // The following was the fastest method
    var alive_neighbours = 0
    for i in 0 ..< neighbours.count {
      let neighbour = neighbours[i]
      if neighbour.alive {
        alive_neighbours += 1
      }
    }
    return alive_neighbours
  }
}
