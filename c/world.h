#ifndef WORLD_H
#define WORLD_H

#include "lib/hashmap.h"
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

typedef struct {
  int width;
  int height;
  int tick;
  HashMap *cells;
} World;

World *world_new(int width, int height);
void world_tick(World *world);
char *world_render(World *world);

#endif
