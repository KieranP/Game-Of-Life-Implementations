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

      cout << world->render();

      auto total_tick = 0.0;
      auto total_render = 0.0;

      while(true) {
        auto tick_start = std::chrono::high_resolution_clock::now();
        world->_tick();
        auto tick_finish = std::chrono::high_resolution_clock::now();
        auto tick_time = std::chrono::duration_cast<std::chrono::nanoseconds>(tick_finish - tick_start).count();
        total_tick += tick_time;
        auto avg_tick = total_tick / world->tick;

        auto render_start = std::chrono::high_resolution_clock::now();
        auto rendered = world->render();
        auto render_finish = std::chrono::high_resolution_clock::now();
        auto render_time = std::chrono::duration_cast<std::chrono::nanoseconds>(render_finish - render_start).count();
        total_render += render_time;
        auto avg_render = total_render / world->tick;

        cout << "\u001b[H\u001b[2J";
        printf(
          "#%d - World tick took %.3f (%.3f) - Rendering took %.3f (%.3f)\n",
          world->tick,
          tick_time / 1000000.0,
          avg_tick / 1000000.0,
          render_time / 1000000.0,
          avg_render / 1000000.0
        );
        cout << rendered;
      }
    }
};

int main () {
  // Initialize the random seed generator
  srand(time(NULL));

  Play::run();
}
