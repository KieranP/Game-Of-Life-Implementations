#include <iostream>
#include "world.cpp"

using namespace std;

class Play {
  public:
    static const auto WORLD_WIDTH = 150;
    static const auto WORLD_HEIGHT = 40;

    static void run() {
      auto world = new World(
        WORLD_WIDTH,
        WORLD_HEIGHT
      );

      auto minimal = getenv("MINIMAL") != nullptr;

      if (!minimal) {
        cout << world->render();
      }

      auto total_tick = 0.0;
      auto lowest_tick = numeric_limits<double>::infinity();
      auto total_render = 0.0;
      auto lowest_render = numeric_limits<double>::infinity();

      while(true) {
        auto tick_start = chrono::high_resolution_clock::now();
        world->_tick();
        auto tick_finish = chrono::high_resolution_clock::now();
        auto tick_time = chrono::duration<double, std::nano>(tick_finish - tick_start).count();
        total_tick += tick_time;
        lowest_tick = min(lowest_tick, tick_time);
        auto avg_tick = total_tick / world->tick;

        auto render_start = chrono::high_resolution_clock::now();
        auto rendered = world->render();
        auto render_finish = chrono::high_resolution_clock::now();
        auto render_time = chrono::duration<double, std::nano>(render_finish - render_start).count();
        total_render += render_time;
        lowest_render = min(lowest_render, render_time);
        auto avg_render = total_render / world->tick;

        if (!minimal) {
          cout << "\u001b[H\u001b[2J";
        }

        printf(
          "#%u - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
          world->tick,
          _f(lowest_tick),
          _f(avg_tick),
          _f(lowest_render),
          _f(avg_render)
        );

        if (!minimal) {
          cout << rendered;
        }
      }
    }

  private:
    static double _f(double value) {
      return value / 1'000'000.0;
    }
};

int main () {
  // Initialize the random seed generator
  srand(time(NULL));

  Play::run();
}
