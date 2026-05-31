#include "cell.h"
#include <stdlib.h>

Cell *cell_new(uint32_t x, uint32_t y, bool alive) {
  Cell *cell = malloc(sizeof(*cell));
  *cell = (Cell){.x = x, .y = y, .alive = alive, .next_state = alive};
  return cell;
}

char cell_to_char(Cell *cell) { return cell->alive ? 'o' : ' '; }

uint32_t cell_alive_neighbours(Cell *cell) {
  auto alive_neighbours = 0;
  auto count = cell->neighbour_count;
  for (auto i = 0; i < count; i++) {
    if (cell->neighbours[i]->alive) {
      alive_neighbours++;
    }
  }
  return alive_neighbours;
}
