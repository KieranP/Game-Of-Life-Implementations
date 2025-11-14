#ifndef CELL_H
#define CELL_H

#include <stdbool.h>
#include <stdint.h>

#define MAX_NEIGHBOURS 8

typedef struct Cell {
  uint32_t x;
  uint32_t y;
  bool alive;
  bool next_state;
  struct Cell *neighbours[MAX_NEIGHBOURS];
  uint32_t neighbour_count;
} Cell;

Cell *cell_new(uint32_t x, uint32_t y, bool alive);
char cell_to_char(Cell *cell);
uint32_t cell_alive_neighbours(Cell *cell);

#endif
