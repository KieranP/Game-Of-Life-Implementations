dofile('world.lua')

Play = {
  WORLD_WIDTH = 150,
  WORLD_HEIGHT = 40,
}

function Play:run()
  world = World:new(
    self.WORLD_WIDTH,
    self.WORLD_HEIGHT
  )

  minimal = os.getenv("MINIMAL") ~= nil

  if not minimal then
    print(world:render())
  end

  total_tick = 0
  lowest_tick = math.huge
  total_render = 0
  lowest_render = math.huge

  while true do
    tick_start = os.clock()
    world:_tick()
    tick_finish = os.clock()
    tick_time = (tick_finish - tick_start)
    total_tick = (total_tick + tick_time)
    lowest_tick = math.min(lowest_tick, tick_time)
    avg_tick = (total_tick / world.tick)

    render_start = os.clock()
    rendered = world:render()
    render_finish = os.clock()
    render_time = (render_finish - render_start)
    total_render = (total_render + render_time)
    lowest_render = math.min(lowest_render, render_time)
    avg_render = (total_render / world.tick)

    if not minimal then
      print("\u{001b}[H\u{001b}[2J")
    end

    print(
      string.format(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
        world.tick,
        self:_f(lowest_tick),
        self:_f(avg_tick),
        self:_f(lowest_render),
        self:_f(avg_render)
      )
    )

    if not minimal then
      print(rendered)
    end
  end
end

function Play:_f(value)
  -- seconds -> milliseconds
  return value * 1000
end

Play:run()
