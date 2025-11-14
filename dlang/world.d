import cell;
import std.conv : to;
import std.random : uniform01;
import std.array : array, join;

class World {
  public:
    uint tick;

    this(uint width, uint height) {
      this.width = width;
      this.height = height;

      populate_cells();
      prepopulate_neighbours();
    }

    auto _tick() {
      // First determine the action for all cells
      foreach (ref cell; cells) {
        auto alive_neighbours = cell.alive_neighbours();
        if (!cell.alive && alive_neighbours == 3) {
          cell.next_state = true;
        } else if (alive_neighbours < 2 || alive_neighbours > 3) {
          cell.next_state = false;
        } else {
          cell.next_state = cell.alive;
        }
      }

      // Then execute the determined action for all cells
      foreach (ref cell; cells) {
        cell.alive = cell.next_state;
      }

      tick += 1;
    }

    auto render() {
      // The following is slower
      // string rendering = "";
      // for (auto y = 0; y < height; y++) {
      //   for (auto x = 0; x < width; x++) {
      //     auto cell = cell_at(x, y);
      //     rendering ~= cell.to_char();
      //   }
      //   rendering ~= "\n";
      // }
      // return rendering;

      // The following is slower
      // string[] rendering = [];
      // for (auto y = 0; y < height; y++) {
      //   for (auto x = 0; x < width; x++) {
      //     auto cell = cell_at(x, y);
      //     rendering ~= to!string(cell.to_char());
      //   }
      //   rendering ~= "\n";
      // }
      // return rendering.join("");

      // The following is the fastest
      auto render_size = width * height + height;
      char[] rendering = new char[render_size];
      for (auto y = 0; y < height; y++) {
        for (auto x = 0; x < width; x++) {
          auto cell = cell_at(x, y);
          rendering ~= cell.to_char();
        }
        rendering ~= "\n";
      }
      return cast(string)rendering;
    }

  private:
    uint width;
    uint height;
    Cell[string] cells;

    static class LocationOccupied: Exception {
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

    static immutable DIRECTIONS = [
      [-1, 1],  [0, 1],  [1, 1],  // above
      [-1, 0],           [1, 0],  // sides
      [-1, -1], [0, -1], [1, -1], // below
    ];

    auto cell_at(int x, int y) {
      auto key = to!string(x)~"-"~to!string(y);
      return cells.get(key, null);
    }

    auto populate_cells() {
      for (auto y = 0; y < height; y++) {
        for (auto x = 0; x < width; x++) {
          auto random = uniform01;
          auto alive = (random <= 0.2);
          add_cell(x, y, alive);
        }
      }
    }

    auto add_cell(int x, int y, bool alive = false) {
      if (cell_at(x, y)) {
        throw new LocationOccupied(x, y);
      }

      auto key = to!string(x)~"-"~to!string(y);
      auto cell = new Cell(x, y, alive);
      cells[key] = cell;
      return true;
    }

    auto prepopulate_neighbours() {
      foreach (ref cell; cells) {
        auto x = cell.x;
        auto y = cell.y;

        foreach (ref set; DIRECTIONS) {
          auto nx = x + set[0];
          auto ny = y + set[1];
          if (nx < 0 || ny < 0) {
            continue; // Out of bounds
          }

          if (nx >= width || ny >= height) {
            continue; // Out of bounds
          }

          auto neighbour = cell_at(nx, ny);
          if (neighbour) {
            cell.neighbours ~= neighbour;
          }
        }
      }
    }
}
