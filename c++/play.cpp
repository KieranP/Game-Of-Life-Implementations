#include <iostream>
#include "world.cpp"

using namespace std;

class Play {
  public:
    static const auto World_Width = 150;
    static const auto World_Height = 40;

    static void run() {
      auto world = new World(
        World_Width,
        World_Height
      );

      auto minimal = getenv("MINIMAL") != NULL;

      if (!minimal) {
        cout << world->render();
      }

      auto total_tick = 0.0;
      auto lowest_tick = std::numeric_limits<double>::infinity();
      auto total_render = 0.0;
      auto lowest_render = std::numeric_limits<double>::infinity();

      while(true) {
        auto tick_start = std::chrono::steady_clock::now();
        world->_tick();
        auto tick_finish = std::chrono::steady_clock::now();
        auto tick_time = std::chrono::duration_cast<std::chrono::nanoseconds>(tick_finish - tick_start).count();
        total_tick += tick_time;
        lowest_tick = min(lowest_tick, (double)tick_time);
        auto avg_tick = total_tick / world->tick;

        auto render_start = std::chrono::steady_clock::now();
        auto rendered = world->render();
        auto render_finish = std::chrono::steady_clock::now();
        auto render_time = std::chrono::duration_cast<std::chrono::nanoseconds>(render_finish - render_start).count();
        total_render += render_time;
        lowest_render = min(lowest_render, (double)render_time);
        auto avg_render = total_render / world->tick;

        if (!minimal) {
          cout << "\u001b[H\u001b[2J";
        }
        printf(
          "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
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
