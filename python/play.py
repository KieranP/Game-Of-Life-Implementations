from time import time
from os import system
from game import *

World_Width = 150
World_Height = 40

world = World(
  World_Width,
  World_Height
)

print(world.render())

total_tick = 0
total_render = 0

while True:
    tick_start = time()
    world._tick()
    tick_finish = time()
    tick_time = round(tick_finish - tick_start, 5)
    total_tick += tick_time
    avg_tick = round(total_tick / world.tick, 5)

    render_start = time()
    rendered = world.render()
    render_finish = time()
    render_time = round(render_finish - render_start, 5)
    total_render += render_time
    avg_render = round(total_render / world.tick, 5)

    output = "#"+str(world.tick)
    output += " - World tick took "+str(tick_time)+" ("+str(avg_tick)+")"
    output += " - Rendering took "+str(render_time)+" ("+str(avg_render)+")"
    output += "\n"+rendered
    system('clear')
    print(output)
