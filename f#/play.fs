open World
open System
open System.Diagnostics

type Play =
  static let worldWidth = 150u
  static let worldHeight = 40u

  static member Run() =
    let world = World(
      width = worldWidth,
      height = worldHeight
    )

    world.PopulateCells()
    world.PrepopulateNeighbours()

    let minimal = Environment.GetEnvironmentVariable("MINIMAL") <> null

    if not minimal then
      printfn "%s" (world.Render())

    let mutable totalTick = 0.0
    let mutable lowestTick = infinity
    let mutable totalRender = 0.0
    let mutable lowestRender = infinity

    while true do
      let tickStart = Stopwatch.GetTimestamp()
      world.DoTick()
      let tickFinish = Stopwatch.GetTimestamp()
      let tickTime = Stopwatch.GetElapsedTime(tickStart, tickFinish).TotalNanoseconds
      totalTick <- totalTick + tickTime
      lowestTick <- min lowestTick tickTime
      let avgTick = totalTick / float world.Tick

      let renderStart = Stopwatch.GetTimestamp()
      let rendered = world.Render()
      let renderFinish = Stopwatch.GetTimestamp()
      let renderTime = Stopwatch.GetElapsedTime(renderStart, renderFinish).TotalNanoseconds
      totalRender <- totalRender + renderTime
      lowestRender <- min lowestRender renderTime
      let avgRender = totalRender / float world.Tick

      if not minimal then
        printf "\u001b[H\u001b[2J"

      printfn "#%i - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)"
        world.Tick
        (Play._f lowestTick)
        (Play._f avgTick)
        (Play._f lowestRender)
        (Play._f avgRender)

      if not minimal then
        printfn "%s" rendered

  static member private _f(value) =
    // nanoseconds -> milliseconds
    value / 1_000_000.0

Play.Run()
