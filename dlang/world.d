import std.conv : to;
import std.random : uniform01;
import std.array : array, join;
import std.algorithm : filter;

class World {
  public:
    uint tick;

    this(uint width, uint height) {
      this.width = width;
      this.height = height;

      populate_cells();
      prepopulate_neighbours();
    }

    void _tick() {
      // First determine the action for all cells
      foreach (cell; cells) {
        auto alive_neighbours = alive_neighbours_around(cell);
        if (!cell.alive && alive_neighbours == 3) {
          cell.next_state = true;
        } else if (alive_neighbours < 2 || alive_neighbours > 3) {
          cell.next_state = false;
        } else {
          cell.next_state = cell.alive;
        }
      }

      // Then execute the determined action for all cells
      foreach (cell; cells) {
        cell.alive = cell.next_state;
      }

      tick += 1;
    }

    // Implement first using string concatenation. Then implement any
    // special string builders, and use whatever runs the fastest
    string render() {
      // The following was the fastest method
      string rendering = "";
      for (auto y = 0; y < height; y++) {
        for (auto x = 0; x < width; x++) {
          auto cell = cell_at(x, y);
          rendering ~= cell.to_char();
        }
        rendering ~= "\n";
      }
      return rendering;

      // The following works but it slower
      // string[] rendering = [];
      // for (auto y = 0; y < height; y++) {
      //   for (auto x = 0; x < width; x++) {
      //     auto cell = cell_at(x, y);
      //     rendering ~= to!string(cell.to_char());
      //   }
      //   rendering ~= "\n";
      // }
      // return rendering.join("");
    }

  private:
    uint width, height;
    Cell[string] cells;
    auto cached_directions = [
      [-1, 1],  [0, 1],  [1, 1],  // above
      [-1, 0],           [1, 0],  // sides
      [-1, -1], [0, -1], [1, -1], // below
    ];

    class LocationOccupied: Exception {
      public:
        this(uint x, uint y) {
          this.x = x;
          this.x = y;

          auto key = to!string(x)~"-"~to!string(y);
          super("LocationOccupied("~key~")");
        }

      private:
        uint x, y;
    }

    void populate_cells() {
      for (auto y = 0; y < height; y++) {
        for (auto x = 0; x < width; x++) {
          auto random = uniform01;
          auto alive = (random <= 0.2);
          add_cell(x, y, alive);
        }
      }
    }

    void prepopulate_neighbours() {
      foreach (cell; cells) {
        neighbours_around(cell);
      }
    }

    Cell add_cell(int x, int y, bool alive = false) {
      if (cell_at(x, y)) {
        throw new LocationOccupied(x, y);
      }

      auto key = to!string(x)~"-"~to!string(y);
      auto cell = new Cell(x, y, alive);
      cells[key] = cell;
      return cell;
    }

    Cell cell_at(int x, int y) {
      auto key = to!string(x)~"-"~to!string(y);
      return cells.get(key, null);
    }

    Cell[] neighbours_around(Cell cell) {
      if (cell.neighbours.length == 0) {
        foreach (set; cached_directions) {
          auto neighbour = cell_at(
            (cell.x + set[0]),
            (cell.y + set[1])
          );

          if (neighbour) {
            cell.neighbours ~= neighbour;
          }
        }
      }

      return cell.neighbours;
    }

    // Implement first using filter/lambda if available. Then implement
    // foreach and for. Use whatever implementation runs the fastest
    uint alive_neighbours_around(Cell cell) {
      auto neighbours = neighbours_around(cell);

      // The following works but it slower
      // return neighbours.filter!(
      //   neighbour => neighbour.alive
      // ).array.length;

      // The following was the fastest method
      auto alive_neighbours = 0;
      foreach (neighbour; neighbours) {
        if (neighbour.alive) {
          alive_neighbours++;
        }
      }
      return alive_neighbours;

      // The following works but it slower
      // auto alive_neighbours = 0;
      // for (auto i = 0; i < neighbours.length; i++) {
      //   auto neighbour = neighbours[i];
      //   if (neighbour.alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;
    }
}

class Cell {
  public:
    uint x, y;
    bool alive;
    bool next_state;
    Cell[] neighbours;

    this(uint x, uint y, bool alive = false) {
      this.x = x;
      this.y = y;
      this.alive = alive;
    }

    char to_char() {
      return alive ? 'o' : ' ';
    }
}
