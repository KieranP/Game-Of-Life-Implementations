from world import World
from time import monotonic_ns
from os import environ
import math

class Play:
  WORLD_WIDTH = 150
  WORLD_HEIGHT = 40
  CLEAR_SCREEN = "\x1b[?2026h\x1b[H\x1b[2J"
  SHOW_SCREEN = "\x1b[?2026l"

  @classmethod
  def run(cls) -> None:
    world = World(
      Play.WORLD_WIDTH,
      Play.WORLD_HEIGHT,
    )

    minimal = environ.get("MINIMAL") == "1"

    if not minimal:
      print(world.render())

    total_tick = 0
    lowest_tick = math.inf
    total_render = 0
    lowest_render = math.inf

    while True:
      tick_start = monotonic_ns()
      world.dotick()
      tick_finish = monotonic_ns()
      tick_time = (tick_finish - tick_start)
      total_tick += tick_time
      lowest_tick = min(lowest_tick, tick_time)
      avg_tick = (total_tick / world.tick)

      render_start = monotonic_ns()
      rendered = world.render()
      render_finish = monotonic_ns()
      render_time = (render_finish - render_start)
      total_render += render_time
      lowest_render = min(lowest_render, render_time)
      avg_render = (total_render / world.tick)

      if not minimal:
        print(Play.CLEAR_SCREEN, end="")

      print(
        f"#{world.tick}"
        f" - World Tick (L: {Play._f(lowest_tick):.3f}; A: {Play._f(avg_tick):.3f})"
        f" - Rendering (L: {Play._f(lowest_render):.3f}; A: {Play._f(avg_render):.3f})"
      )

      if not minimal:
        print(rendered + Play.SHOW_SCREEN)

  @staticmethod
  def _f(value: float) -> float:
    # nanoseconds -> milliseconds
    return value / 1_000_000

Play.run()
