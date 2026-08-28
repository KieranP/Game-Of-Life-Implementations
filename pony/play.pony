use "time"
use "format"

actor Main
  let _env: Env
  let world: World
  var minimal: Bool = false

  let world_width: U32 = 150
  let world_height: U32 = 40
  let clear_screen: String = "\x1b[?2026h\x1b[H\x1b[2J"
  let show_screen: String = "\x1b[?2026l"

  var _total_tick: F64 = 0
  var _lowest_tick: F64 = F64.max_value()
  var _total_render: F64 = 0
  var _lowest_render: F64 = F64.max_value()

  new create(env: Env) =>
    _env = env

    world = World(
      where
      width = world_width,
      height = world_height
    )

    for env_var in env.vars.values() do
      if env_var.at("MINIMAL=") then
        minimal = true
        break
      end
    end

    tick()

  be tick() =>
    let tick_start = Time.nanos()
    world.dotick()
    let tick_finish = Time.nanos()
    let tick_time = (tick_finish - tick_start).f64()
    _total_tick = _total_tick + tick_time
    if tick_time < _lowest_tick then
      _lowest_tick = tick_time
    end
    let avg_tick = (_total_tick / world.tick.f64())

    let render_start = Time.nanos()
    let rendered = world.render()
    let render_finish = Time.nanos()
    let render_time = (render_finish - render_start).f64()
    _total_render = _total_render + render_time
    if render_time < _lowest_render then
      _lowest_render = render_time
    end
    let avg_render = (_total_render / world.tick.f64())

    if not minimal then
      _env.out.write(clear_screen)
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
      _env.out.write(rendered.clone() + show_screen)
    end

    tick()

  fun _f(value: F64): String =>
    // nanoseconds -> milliseconds, padded to 3 decimal places
    Format.float[F64](
      (value / 1_000_000.0) where fmt = FormatFix, prec = 3
    )
