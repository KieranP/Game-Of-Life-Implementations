import std/[envvars, monotimes, times]
import strutils
from strformat import fmt
include world

const WORLD_WIDTH = 150
const WORLD_HEIGHT = 40

type
  Play = ref object

# By default, Nim requires methods be declared before they are used elsewhere
# and will error out if I dont. To to order the methods as I like, I need to
# declare them ahead of time, known as "forward declaration".
proc run(self: Play)
proc f(self: Play, value: float): float

proc run(self: Play) =
  let world = World(
    width: WORLD_WIDTH,
    height: WORLD_HEIGHT,
  ).initialize()

  let minimal = getEnv("MINIMAL") != ""

  if not minimal:
    echo world.render()

  var total_tick = 0.0
  var lowest_tick = high(float)
  var total_render = 0.0
  var lowest_render = high(float)

  while true:
    let tick_start = getMonoTime()
    world.dotick()
    let tick_finish = getMonoTime()
    let tick_time = (tick_finish - tick_start).inNanoseconds.float
    total_tick += tick_time
    lowest_tick = min(lowest_tick, tick_time)
    let avg_tick = (total_tick / world.tick.float)

    let render_start = getMonoTime()
    let rendered = world.render()
    let render_finish = getMonoTime()
    let render_time = (render_finish - render_start).inNanoseconds.float
    total_render += render_time
    lowest_render = min(lowest_render, render_time)
    let avg_render = (total_render / world.tick.float)

    if not minimal:
      echo "\u001b[H\u001b[2J"

    echo fmt"""
      #{world.tick} -
      World Tick (L: {self.f(lowest_tick):.3f}; A: {self.f(avg_tick):.3f}) -
      Rendering (L: {self.f(lowest_render):.3f}; A: {self.f(avg_render):.3f})
    """.dedent().replace("\n", " ")

    if not minimal:
      echo rendered

proc f(self: Play, value: float): float =
  # nanoseconds -> milliseconds
  value / 1_000_000

Play().run()
