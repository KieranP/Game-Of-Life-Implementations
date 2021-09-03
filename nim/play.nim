import std/[times, strutils], world

const
  world_Width  = 150
  world_Height = 40

template f(value: float): string =
  formatFloat value, ffDecimal, 3

proc run() =
  var world = initWorld(
    width  = world_Width,
    height = world_Height,
  )

  echo world.render()

  var total_tick, total_render: float

  while true:
    let tick_start = epochTime()
    world.tick()
    let tick_finish = epochTime()
    let tick_time = (tick_finish - tick_start) * 1_000
    total_tick += tick_time
    let avg_tick = (total_tick / world.tick_num.float)

    let
      render_start = epochTime()
      rendered = world.render()
      render_finish = epochTime()
      render_time = (render_finish - render_start) * 1_000
    total_render += render_time
    let avg_render = (total_render / world.tick_num.float)

    var output = "#"
    output.addInt world.tick_num
    output.add " - World tick took "
    output.add f tick_time
    output.add " ("
    output.add f avg_tick
    output.add ") - Rendering took "
    output.add f render_time
    output.add " ("
    output.add f avg_render
    output.add ")\n"
    output.add rendered
    echo "\u001b[H\u001b[2J\n", output


when isMainModule:
  run()
