val WorldWidth = 150
val WorldHeight = 40

@main def play(): Unit =
  val world = World(
    width = WorldWidth,
    height = WorldHeight,
  )

  val minimal = sys.env.contains("MINIMAL")

  if !minimal then
    println(world.render)

  var totalTick = 0.0
  var lowestTick = Double.MaxValue
  var totalRender = 0.0
  var lowestRender = Double.MaxValue

  while true do
    val tickStart = System.nanoTime()
    world.doTick
    val tickFinish = System.nanoTime()
    val tickTime = (tickFinish - tickStart).toDouble
    totalTick += tickTime
    lowestTick = math.min(lowestTick, tickTime)
    val avgTick = (totalTick / world.tick)

    val renderStart = System.nanoTime()
    val rendered = world.render
    val renderFinish = System.nanoTime()
    val renderTime = (renderFinish - renderStart).toDouble
    totalRender += renderTime
    lowestRender = math.min(lowestRender, renderTime)
    val avgRender = (totalRender / world.tick)

    if !minimal then
      print("[H[2J")

    println(
      f"#${world.tick}%d" +
      f" - World Tick (L: ${_f(lowestTick)}%.3f; A: ${_f(avgTick)}%.3f)" +
      f" - Rendering (L: ${_f(lowestRender)}%.3f; A: ${_f(avgRender)}%.3f)"
    )

    if !minimal then
      print(rendered)

def _f(value: Double) =
  // nanoseconds -> milliseconds
  value / 1_000_000
