from time import time
from world import *

class Play:

    World_Width = 150
    World_Height = 40

    @classmethod
    def run(cls):
        world = World(
          Play.World_Width,
          Play.World_Height
        )

        print(world.render())

        total_tick = 0
        total_render = 0

        while True:
            tick_start = time()
            world._tick()
            tick_finish = time()
            tick_time = (tick_finish - tick_start)
            total_tick += tick_time
            avg_tick = (total_tick / world.tick)

            render_start = time()
            rendered = world.render()
            render_finish = time()
            render_time = (render_finish - render_start)
            total_render += render_time
            avg_render = (total_render / world.tick)

            output = "#"+str(world.tick)
            output += " - World tick took "+cls._f(tick_time * 1000)+" ("+cls._f(avg_tick * 1000)+")"
            output += " - Rendering took "+cls._f(render_time * 1000)+" ("+cls._f(avg_render * 1000)+")"
            output += "\n"+rendered
            print("\u001b[H\u001b[2J")
            print(output)

    @classmethod
    def _f(cls, value):
        return "%.3f" % value

Play.run()
