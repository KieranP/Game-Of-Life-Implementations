#include "lib/utils.h"
#include "world.h"
#include <limits.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define WORLD_WIDTH 150
#define WORLD_HEIGHT 40

int main(void) {
  // Initialize the random seed generator
  srand(time(NULL));

  World *world = world_new(WORLD_WIDTH, WORLD_HEIGHT);

  bool minimal = getenv("MINIMAL") != NULL;

  if (!minimal) {
    char *rendered = world_render(world);
    printf("%s", rendered);
    free(rendered);
  }

  double total_tick = 0.0;
  double lowest_tick = INFINITY;
  double total_render = 0.0;
  double lowest_render = INFINITY;

  while (true) {
    double tick_start = get_time_ns();
    world_tick(world);
    double tick_finish = get_time_ns();
    double tick_time = tick_finish - tick_start;
    total_tick += tick_time;
    lowest_tick = min_double(lowest_tick, tick_time);
    double avg_tick = total_tick / world->tick;

    double render_start = get_time_ns();
    char *rendered = world_render(world);
    double render_finish = get_time_ns();
    double render_time = render_finish - render_start;
    total_render += render_time;
    lowest_render = min_double(lowest_render, render_time);
    double avg_render = total_render / world->tick;

    if (!minimal) {
      printf("\033[H\033[2J");
    }

    printf(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
        world->tick, to_ms(lowest_tick), to_ms(avg_tick), to_ms(lowest_render),
        to_ms(avg_render));

    if (!minimal) {
      printf("%s", rendered);
    }

    free(rendered);
  }
}
