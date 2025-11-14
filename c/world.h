#ifndef WORLD_H
#define WORLD_H

#include "lib/hashmap.h"
#include <stdint.h>

typedef struct {
  uint32_t width;
  uint32_t height;
  uint32_t tick;
  HashMap *cells;
} World;

World *world_new(uint32_t width, uint32_t height);
void world_tick(World *world);
char *world_render(World *world);

#endif
