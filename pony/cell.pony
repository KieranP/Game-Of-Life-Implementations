use "collections"
use "itertools"

class Cell
  let x: U32
  let y: U32
  var alive: Bool
  var next_state: Bool = false
  var neighbours: Array[Cell ref] = []

  new create(x': U32, y': U32, alive': Bool = false) =>
    x = x'
    y = y'
    alive = alive'

  fun to_char(): String val =>
    if alive then
      "o"
    else
      " "
    end

  fun alive_neighbours(): U32 =>
    // The following is slower
    // Iter[Cell](neighbours.values())
    //   .filter({(cell) => cell.alive })
    //   .count()

    // The following is the fastest
    var alive_count: U32 = 0
    for neighbour in neighbours.values() do
      if neighbour.alive then
        alive_count = alive_count + 1
      end
    end
    alive_count

    // The following is slower
    // var alive_count: U32 = 0
    // var count = neighbours.size()
    // for i in Range(0, count) do
    //   try
    //     let neighbour = neighbours(i)?
    //     if neighbour.alive then
    //       alive_count = alive_count + 1
    //     end
    //   end
    // end
    // alive_count
