#include "world.h"
#include "lib/utils.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const int DIRECTIONS[8][2] = {
    {-1, 1},  {0, 1},  {1, 1}, // above
    {-1, 0},  {1, 0},          // sides
    {-1, -1}, {0, -1}, {1, -1} // below
};

static Cell *cell_new(int x, int y, bool alive) {
  Cell *cell = malloc(sizeof(Cell));
  cell->x = x;
  cell->y = y;
  cell->alive = alive;
  cell->next_state = alive;
  cell->neighbour_count = 0;
  return cell;
}

static char cell_to_char(Cell *cell) { return cell->alive ? 'o' : ' '; }

static void make_key(char *buffer, int x, int y) {
  char *ptr = int_to_str(buffer, x);
  *ptr++ = '-';
  ptr = int_to_str(ptr, y);
  *ptr = '\0';
}

static Cell *cell_at(World *world, int x, int y) {
  char key[32];
  make_key(key, x, y);

  return (Cell *)hashmap_get(world->cells, key);
}

static Cell *add_cell(World *world, int x, int y, bool alive) {
  if (cell_at(world, x, y)) {
    fprintf(stderr, "LocationOccupied(%d-%d)\n", x, y);
    exit(1);
  }

  char key[32];
  make_key(key, x, y);

  Cell *cell = cell_new(x, y, alive);
  hashmap_put(world->cells, key, cell);
  return cell;
}

static void populate_cells(World *world) {
  for (int y = 0; y < world->height; y++) {
    for (int x = 0; x < world->width; x++) {
      float random = (float)rand() / RAND_MAX;
      bool alive = (random <= 0.2);
      add_cell(world, x, y, alive);
    }
  }
}

static void prepopulate_neighbours(World *world) {
  for (int y = 0; y < world->height; y++) {
    for (int x = 0; x < world->width; x++) {
      Cell *cell = cell_at(world, x, y);
      if (!cell)
        continue;

      for (int d = 0; d < 8; d++) {
        int nx = cell->x + DIRECTIONS[d][0];
        int ny = cell->y + DIRECTIONS[d][1];
        Cell *neighbour = cell_at(world, nx, ny);

        if (neighbour) {
          cell->neighbours[cell->neighbour_count++] = neighbour;
        }
      }
    }
  }
}

// Implement first using filter/lambda if available. Then implement
// foreach and for. Use whatever implementation runs the fastest
static int alive_neighbours_around(Cell *cell) {
  int alive_neighbours = 0;
  for (int i = 0; i < cell->neighbour_count; i++) {
    if (cell->neighbours[i]->alive) {
      alive_neighbours++;
    }
  }
  return alive_neighbours;
}

World *world_new(int width, int height) {
  World *world = malloc(sizeof(World));
  world->width = width;
  world->height = height;
  world->tick = 0;
  world->cells = hashmap_new();

  populate_cells(world);
  prepopulate_neighbours(world);

  return world;
}

void world_tick(World *world) {
  Cell **cells = (Cell **)hashmap_get_all_values(world->cells);
  int cell_count = world->cells->count;

  // First determine the action for all cells
  for (int i = 0; i < cell_count; i++) {
    Cell *cell = cells[i];
    int alive_neighbours = alive_neighbours_around(cell);
    if (!cell->alive && alive_neighbours == 3) {
      cell->next_state = true;
    } else if (alive_neighbours < 2 || alive_neighbours > 3) {
      cell->next_state = false;
    } else {
      cell->next_state = cell->alive;
    }
  }

  // Then execute the determined action for all cells
  for (int i = 0; i < cell_count; i++) {
    Cell *cell = cells[i];
    cell->alive = cell->next_state;
  }

  free(cells);
  world->tick++;
}

// Implement first using string concatenation. Then implement any
// special string builders, and use whatever runs the fastest
char *world_render(World *world) {
  int size = world->width * world->height + world->height + 1;
  char *rendering = malloc(size);
  int idx = 0;

  for (int y = 0; y < world->height; y++) {
    for (int x = 0; x < world->width; x++) {
      Cell *cell = cell_at(world, x, y);
      rendering[idx++] = cell_to_char(cell);
    }
    rendering[idx++] = '\n';
  }
  rendering[idx] = '\0';

  return rendering;
}
