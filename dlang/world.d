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

      populateCells();
      prepopulateNeighbours();
    }

    auto doTick() {
      // First determine the action for all cells
      foreach (ref cell; cells) {
        auto aliveNeighbours = cell.aliveNeighbours();
        if (!cell.alive && aliveNeighbours == 3) {
          cell.nextState = true;
        } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
          cell.nextState = false;
        } else {
          cell.nextState = cell.alive;
        }
      }

      // Then execute the determined action for all cells
      foreach (ref cell; cells) {
        cell.alive = cell.nextState.get;
      }

      tick += 1;
    }

    auto render() {
      // The following is slower
      // string rendering = "";
      // foreach (y; 0 .. height) {
      //   foreach (x; 0 .. width) {
      //     auto cell = cellAt(x, y);
      //     if (cell) {
      //       rendering ~= cell.toChar();
      //     }
      //   }
      //   rendering ~= "\n";
      // }
      // return rendering;

      // The following is slower
      // string[] rendering = [];
      // foreach (y; 0 .. height) {
      //   foreach (x; 0 .. width) {
      //     auto cell = cellAt(x, y);
      //     if (cell) {
      //       rendering ~= to!string(cell.toChar());
      //     }
      //   }
      //   rendering ~= "\n";
      // }
      // return rendering.join("");

      // The following is the fastest
      auto renderSize = width * height + height;
      char[] rendering;
      rendering.reserve(renderSize);
      foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
          auto cell = cellAt(x, y);
          if (cell) {
            rendering ~= cell.toChar();
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

    static immutable Tuple!(int, "relX", int, "relY")[] directions = [
      tuple(-1, 1),  tuple(0, 1),  tuple(1, 1),  // above
      tuple(-1, 0),                tuple(1, 0),  // sides
      tuple(-1, -1), tuple(0, -1), tuple(1, -1), // below
    ];

    static auto makeKey(ref char[24] buf, int x, int y) {
      // The following is slower
      // return format("%d-%d", x, y);

      // The following is slower
      // return to!string(x) ~ "-" ~ to!string(y);

      // The following is slower
      // return [to!string(x), to!string(y)].join("-");

      // The following is the fastest
      auto xChars = toChars(x);
      auto pos = xChars.length;
      copy(xChars, buf[0..pos]);
      buf[pos++] = '-';
      auto yChars = toChars(y);
      copy(yChars, buf[pos..pos + yChars.length]);
      pos += yChars.length;
      return buf[0..pos];
    }

    auto cellAt(int x, int y) {
      char[24] buf;
      auto key = cast(string)makeKey(buf, x, y);

      return cells.get(key, null);
    }

    auto populateCells() {
      foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
          auto random = uniform01;
          auto alive = random <= 0.2;
          addCell(x, y, alive);
        }
      }
    }

    auto addCell(int x, int y, bool alive = false) {
      auto existing = cellAt(x, y);
      if (existing) {
        throw new LocationOccupied(x, y);
      }

      char[24] buf;
      auto key = cast(string)makeKey(buf, x, y).dup;

      auto cell = new Cell(x, y, alive);
      cells[key] = cell;
      return true;
    }

    auto prepopulateNeighbours() {
      foreach (ref cell; cells) {
        auto x = cell.x;
        auto y = cell.y;

        foreach (ref set; directions) {
          auto nx = x + set.relX;
          auto ny = y + set.relY;
          if (nx < 0 || ny < 0) {
            continue; // Out of bounds
          }

          if (nx >= width || ny >= height) {
            continue; // Out of bounds
          }

          auto neighbour = cellAt(nx, ny);
          if (neighbour) {
            cell.neighbours ~= neighbour;
          }
        }
      }
    }
}
