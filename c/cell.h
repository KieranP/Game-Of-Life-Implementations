#ifndef CELL_H
#define CELL_H

#include <stdbool.h>

#define MAX_NEIGHBOURS 8

typedef struct Cell {
  int x;
  int y;
  bool alive;
  bool next_state;
  struct Cell *neighbours[MAX_NEIGHBOURS];
  int neighbour_count;
} Cell;

Cell *cell_new(int x, int y, bool alive);
char cell_to_char(Cell *cell);
int cell_alive_neighbours(Cell *cell);

#endif
