#include "cell.h"
#include <stdbool.h>
#include <stdlib.h>

Cell *cell_new(int x, int y, bool alive) {
  Cell *cell = malloc(sizeof(Cell));
  cell->x = x;
  cell->y = y;
  cell->alive = alive;
  cell->next_state = alive;
  cell->neighbour_count = 0;
  return cell;
}

char cell_to_char(Cell *cell) { return cell->alive ? 'o' : ' '; }

// Implement first using filter/lambda if available. Then implement
// foreach and for. Use whatever implementation runs the fastest
int cell_alive_neighbours(Cell *cell) {
  int alive_neighbours = 0;
  for (int i = 0; i < cell->neighbour_count; i++) {
    if (cell->neighbours[i]->alive) {
      alive_neighbours++;
    }
  }
  return alive_neighbours;
}
