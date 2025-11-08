from world import World
from time import monotonic_ns
from os import environ


class Play:
    WORLD_WIDTH = 150
    WORLD_HEIGHT = 40

    @classmethod
    def run(cls):
        world = World(
            Play.WORLD_WIDTH,
            Play.WORLD_HEIGHT,
        )

        minimal = environ.get("MINIMAL") != None

        if not minimal:
            print(world.render())

        total_tick = 0
        lowest_tick = float("inf")
        total_render = 0
        lowest_render = float("inf")

        while True:
            tick_start = monotonic_ns()
            world._tick()
            tick_finish = monotonic_ns()
            tick_time = tick_finish - tick_start
            total_tick += tick_time
            lowest_tick = min(lowest_tick, tick_time)
            avg_tick = total_tick / world.tick

            render_start = monotonic_ns()
            rendered = world.render()
            render_finish = monotonic_ns()
            render_time = render_finish - render_start
            total_render += render_time
            lowest_render = min(lowest_render, render_time)
            avg_render = total_render / world.tick

            if not minimal:
                print("\u001b[H\u001b[2J")

            print(
                "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)"
                % (
                    world.tick,
                    cls._f(lowest_tick),
                    cls._f(avg_tick),
                    cls._f(lowest_render),
                    cls._f(avg_render),
                )
            )

            if not minimal:
                print(rendered)

    @classmethod
    def _f(cls, value):
        return value / 1_000_000


Play.run()
