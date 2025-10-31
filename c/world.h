#ifndef WORLD_H
#define WORLD_H

#include "lib/hashmap.h"

#define MAX_NEIGHBOURS 8

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
