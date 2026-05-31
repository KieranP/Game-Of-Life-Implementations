import cell;
import std.conv : toChars;
// import std.conv : to;
import std.algorithm.mutation : copy;
import std.random : uniform01;
// import std.array : array, join;
import std.format : format;
import std.typecons : tuple, Tuple;

class World {
  public:
    uint tick;

    this(uint width, uint height) {
      this.width = width;
      this.height = height;

      populate_cells();
      prepopulate_neighbours();
    }

    auto dotick() {
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
        cell.alive = cell.next_state.get;
      }

      tick += 1;
    }

    auto render() {
      // The following is slower
      // string rendering = "";
      // foreach (y; 0 .. height) {
      //   foreach (x; 0 .. width) {
      //     auto cell = cell_at(x, y);
      //     if (cell) {
      //       rendering ~= cell.to_char();
      //     }
      //   }
      //   rendering ~= "\n";
      // }
      // return rendering;

      // The following is slower
      // string[] rendering = [];
      // foreach (y; 0 .. height) {
      //   foreach (x; 0 .. width) {
      //     auto cell = cell_at(x, y);
      //     if (cell) {
      //       rendering ~= to!string(cell.to_char());
      //     }
      //   }
      //   rendering ~= "\n";
      // }
      // return rendering.join("");

      // The following is the fastest
      auto render_size = width * height + height;
      char[] rendering;
      rendering.reserve(render_size);
      foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
          auto cell = cell_at(x, y);
          if (cell) {
            rendering ~= cell.to_char();
          }
        }
        rendering ~= "\n";
      }
      return cast(string)rendering;
    }

  private:
    const uint width;
    const uint height;
    Cell[string] cells;

    static class LocationOccupied: Exception {
      public:
        this(uint x, uint y) {
          this.x = x;
          this.y = y;

          auto key = format!"%d-%d"(x, y);
          super("LocationOccupied("~key~")");
        }

      private:
        uint x, y;
    }

    static immutable Tuple!(int, "rel_x", int, "rel_y")[] DIRECTIONS = [
      tuple(-1, 1),  tuple(0, 1),  tuple(1, 1),  // above
      tuple(-1, 0),                tuple(1, 0),  // sides
      tuple(-1, -1), tuple(0, -1), tuple(1, -1), // below
    ];

    static auto make_key(ref char[24] buf, int x, int y) {
      // The following is slower
      // return format("%d-%d", x, y);

      // The following is slower
      // return to!string(x) ~ "-" ~ to!string(y);

      // The following is slower
      // return [to!string(x), to!string(y)].join("-");

      // The following is the fastest
      auto x_chars = toChars(x);
      auto pos = x_chars.length;
      copy(x_chars, buf[0..pos]);
      buf[pos++] = '-';
      auto y_chars = toChars(y);
      copy(y_chars, buf[pos..pos + y_chars.length]);
      pos += y_chars.length;
      return buf[0..pos];
    }

    auto cell_at(int x, int y) {
      char[24] buf;
      auto key = cast(string)make_key(buf, x, y);

      return cells.get(key, null);
    }

    auto populate_cells() {
      foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
          auto random = uniform01;
          auto alive = random <= 0.2;
          add_cell(x, y, alive);
        }
      }
    }

    auto add_cell(int x, int y, bool alive = false) {
      auto existing = cell_at(x, y);
      if (existing) {
        throw new LocationOccupied(x, y);
      }

      char[24] buf;
      auto key = cast(string)make_key(buf, x, y).dup;

      auto cell = new Cell(x, y, alive);
      cells[key] = cell;
      return true;
    }

    auto prepopulate_neighbours() {
      foreach (ref cell; cells) {
        auto x = cell.x;
        auto y = cell.y;

        foreach (ref set; DIRECTIONS) {
          auto nx = x + set.rel_x;
          auto ny = y + set.rel_y;
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
