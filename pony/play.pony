use "random"
use "time"
use "format"

actor Main
  let _env: Env
  let world: World
  var minimal: Bool = false
  var _total_tick: U64 = 0
  var _lowest_tick: U64 = U64.max_value()
  var _total_render: U64 = 0
  var _lowest_render: U64 = U64.max_value()

  new create(env: Env) =>
    _env = env

    world = World(
      where
      width' = 150,
      height' = 40
    )

    for env_var in env.vars.values() do
      try
        if env_var.find("MINIMAL=")? == 0 then
          minimal = true
          break
        end
      end
    end

    tick()

  be tick() =>
    let tick_start = Time.nanos()
    world.do_tick()
    let tick_finish = Time.nanos()
    let tick_time = (tick_finish - tick_start)
    _total_tick = _total_tick + tick_time
    if tick_time < _lowest_tick then
      _lowest_tick = tick_time
    end
    let avg_tick = (_total_tick / world.tick)

    let render_start = Time.nanos()
    let rendered = world.render()
    let render_finish = Time.nanos()
    let render_time = (render_finish - render_start)
    _total_render = _total_render + render_time
    if render_time < _lowest_render then
      _lowest_render = render_time
    end
    let avg_render = (_total_render / world.tick)

    if not minimal then
      _env.out.write("\u001b[H\u001b[2J")
    end
    // Pony does not have native string formatting (i.e. printf),
    // so falling back to string concatenation
    _env.out.write(
      "#" + world.tick.string() +
      " - World Tick (L: " + _f(_lowest_tick) + "; A: " + _f(avg_tick) + ")" +
      " - Rendering (L: " + _f(_lowest_render) + "; A: " + _f(avg_render) + ")" +
      "\n"
    )
    if not minimal then
      _env.out.write("" + rendered)
    end

    tick()

  fun _f(value: U64): String =>
    // value is in nanoseconds, convert to milliseconds
    Format.float[F64](
      (value.f64() / 1_000_000.0) where prec = 3
    )
