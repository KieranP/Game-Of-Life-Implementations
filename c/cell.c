#include "cell.h"
#include <stdio.h>
#include <stdlib.h>

Cell *cell_new(uint32_t x, uint32_t y, bool alive) {
  Cell *cell = malloc(sizeof(*cell));
  if (!cell) {
    fprintf(stderr, "Out of memory\n");
    exit(1);
  }
  *cell = (Cell){.x = x, .y = y, .alive = alive, .next_state = alive};
  return cell;
}

void cell_free(Cell *cell) { free(cell); }

char cell_to_char(Cell *cell) { return cell->alive ? 'o' : ' '; }

uint32_t cell_alive_neighbours(Cell *cell) {
  // The following is slower
  // auto alive_neighbours = 0;
  // auto end = cell->neighbours + cell->neighbour_count;
  // for (auto neighbour = cell->neighbours; neighbour < end; neighbour++) {
  //   if ((*neighbour)->alive) {
  //     alive_neighbours++;
  //   }
  // }
  // return alive_neighbours;

  // The following is the fastest
  auto alive_neighbours = 0;
  auto count = cell->neighbour_count;
  for (auto i = 0; i < count; i++) {
    if (cell->neighbours[i]->alive) {
      alive_neighbours++;
    }
  }
  return alive_neighbours;
}
