use "itertools"

class Cell
  let x: USize
  let y: USize
  var alive: Bool
  var next_state: Bool = false
  var neighbours: Array[Cell ref] = []

  new create(x': USize, y': USize, alive': Bool = false) =>
    x = x'
    y = y'
    alive = alive'

  fun to_char(): String val =>
    if alive then
      "o"
    else
      " "
    end

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  fun alive_neighbours(): USize =>
    // The following works but it slower
    // Iter[Cell](neighbours.values())
    //   .filter({(cell) => cell.alive })
    //   .count()

    // The following was the fastest method
    var count: USize = 0
    for neighbour in neighbours.values() do
      if neighbour.alive then
        count = count + 1
      end
    end
    count

    // The following works but it slower
    // var count: USize = 0
    // for i in Range(0, neighbours.size()) do
    //   try
    //     let neighbour = neighbours(i)?
    //     if neighbour.alive then
    //       count = count + 1
    //     end
    //   end
    // end
    // count
