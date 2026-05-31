val WORLD_WIDTH = 150
val WORLD_HEIGHT = 40

@main def play(): Unit =
  val world = World(
    width = WORLD_WIDTH,
    height = WORLD_HEIGHT,
  )

  val minimal = sys.env.contains("MINIMAL")

  if !minimal then
    println(world.render)

  var total_tick = 0.0
  var lowest_tick = Double.MaxValue
  var total_render = 0.0
  var lowest_render = Double.MaxValue

  while true do
    val tick_start = System.nanoTime()
    world.dotick
    val tick_finish = System.nanoTime()
    val tick_time = (tick_finish - tick_start).toDouble
    total_tick += tick_time
    lowest_tick = math.min(lowest_tick, tick_time)
    val avg_tick = (total_tick / world.tick)

    val render_start = System.nanoTime()
    val rendered = world.render
    val render_finish = System.nanoTime()
    val render_time = (render_finish - render_start).toDouble
    total_render += render_time
    lowest_render = math.min(lowest_render, render_time)
    val avg_render = (total_render / world.tick)

    if !minimal then
      print("[H[2J")

    println(
      f"#${world.tick}%d - World Tick (L: ${_f(lowest_tick)}%.3f; A: ${_f(avg_tick)}%.3f) - Rendering (L: ${_f(lowest_render)}%.3f; A: ${_f(avg_render)}%.3f)"
    )

    if !minimal then
      print(rendered)

def _f(value: Double) =
  // nanoseconds -> milliseconds
  value / 1_000_000
