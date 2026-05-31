import ballerina/random;

public type LocationOccupied distinct error;

final [int, int][] DIRECTIONS = [
  [-1, 1],  [0, 1],  [1, 1],  // above
  [-1, 0],           [1, 0],  // sides
  [-1, -1], [0, -1], [1, -1]  // below
];

public class World {
  public int:Unsigned32 tick = 0;
  private final int:Unsigned32 width;
  private final int:Unsigned32 height;
  private final map<Cell> cells = {};

  public function init(int:Unsigned32 width, int:Unsigned32 height) returns error? {
    self.width = width;
    self.height = height;
    check self.populate_cells();
    self.prepopulate_neighbours();
  }

  public function dotick() {
    // First determine the action for all cells
    foreach Cell cell in self.cells {
      int:Unsigned32 alive_neighbours = cell.alive_neighbours();
      if !cell.alive && alive_neighbours == 3 {
        cell.next_state = true;
      } else if alive_neighbours < 2 || alive_neighbours > 3 {
        cell.next_state = false;
      } else {
        cell.next_state = cell.alive;
      }
    }

    // Then execute the determined action for all cells
    foreach Cell cell in self.cells {
      cell.alive = cell.next_state ?: false;
    }

    self.tick = <int:Unsigned32>(self.tick + 1);
  }

  public function render() returns string {
    // The following is slower
    // string rendering = "";
    // foreach int y in 0 ..< self.height {
    //   foreach int x in 0 ..< self.width {
    //     Cell? cell = self.cell_at(<int:Unsigned32>x, <int:Unsigned32>y);
    //     if cell is Cell {
    //       rendering += cell.to_char();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following is slower
    // string[] rendering = [];
    // foreach int y in 0 ..< self.height {
    //   foreach int x in 0 ..< self.width {
    //     Cell? cell = self.cell_at(<int:Unsigned32>x, <int:Unsigned32>y);
    //     if cell is Cell {
    //       rendering.push(cell.to_char());
    //     }
    //   }
    //   rendering.push("\n");
    // }
    // return string:'join("", ...rendering);

    // The following is the fastest
    int render_size = self.width * self.height + self.height;
    string[] rendering = [];
    rendering.setLength(render_size);
    int idx = 0;
    foreach int y in 0 ..< self.height {
      foreach int x in 0 ..< self.width {
        Cell? cell = self.cell_at(<int:Unsigned32>x, <int:Unsigned32>y);
        if cell is Cell {
          rendering[idx] = cell.to_char();
          idx += 1;
        }
      }
      rendering[idx] = "\n";
      idx += 1;
    }
    return string:'join("", ...rendering);
  }

  private function make_key(int:Unsigned32 x, int:Unsigned32 y) returns string {
    // The following is slower
    // return string `${x}-${y}`;

    // The following is the fastest
    return x.toString() + "-" + y.toString();

    // The following is slower
    // string[] parts = [x.toString(), "-", y.toString()];
    // return string:'join("", ...parts);
  }

  private function cell_at(int:Unsigned32 x, int:Unsigned32 y) returns Cell? {
    string key = self.make_key(x, y);
    return self.cells[key];
  }

  private function populate_cells() returns error? {
    foreach int y in 0 ..< self.height {
      foreach int x in 0 ..< self.width {
        int randValue = check random:createIntInRange(0, 100);
        boolean alive = randValue <= 20;
        _ = check self.add_cell(<int:Unsigned32>x, <int:Unsigned32>y, alive);
      }
    }
  }

  private function add_cell(int:Unsigned32 x, int:Unsigned32 y, boolean alive = false) returns boolean|error {
    Cell? existing = self.cell_at(x, y);
    if existing is Cell {
      return error LocationOccupied(string `LocationOccupied(${x}-${y})`);
    }

    Cell cell = new(x, y, alive);
    string key = self.make_key(x, y);
    self.cells[key] = cell;
    return true;
  }

  private function prepopulate_neighbours() {
    foreach Cell cell in self.cells {
      int:Unsigned32 x = cell.x;
      int:Unsigned32 y = cell.y;

      foreach var [rel_x, rel_y] in DIRECTIONS {
        int nx = <int>x + rel_x;
        int ny = <int>y + rel_y;
        if nx < 0 || ny < 0 {
          continue; // Out of bounds
        }

        int:Unsigned32 ux = <int:Unsigned32>nx;
        int:Unsigned32 uy = <int:Unsigned32>ny;

        if ux >= self.width || uy >= self.height {
          continue; // Out of bounds
        }

        Cell? neighbour = self.cell_at(ux, uy);
        if neighbour is Cell {
          cell.neighbours.push(neighbour);
        }
      }
    }
  }
}
