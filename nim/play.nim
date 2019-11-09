from times import epochTime
from strutils import intToStr
from osproc import execCmd
from strformat import fmt
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
  let world = World(
    width: World_Width,
    height: World_Height,
  ).initialize()

  echo world.render()

  var total_tick = 0.0
  var total_render = 0.0

  while true:
    let tick_start = epochTime()
    world.tick()
    let tick_finish = epochTime()
    let tick_time = (tick_finish - tick_start) * 1000
    total_tick += tick_time
    let avg_tick = (total_tick / world.tick_num.float)

    let render_start = epochTime()
    let rendered = world.render()
    let render_finish = epochTime()
    let render_time = (render_finish - render_start) * 1000
    total_render += render_time
    let avg_render = (total_render / world.tick_num.float)

    var output = "#" & intToStr(world.tick_num)
    output = output & " - World tick took " & self.f(tick_time) & " (" & self.f(avg_tick) & ")"
    output = output & " - Rendering took " & self.f(render_time) & " (" & self.f(avg_render) & ")"
    output = output & "\n" & rendered
    discard execCmd("clear")
    echo output

proc f(self: Play, value: float): string =
  fmt"{value:.3f}"

Play().run()
