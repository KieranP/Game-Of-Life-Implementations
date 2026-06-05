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
    check self.populateCells();
    self.prepopulateNeighbours();
  }

  public function doTick() {
    // First determine the action for all cells
    foreach Cell cell in self.cells {
      int:Unsigned32 aliveNeighbours = cell.aliveNeighbours();
      if !cell.alive && aliveNeighbours == 3 {
        cell.nextState = true;
      } else if aliveNeighbours < 2 || aliveNeighbours > 3 {
        cell.nextState = false;
      } else {
        cell.nextState = cell.alive;
      }
    }

    // Then execute the determined action for all cells
    foreach Cell cell in self.cells {
      cell.alive = cell.nextState ?: false;
    }

    self.tick = <int:Unsigned32>(self.tick + 1);
  }

  public function render() returns string {
    // The following is slower
    // string rendering = "";
    // foreach int y in 0 ..< self.height {
    //   foreach int x in 0 ..< self.width {
    //     Cell? cell = self.cellAt(<int:Unsigned32>x, <int:Unsigned32>y);
    //     if cell is Cell {
    //       rendering += cell.toChar();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following is slower
    // string[] rendering = [];
    // foreach int y in 0 ..< self.height {
    //   foreach int x in 0 ..< self.width {
    //     Cell? cell = self.cellAt(<int:Unsigned32>x, <int:Unsigned32>y);
    //     if cell is Cell {
    //       rendering.push(cell.toChar());
    //     }
    //   }
    //   rendering.push("\n");
    // }
    // return string:'join("", ...rendering);

    // The following is the fastest
    int renderSize = self.width * self.height + self.height;
    string[] rendering = [];
    rendering.setLength(renderSize);
    int idx = 0;
    foreach int y in 0 ..< self.height {
      foreach int x in 0 ..< self.width {
        Cell? cell = self.cellAt(<int:Unsigned32>x, <int:Unsigned32>y);
        if cell is Cell {
          rendering[idx] = cell.toChar();
          idx += 1;
        }
      }
      rendering[idx] = "\n";
      idx += 1;
    }
    return string:'join("", ...rendering);
  }

  private function makeKey(int:Unsigned32 x, int:Unsigned32 y) returns string {
    // The following is slower
    // return string `${x}-${y}`;

    // The following is the fastest
    return x.toString() + "-" + y.toString();

    // The following is slower
    // string[] parts = [x.toString(), "-", y.toString()];
    // return string:'join("", ...parts);
  }

  private function cellAt(int:Unsigned32 x, int:Unsigned32 y) returns Cell? {
    string key = self.makeKey(x, y);
    return self.cells[key];
  }

  private function populateCells() returns error? {
    foreach int y in 0 ..< self.height {
      foreach int x in 0 ..< self.width {
        float randValue = random:createDecimal();
        boolean alive = randValue <= 0.2;
        _ = check self.addCell(<int:Unsigned32>x, <int:Unsigned32>y, alive);
      }
    }
  }

  private function addCell(int:Unsigned32 x, int:Unsigned32 y, boolean alive = false) returns boolean|error {
    Cell? existing = self.cellAt(x, y);
    if existing is Cell {
      return error LocationOccupied(string `LocationOccupied(${x}-${y})`);
    }

    Cell cell = new(x, y, alive);
    string key = self.makeKey(x, y);
    self.cells[key] = cell;
    return true;
  }

  private function prepopulateNeighbours() {
    foreach Cell cell in self.cells {
      int:Unsigned32 x = cell.x;
      int:Unsigned32 y = cell.y;

      foreach var [relX, relY] in DIRECTIONS {
        int nx = <int>x + relX;
        int ny = <int>y + relY;
        if nx < 0 || ny < 0 {
          continue; // Out of bounds
        }

        int:Unsigned32 ux = <int:Unsigned32>nx;
        int:Unsigned32 uy = <int:Unsigned32>ny;

        if ux >= self.width || uy >= self.height {
          continue; // Out of bounds
        }

        Cell? neighbour = self.cellAt(ux, uy);
        if neighbour is Cell {
          cell.neighbours.push(neighbour);
        }
      }
    }
  }
}
