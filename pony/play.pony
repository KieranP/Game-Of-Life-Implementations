use "random"
use "time"
use "format"

actor Main
  let _env: Env
  let world: World
  var _total_tick: U64 = 0
  var _total_render: U64 = 0

  // Pony is actor/thread based. Limiting threads to 1 and disabling
  // blocking helps decrease the times between tick operations. This
  // works because we only need 1 blocking thread. Other applications
  // requiring parallel threads would not do this
  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponynoblock = true
    rto.ponymaxthreads = 1

  new create(env: Env) =>
    _env = env

    world = World(
      where
      width' = 150,
      height' = 40
    )

    tick()

  be tick() =>
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

    tick()

  fun _f(value: U64): String =>
    // value is in nanoseconds, convert to milliseconds
    Format.float[F64](
      (value.f64() / 1_000_000) where prec = 3
    ).string()
