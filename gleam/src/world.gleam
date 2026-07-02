import cell.{type Cell, Cell}
import gleam/bool
import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/list
import gleam/string

// import gleam/string_tree // used by the slower render variant

pub type World {
  World(width: Int, height: Int, tick: Int, cells: Dict(String, Cell))
}

pub type LocationOccupied {
  LocationOccupied(x: Int, y: Int)
}

const directions = [
  #(-1, 1),  #(0, 1),  #(1, 1), // above
  #(-1, 0),            #(1, 0), // sides
  #(-1, -1), #(0, -1), #(1, -1), // below
]

pub fn new(width: Int, height: Int) -> World {
  let world = World(width: width, height: height, tick: 0, cells: dict.new())

  world
  |> populate_cells()
  |> prepopulate_neighbours()
}

pub fn dotick(world: World) -> World {
  let cells =
    dict.map_values(world.cells, fn(_key, cell) {
      let alive_neighbours = cell.alive_neighbours(cell, world.cells)

      case cell.alive, alive_neighbours {
        False, 3 -> Cell(..cell, alive: True)
        _, n if n < 2 || n > 3 -> Cell(..cell, alive: False)
        _, _ -> cell
      }
    })

  World(..world, tick: world.tick + 1, cells: cells)
}

pub fn render(world: World) -> String {
  // The following is the fastest
  int.range(0, world.height, "", fn(rendering, y) {
    int.range(0, world.width, rendering, fn(rendering, x) {
      case cell_at(world, x, y) {
        Ok(cell) -> rendering <> cell.to_char(cell)
        Error(_) -> rendering
      }
    })
    <> "\n"
  })

  // The following is slower
  // int.range(0, world.height, string_tree.new(), fn(rendering, y) {
  //   int.range(0, world.width, rendering, fn(rendering, x) {
  //     case cell_at(world, x, y) {
  //       Ok(cell) -> string_tree.append(rendering, cell.to_char(cell))
  //       Error(_) -> rendering
  //     }
  //   })
  //   |> string_tree.append("\n")
  // })
  // |> string_tree.to_string()
}

fn make_key(x: Int, y: Int) -> String {
  // The following is slower
  // int.to_string(x) <> "-" <> int.to_string(y)

  // The following is slower
  // string.join([int.to_string(x), int.to_string(y)], "-")

  // The following is the fastest
  string.concat([int.to_string(x), "-", int.to_string(y)])
}

fn cell_at(world: World, x: Int, y: Int) -> Result(Cell, Nil) {
  let key = make_key(x, y)
  dict.get(world.cells, key)
}

fn populate_cells(world: World) -> World {
  int.range(0, world.height, world, fn(world, y) {
    int.range(0, world.width, world, fn(world, x) {
      let alive = float.random() <=. 0.2
      let assert Ok(world) = add_cell(world, x, y, alive)
      world
    })
  })
}

fn add_cell(
  world: World,
  x: Int,
  y: Int,
  alive: Bool,
) -> Result(World, LocationOccupied) {
  let existing = cell_at(world, x, y)
  case existing {
    Ok(_) -> Error(LocationOccupied(x: x, y: y))
    Error(_) -> {
      let key = make_key(x, y)
      let new_cell = cell.new(x, y, alive)
      let new_cells = dict.insert(world.cells, key, new_cell)
      Ok(World(..world, cells: new_cells))
    }
  }
}

fn prepopulate_neighbours(world: World) -> World {
  let cells =
    dict.map_values(world.cells, fn(_key, cell) {
      let neighbours =
        list.filter_map(directions, fn(set) {
          let #(rel_x, rel_y) = set
          let nx = cell.x + rel_x
          let ny = cell.y + rel_y
          use <- bool.guard(nx < 0 || ny < 0, Error(Nil))
          use <- bool.guard(nx >= world.width || ny >= world.height, Error(Nil))
          let key = make_key(nx, ny)
          use <- bool.guard(!dict.has_key(world.cells, key), Error(Nil))
          Ok(key)
        })

      Cell(..cell, neighbours: neighbours)
    })

  World(..world, cells: cells)
}
