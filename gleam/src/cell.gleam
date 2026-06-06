import gleam/dict.{type Dict}
import gleam/list

pub type Cell {
  Cell(x: Int, y: Int, alive: Bool, neighbours: List(String))
}

pub fn new(x: Int, y: Int, alive: Bool) -> Cell {
  Cell(x: x, y: y, alive: alive, neighbours: [])
}

pub fn to_char(cell: Cell) -> String {
  case cell.alive {
    True -> "o"
    False -> " "
  }
}

pub fn alive_neighbours(cell: Cell, cells: Dict(String, Cell)) -> Int {
  // The following is slower
  // dict.take(cells, cell.neighbours)
  // |> dict.values()
  // |> list.count(fn(neighbour) { neighbour.alive })

  // The following is slower
  // dict.fold(dict.take(cells, cell.neighbours), 0, fn(count, _key, neighbour) {
  //   case neighbour.alive {
  //     True -> count + 1
  //     False -> count
  //   }
  // })

  // The following is the fastest
  list.fold(cell.neighbours, 0, fn(count, key) {
    case dict.get(cells, key) {
      Ok(neighbour) if neighbour.alive -> count + 1
      _ -> count
    }
  })
}
