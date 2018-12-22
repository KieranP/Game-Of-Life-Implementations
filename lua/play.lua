dofile('world.lua')

Play = {
  World_Width = 150,
  World_Height = 40,
}

function Play:run()
  world = World:new(
    self.World_Width,
    self.World_Height
  )

  print(world:render())

  total_tick = 0
  total_render = 0

  while true do
    tick_start = os.clock()
    world:_tick()
    tick_finish = os.clock()
    tick_time = (tick_finish - tick_start) * 1000
    total_tick = (total_tick + tick_time)
    avg_tick = (total_tick / world.tick)

    render_start = os.clock()
    rendered = world:render()
    render_finish = os.clock()
    render_time = (render_finish - render_start) * 1000
    total_render = (total_render + render_time)
    avg_render = (total_render / world.tick)

    output = "#"..world.tick
    output = output.." - World tick took "..self:_f(tick_time).." ("..self:_f(avg_tick)..")"
    output = output.." - Rendering took "..self:_f(render_time).." ("..self:_f(avg_render)..")"
    output = output.."\n"..rendered
    os.execute("clear")
    print(output)
  end
end

function Play:_f(value)
  return string.format("%.3f", value)
end

Play:run()
