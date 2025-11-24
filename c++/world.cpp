#include "cell.cpp"
// #include <sstream>
#include <unordered_map>
#include <vector>

using namespace std;

class World {
  public:
    uint32_t tick;

    World(uint32_t width, uint32_t height): width(width), height(height) {
      populate_cells();
      prepopulate_neighbours();
    }

    void dotick() {
      // First determine the action for all cells
      for (auto& [_, cell] : cells) {
        auto alive_neighbours = cell->alive_neighbours();
        if (!cell->alive && alive_neighbours == 3) {
          cell->next_state = true;
        } else if (alive_neighbours < 2 || alive_neighbours > 3) {
          cell->next_state = false;
        } else {
          cell->next_state = cell->alive;
        }
      }

      // Then execute the determined action for all cells
      for (auto& [_, cell] : cells) {
        cell->alive = cell->next_state;
      }

      tick++;
    }

    string render() {
      // The following is the fastest
      uint32_t render_size = width * height + height;
      string rendering;
      rendering.reserve(render_size);
      for (auto y = 0; y < height; y++) {
        for (auto x = 0; x < width; x++) {
          auto cell = cell_at(x, y);
          if (cell) {
            rendering += cell->to_char();
          }
        }
        rendering += '\n';
      }
      return rendering;

      // The following is slower
      // stringstream rendering;
      // for (auto y = 0; y < height; y++) {
      //   for (auto x = 0; x < width; x++) {
      //     auto cell = cell_at(x, y);
      //     if (cell) {
      //       rendering << cell->to_char();
      //     }
      //   }
      //   rendering << '\n';
      // }
      // return rendering.str();
    }

  private:
    uint32_t width;
    uint32_t height;
    unordered_map<string, Cell*> cells;

    class LocationOccupied : public exception {
      public:
        LocationOccupied(uint32_t x, uint32_t y) : x(x), y(y) { }

        string what() {
          auto key = to_string(x)+"-"+to_string(y);
          return "LocationOccupied("+key+")";
        }

      private:
        uint32_t x, y;
    };

    static inline const vector<pair<int, int>> DIRECTIONS = {
      {-1, 1},  {0, 1},  {1, 1},  // above
      {-1, 0},           {1, 0},  // sides
      {-1, -1}, {0, -1}, {1, -1}, // below
    };

    Cell* cell_at(uint32_t x, uint32_t y) {
      auto key = to_string(x)+"-"+to_string(y);
      auto it = cells.find(key);
      return it != cells.end() ? it->second : nullptr;
    }

    void populate_cells() {
      for (auto y = 0; y < height; y++) {
        for (auto x = 0; x < width; x++) {
          auto random = (float) rand() / RAND_MAX;
          auto alive = (random <= 0.2);
          add_cell(x, y, alive);
        }
      }
    }

    bool add_cell(uint32_t x, uint32_t y, bool alive = false) {
      auto existing = cell_at(x, y);
      if (existing) {
        throw LocationOccupied(x, y);
      }

      auto key = to_string(x)+"-"+to_string(y);
      auto cell = new Cell(x, y, alive);
      cells[key] = cell;
      return true;
    }

    void prepopulate_neighbours() {
      for (auto& [_, cell] : cells) {
        auto x = (int)cell->x;
        auto y = (int)cell->y;

        for (auto& set : DIRECTIONS) {
          auto nx = x + set.first;
          auto ny = y + set.second;
          if (nx < 0 || ny < 0) {
            continue; // Out of bounds
          }

          auto ux = (uint32_t)nx;
          auto uy = (uint32_t)ny;
          if (ux >= width || uy >= height) {
            continue; // Out of bounds
          }

          auto neighbour = cell_at(ux, uy);
          if (neighbour) {
            cell->neighbours.push_back(neighbour);
          }
        }
      }
    }
};
