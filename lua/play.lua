local World = require('world')

local Play = {
  WORLD_WIDTH = 150,
  WORLD_HEIGHT = 40,
}

function Play:run()
  local world = World:new(
    self.WORLD_WIDTH,
    self.WORLD_HEIGHT
  )

  local minimal = os.getenv("MINIMAL") ~= nil

  if not minimal then
    print(world:render())
  end

  local total_tick = 0
  local lowest_tick = math.huge
  local total_render = 0
  local lowest_render = math.huge

  while true do
    local tick_start = os.clock()
    world:dotick()
    local tick_finish = os.clock()
    local tick_time = tick_finish - tick_start
    total_tick = total_tick + tick_time
    lowest_tick = math.min(lowest_tick, tick_time)
    local avg_tick = total_tick / world.tick

    local render_start = os.clock()
    local rendered = world:render()
    local render_finish = os.clock()
    local render_time = render_finish - render_start
    total_render = total_render + render_time
    lowest_render = math.min(lowest_render, render_time)
    local avg_render = total_render / world.tick

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
