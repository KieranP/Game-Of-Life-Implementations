open World
open System
open System.Diagnostics

type Play =
  static let WORLD_WIDTH = 150u
  static let WORLD_HEIGHT = 40u

  static member run() =
    let world = new World(
      width = WORLD_WIDTH,
      height = WORLD_HEIGHT
    )

    world.populate_cells()
    world.prepopulate_neighbours()

    let minimal = Environment.GetEnvironmentVariable("MINIMAL") <> null

    if not minimal then
      printfn "%s" (world.render())

    let mutable total_tick = 0.0
    let mutable lowest_tick = infinity
    let mutable total_render = 0.0
    let mutable lowest_render = infinity

    while true do
      let tick_start = Stopwatch.GetTimestamp()
      world._tick()
      let tick_finish = Stopwatch.GetTimestamp()
      let tick_time = Stopwatch.GetElapsedTime(tick_start, tick_finish).TotalNanoseconds
      total_tick <- total_tick + tick_time
      lowest_tick <- min lowest_tick tick_time
      let avg_tick = (total_tick / float(world.tick))

      let render_start = Stopwatch.GetTimestamp()
      let rendered = world.render()
      let render_finish = Stopwatch.GetTimestamp()
      let render_time = Stopwatch.GetElapsedTime(render_start, render_finish).TotalNanoseconds
      total_render <- total_render + render_time
      lowest_render <- min lowest_render render_time
      let avg_render = (total_render / float(world.tick))

      if not minimal then
        printf "\u001b[H\u001b[2J"

      printfn "#%i - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)"
        world.tick
        (Play._f(lowest_tick))
        (Play._f(avg_tick))
        (Play._f(lowest_render))
        (Play._f(avg_render))

      if not minimal then
        printfn "%s" rendered

  static member private _f(value) =
    // nanoseconds -> milliseconds
    value / 1_000_000.0

Play.run()
