#include "cell.h"
#include <stdbool.h>
#include <stdlib.h>

Cell *cell_new(uint32_t x, uint32_t y, bool alive) {
  auto cell = (Cell *)malloc(sizeof(Cell));
  cell->x = x;
  cell->y = y;
  cell->alive = alive;
  cell->next_state = alive;
  cell->neighbour_count = 0;
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
