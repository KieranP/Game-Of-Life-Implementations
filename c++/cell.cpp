#include <algorithm>
#include <vector>

using namespace std;

class Cell {
  public:
    int x, y;
    bool alive;
    bool next_state;
    vector<Cell*> neighbours;

    Cell(int x, int y, bool alive = false): x(x), y(y), alive(alive) { }

    char to_char() {
      return alive ? 'o' : ' ';
    }

    // Implement first using filter/lambda if available. Then implement
    // foreach and for. Use whatever implementation runs the fastest
    int alive_neighbours() {
      // The following was the fastest method
      return count_if(
        begin(neighbours),
        end(neighbours),
        [](auto *neighbour) { return neighbour->alive; }
      );

      // The following is about the same time as the fastest
      // auto alive_neighbours = 0;
      // for (auto& neighbour : neighbours) {
      //   if (neighbour->alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;

      // The following is about the same time as the fastest
      // auto alive_neighbours = 0;
      // for (auto i = 0; i < neighbours.size(); i++) {
      //   auto neighbour = neighbours[i];
      //   if (neighbour->alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;
    }
};
