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

  auto world = world_new(WORLD_WIDTH, WORLD_HEIGHT);

  auto minimal = getenv("MINIMAL") != NULL;

  if (!minimal) {
    auto rendered = world_render(world);
    printf("%s", rendered);
    free(rendered);
  }

  auto total_tick = 0.0;
  auto lowest_tick = INFINITY;
  auto total_render = 0.0;
  auto lowest_render = INFINITY;

  while (true) {
    auto tick_start = get_time_ns();
    world_tick(world);
    auto tick_finish = get_time_ns();
    auto tick_time = tick_finish - tick_start;
    total_tick += tick_time;
    lowest_tick = min_double(lowest_tick, tick_time);
    auto avg_tick = total_tick / world->tick;

    auto render_start = get_time_ns();
    auto rendered = world_render(world);
    auto render_finish = get_time_ns();
    auto render_time = render_finish - render_start;
    total_render += render_time;
    lowest_render = min_double(lowest_render, render_time);
    auto avg_render = total_render / world->tick;

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
