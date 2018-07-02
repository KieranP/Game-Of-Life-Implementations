from times import epochTime
from strutils import intToStr
from osproc import execCmd
from strformat import fmt,format
include world

const World_Width  = 150
const World_Height = 40

type
  Play = ref object

# By default, Nim requires methods be declared before they are used elsewhere
# and will error out if I dont. To to order the methods as I like, I need to
# declare them ahead of time, known as "forward declaration".
proc run(self: Play)
proc f(self: Play, value: float): string

proc run(self: Play) =
  var world = World(
    width: World_Width,
    height: World_Height,
  ).initialize()

  echo world.render()

  var total_tick = 0.0
  var total_render = 0.0

  while true:
    var tick_start = epochTime()
    world.tick()
    var tick_finish = epochTime()
    var tick_time = (tick_finish - tick_start)
    total_tick += tick_time
    var avg_tick = (total_tick / world.tick_num.float)

    var render_start = epochTime()
    var rendered = world.render()
    var render_finish = epochTime()
    var render_time = (render_finish - render_start)
    total_render += render_time
    var avg_render = (total_render / world.tick_num.float)

    var output = "#" & intToStr(world.tick_num)
    output = output & " - World tick took " & self.f(tick_time) & " (" & self.f(avg_tick) & ")"
    output = output & " - Rendering took " & self.f(render_time) & " (" & self.f(avg_render) & ")"
    output = output & "\n" & rendered
    discard execCmd("clear")
    echo output

proc f(self: Play, value: float): string =
  fmt"{value:.5f}"

Play().run()
