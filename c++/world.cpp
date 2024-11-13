#include <algorithm>
#include <sstream>
#include <unordered_map>

using namespace std;

class Cell {
  public:
    int x, y;
    bool alive;
    bool next_state;
    vector<Cell*>* neighbours;

    Cell(int x, int y, bool alive = false): x(x), y(y), alive(alive) {
    }

    char to_char() {
      return alive ? 'o' : ' ';
    }
};

class World {
  public:
    int tick;

    World(int width, int height): width(width), height(height) {
      populate_cells();
      prepopulate_neighbours();
    }

    void _tick() {
      // First determine the action for all cells
      for (auto& [_, cell] : cells) {
        auto alive_neighbours = alive_neighbours_around(cell);
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

    // Implement first using string concatenation. Then implement any
    // special string builders, and use whatever runs the fastest
    string render() {
      // The following works but it slower
      // string rendering = "";
      // for (auto y = 0; y < height; y++) {
      //   for (auto x = 0; x < width; x++) {
      //     auto cell = *cell_at(x, y);
      //     rendering += cell->to_char();
      //   }
      //   rendering += "\n";
      // }
      // return rendering;

      // The following was the fastest method
      stringstream rendering;
      for (auto y = 0; y < height; y++) {
        for (auto x = 0; x < width; x++) {
          auto cell = cell_at(x, y);
          rendering << cell->to_char();
        }
        rendering << "\n";
      }
      return rendering.str();
    }

  private:
    int width, height;
    unordered_map<string, Cell*> cells;
    vector<pair<int, int>> cached_directions = {
      {-1, 1},  {0, 1},  {1, 1},  // above
      {-1, 0},           {1, 0},  // sides
      {-1, -1}, {0, -1}, {1, -1}, // below
    };

    class LocationOccupied : public exception {
      public:
        LocationOccupied(int x, int y) : x(x), y(y) {}

        string what() {
          auto key = to_string(x)+"-"+to_string(y);
          return "LocationOccupied("+key+")";
        }

      private:
        int x, y;
    };

    void populate_cells() {
      for (auto y = 0; y < height; y++) {
        for (auto x = 0; x < width; x++) {
          auto random = (float) rand() / RAND_MAX;
          auto alive = (random <= 0.2);
          add_cell(x, y, alive);
        }
      }
    }

    void prepopulate_neighbours() {
      for (auto& [_, cell] : cells) {
        neighbours_around(cell);
      }
    }

    Cell* add_cell(int x, int y, bool alive = false) {
      if (cell_at(x, y)) {
        throw LocationOccupied(x, y);
      }

      auto key = to_string(x)+"-"+to_string(y);
      auto cell = new Cell(x, y, alive);
      cells[key] = cell;
      return cell;
    }

    Cell* cell_at(int x, int y) {
      auto key = to_string(x)+"-"+to_string(y);
      auto it = cells.find(key);
      return it != cells.end() ? it->second : nullptr;
    }

    vector<Cell*>* neighbours_around(Cell* cell) {
      if (!cell->neighbours) {
        cell->neighbours = new vector<Cell*>();

        for (auto& [x,y] : cached_directions) {
          auto neighbour = cell_at(
            (cell->x + x),
            (cell->y + y)
          );

          if (neighbour) {
            cell->neighbours->push_back(neighbour);
          }
        }
      }

      return cell->neighbours;
    }

    // Implement first using filter/lambda if available. Then implement
    // foreach and for. Use whatever implementation runs the fastest
    int alive_neighbours_around(Cell* cell) {
      auto neighbours = neighbours_around(cell);

      // The following was the fastest method
      return count_if(
        begin(*neighbours),
        end(*neighbours),
        [](auto *neighbour) { return neighbour->alive; }
      );

      // The following is about the same time as the fastest
      // auto alive_neighbours = 0;
      // for (auto& neighbour : *neighbours) {
      //   if (neighbour->alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;

      // The following is about the same time as the fastest
      // auto alive_neighbours = 0;
      // for (auto i = 0; i < (*neighbours).size(); i++) {
      //   auto neighbour = (*neighbours)[i];
      //   if (neighbour->alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;
    }
};
