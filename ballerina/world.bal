import ballerina/random;

public type LocationOccupied distinct error;

final int[][] DIRECTIONS = [
  [-1, 1],  [0, 1],  [1, 1],  // above
  [-1, 0],           [1, 0],  // sides
  [-1, -1], [0, -1], [1, -1]  // below
];

public class World {
  public int:Unsigned32 tick = 0;
  private int:Unsigned32 width;
  private int:Unsigned32 height;
  private map<Cell> cells = {};

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
      cell.alive = cell.next_state;
    }

    self.tick = <int:Unsigned32>(self.tick + 1);
  }

  public function render() returns string {
    // The following is slower
    // string rendering = "";
    // int:Unsigned32 y = 0;
    // while y < self.height {
    //   int:Unsigned32 x = 0;
    //   while x < self.width {
    //     Cell? cell = self.cell_at(x, y);
    //     if cell is Cell {
    //       rendering += cell.to_char();
    //     }
    //     x = <int:Unsigned32>(x + 1);
    //   }
    //   rendering += "\n";
    //   y = <int:Unsigned32>(y + 1);
    // }
    // return rendering;

    // The following is slower
    // string[] rendering = [];
    // int:Unsigned32 y = 0;
    // while y < self.height {
    //   int:Unsigned32 x = 0;
    //   while x < self.width {
    //     Cell? cell = self.cell_at(x, y);
    //     if cell is Cell {
    //       rendering.push(cell.to_char());
    //     }
    //     x = <int:Unsigned32>(x + 1);
    //   }
    //   rendering.push("\n");
    //   y = <int:Unsigned32>(y + 1);
    // }
    // return string:'join("", ...rendering);

    // The following is the fastest
    int render_size = self.width * self.height + self.height;
    string[] rendering = [];
    rendering.setLength(render_size);
    int idx = 0;
    int:Unsigned32 y = 0;
    while y < self.height {
      int:Unsigned32 x = 0;
      while x < self.width {
        Cell? cell = self.cell_at(x, y);
        if cell is Cell {
          rendering[idx] = cell.to_char();
          idx += 1;
        }
        x = <int:Unsigned32>(x + 1);
      }
      rendering[idx] = "\n";
      idx += 1;
      y = <int:Unsigned32>(y + 1);
    }
    return string:'join("", ...rendering);
  }

  private function cell_at(int:Unsigned32 x, int:Unsigned32 y) returns Cell? {
    string key = x.toString() + "-" + y.toString();
    return self.cells[key];
  }

  private function populate_cells() returns error? {
    int:Unsigned32 y = 0;
    while y < self.height {
      int:Unsigned32 x = 0;
      while x < self.width {
        int randValue = check random:createIntInRange(0, 100);
        boolean alive = randValue <= 20;
        _ = check self.add_cell(x, y, alive);
        x = <int:Unsigned32>(x + 1);
      }
      y = <int:Unsigned32>(y + 1);
    }
  }

  private function add_cell(int:Unsigned32 x, int:Unsigned32 y, boolean alive = false) returns boolean|error {
    Cell? existing = self.cell_at(x, y);
    if existing is Cell {
      return error LocationOccupied(string `LocationOccupied(${x}-${y})`);
    }

    Cell cell = new(x, y, alive);
    string key = x.toString() + "-" + y.toString();
    self.cells[key] = cell;
    return true;
  }

  private function prepopulate_neighbours() {
    foreach Cell cell in self.cells {
      int:Unsigned32 x = cell.x;
      int:Unsigned32 y = cell.y;

      foreach int[] set in DIRECTIONS {
        int nx = <int>x + set[0];
        int ny = <int>y + set[1];
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
