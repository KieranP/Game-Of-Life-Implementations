#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <ctime>
#include <limits>
#include <print>
#include "world.cpp"

class Play {
  public:
    static constexpr int WORLD_WIDTH = 150;
    static constexpr int WORLD_HEIGHT = 40;

    static void run() {
      auto world = World(
        WORLD_WIDTH,
        WORLD_HEIGHT
      );

      auto minimal = std::getenv("MINIMAL") != nullptr;

      if (!minimal) {
        std::print("{}", world.render());
      }

      auto total_tick = 0.0;
      auto lowest_tick = std::numeric_limits<double>::infinity();
      auto total_render = 0.0;
      auto lowest_render = std::numeric_limits<double>::infinity();

      while(true) {
        auto tick_start = std::chrono::high_resolution_clock::now();
        world.dotick();
        auto tick_finish = std::chrono::high_resolution_clock::now();
        auto tick_time = std::chrono::duration<double, std::nano>(tick_finish - tick_start).count();
        total_tick += tick_time;
        lowest_tick = std::min(lowest_tick, tick_time);
        auto avg_tick = total_tick / world.tick;

        auto render_start = std::chrono::high_resolution_clock::now();
        auto rendered = world.render();
        auto render_finish = std::chrono::high_resolution_clock::now();
        auto render_time = std::chrono::duration<double, std::nano>(render_finish - render_start).count();
        total_render += render_time;
        lowest_render = std::min(lowest_render, render_time);
        auto avg_render = total_render / world.tick;

        if (!minimal) {
          std::print("\u001b[H\u001b[2J");
        }

        std::println(
          "#{} - World Tick (L: {:.3f}; A: {:.3f}) - Rendering (L: {:.3f}; A: {:.3f})",
          world.tick,
          _f(lowest_tick),
          _f(avg_tick),
          _f(lowest_render),
          _f(avg_render)
        );

        if (!minimal) {
          std::print("{}", rendered);
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
  std::srand(std::time(nullptr));

  Play::run();
}
