#include <algorithm>
#include <vector>

using namespace std;

class Cell {
  public:
    uint32_t x;
    uint32_t y;
    bool alive;
    bool next_state;
    vector<Cell*> neighbours;

    Cell(uint32_t x, uint32_t y, bool alive = false): x(x), y(y), alive(alive) { }

    char to_char() {
      return alive ? 'o' : ' ';
    }

    uint32_t alive_neighbours() {
      // The following is the fastest
      return count_if(
        begin(neighbours),
        end(neighbours),
        [](auto *neighbour) { return neighbour->alive; }
      );

      // The following is about the same speed
      // auto alive_neighbours = 0;
      // for (auto& neighbour : neighbours) {
      //   if (neighbour->alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;

      // The following is about the same speed
      // auto alive_neighbours = 0;
      // auto count = neighbours.size();
      // for (auto i = 0; i < count; i++) {
      //   auto neighbour = neighbours[i];
      //   if (neighbour->alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;
    }
};
