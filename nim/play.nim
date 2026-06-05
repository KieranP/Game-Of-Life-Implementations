import std/[envvars, monotimes, times, strutils, strformat]
include world

const WorldWidth = 150
const WorldHeight = 40

type
  Play = ref object

# By default, Nim requires methods be declared before they are used elsewhere
# and will error out if I dont. To to order the methods as I like, I need to
# declare them ahead of time, known as "forward declaration".
proc run(self: Play)
func f(self: Play, value: float): float

proc run(self: Play) =
  let world = World(
    width: WorldWidth,
    height: WorldHeight,
  ).initialize()

  let minimal = getEnv("MINIMAL") != ""

  if not minimal:
    echo world.render()

  var totalTick = 0.0
  var lowestTick = Inf
  var totalRender = 0.0
  var lowestRender = Inf

  while true:
    let tickStart = getMonoTime()
    world.doTick()
    let tickFinish = getMonoTime()
    let tickTime = (tickFinish - tickStart).inNanoseconds.float
    totalTick += tickTime
    lowestTick = min(lowestTick, tickTime)
    let avgTick = (totalTick / world.tick.float)

    let renderStart = getMonoTime()
    let rendered = world.render()
    let renderFinish = getMonoTime()
    let renderTime = (renderFinish - renderStart).inNanoseconds.float
    totalRender += renderTime
    lowestRender = min(lowestRender, renderTime)
    let avgRender = (totalRender / world.tick.float)

    if not minimal:
      echo "\u001b[H\u001b[2J"

    echo fmt"""
      #{world.tick} -
      World Tick (L: {self.f(lowestTick):.3f}; A: {self.f(avgTick):.3f}) -
      Rendering (L: {self.f(lowestRender):.3f}; A: {self.f(avgRender):.3f})
    """.dedent().replace("\n", " ")

    if not minimal:
      echo rendered

func f(self: Play, value: float): float =
  # nanoseconds -> milliseconds
  value / 1_000_000

Play().run()
