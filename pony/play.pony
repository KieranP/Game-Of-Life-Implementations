use "random"
use "time"

class Play is TimerNotify
  let _env: Env
  var world: World
  var _total_tick: U64 = 0
  var _total_render: U64 = 0

  new iso create(env: Env) =>
    _env = env

    world = World(
      where
      width' = 150,
      height' = 40
    )

  fun ref apply(timer: Timer, count: U64): Bool =>
    let tick_start = Time.nanos()
    world.do_tick()
    let tick_finish = Time.nanos()
    let tick_time = (tick_finish - tick_start)
    _total_tick = _total_tick + tick_time
    let avg_tick = (_total_tick / world.tick)

    let render_start = Time.nanos()
    let rendered = world.render()
    let render_finish = Time.nanos()
    let render_time = (render_finish - render_start)
    _total_render = _total_render + render_time
    let avg_render = (_total_render / world.tick)

    let output: String =
      "#" + world.tick.string() +
      " - World tick took " + _f(tick_time) + " (" + _f(avg_tick) + ")" +
      " - Rendering took " + _f(render_time) + " (" + _f(avg_render) + ")" +
      "\n" + rendered

    _env.out.print("\u001b[H\u001b[2J")
    _env.out.print(output)

    true

  fun _f(value: U64): String =>
    // value is in nanoseconds, convert to milliseconds
    (value.f64() / 1_000_000).string()

actor Main
  new create(env: Env) =>
    let timers = Timers
    let timer = Timer(Play(env), 0, 1)
    timers(consume timer)
