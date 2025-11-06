#include "world.h"
#include "cell.h"
#include "lib/utils.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const int DIRECTIONS[8][2] = {
    {-1, 1},  {0, 1},  {1, 1},  // above
    {-1, 0},  {1, 0},           // sides
    {-1, -1}, {0, -1}, {1, -1}, // below
};

static void make_key(char *buffer, int x, int y) {
  auto ptr = int_to_str(buffer, x);
  *ptr++ = '-';
  ptr = int_to_str(ptr, y);
  *ptr = '\0';
}

static Cell *cell_at(World *world, int x, int y) {
  char key[32];
  make_key(key, x, y);

  return (Cell *)hashmap_get(world->cells, key);
}

static bool add_cell(World *world, int x, int y, bool alive) {
  if (cell_at(world, x, y)) {
    fprintf(stderr, "LocationOccupied(%d-%d)\n", x, y);
    exit(1);
  }

  char key[32];
  make_key(key, x, y);

  auto cell = cell_new(x, y, alive);
  hashmap_put(world->cells, key, cell);
  return true;
}

static void populate_cells(World *world) {
  for (auto y = 0; y < world->height; y++) {
    for (auto x = 0; x < world->width; x++) {
      auto random = (float)rand() / RAND_MAX;
      auto alive = (random <= 0.2);
      add_cell(world, x, y, alive);
    }
  }
}

static void prepopulate_neighbours(World *world) {
  for (auto y = 0; y < world->height; y++) {
    for (auto x = 0; x < world->width; x++) {
      auto cell = cell_at(world, x, y);
      if (!cell)
        continue;

      for (auto d = 0; d < 8; d++) {
        auto nx = cell->x + DIRECTIONS[d][0];
        auto ny = cell->y + DIRECTIONS[d][1];
        auto neighbour = cell_at(world, nx, ny);

        if (neighbour) {
          cell->neighbours[cell->neighbour_count++] = neighbour;
        }
      }
    }
  }
}

World *world_new(int width, int height) {
  auto world = (World *)malloc(sizeof(World));
  world->width = width;
  world->height = height;
  world->tick = 0;
  world->cells = hashmap_new();

  populate_cells(world);
  prepopulate_neighbours(world);

  return world;
}

void world_tick(World *world) {
  auto cells = (Cell **)hashmap_get_all_values(world->cells);
  auto cell_count = world->cells->count;

  // First determine the action for all cells
  for (auto i = 0; i < cell_count; i++) {
    auto cell = cells[i];
    auto alive_neighbours = cell_alive_neighbours(cell);
    if (!cell->alive && alive_neighbours == 3) {
      cell->next_state = true;
    } else if (alive_neighbours < 2 || alive_neighbours > 3) {
      cell->next_state = false;
    } else {
      cell->next_state = cell->alive;
    }
  }

  // Then execute the determined action for all cells
  for (auto i = 0; i < cell_count; i++) {
    auto cell = cells[i];
    cell->alive = cell->next_state;
  }

  free(cells);
  world->tick++;
}

// Implement first using string concatenation. Then implement any
// special string builders, and use whatever runs the fastest
char *world_render(World *world) {
  auto size = world->width * world->height + world->height + 1;
  auto rendering = (char *)malloc(size);
  auto idx = 0;

  for (auto y = 0; y < world->height; y++) {
    for (auto x = 0; x < world->width; x++) {
      auto cell = cell_at(world, x, y);
      rendering[idx++] = cell_to_char(cell);
    }
    rendering[idx++] = '\n';
  }
  rendering[idx] = '\0';

  return rendering;
}
