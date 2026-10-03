use "time"
use "format"

actor Main
  new create(env: Env) =>
    Play(env).run()

actor Play
  let _world_width: U32 = 150
  let _world_height: U32 = 40
  let _clear_screen: String = "\x1b[?2026h\x1b[H\x1b[2J"
  let _show_screen: String = "\x1b[?2026l"

  let _env: Env
  let _world: World
  var _minimal: Bool = false

  var _total_tick: F64 = 0
  var _lowest_tick: F64 = F64(1) / 0
  var _total_render: F64 = 0
  var _lowest_render: F64 = F64(1) / 0

  new create(env: Env) =>
    _env = env

    _world = World(
      where
      width = _world_width,
      height = _world_height
    )

  be run() =>
    for env_var in _env.vars.values() do
      if env_var == "MINIMAL=1" then
        _minimal = true
        break
      end
    end

    if not _minimal then
      _env.out.print(_world.render().clone())
    end

    _tick()

  be _tick() =>
    let tick_start = Time.nanos()
    _world.dotick()
    let tick_finish = Time.nanos()
    let tick_time = (tick_finish - tick_start).f64()
    _total_tick = _total_tick + tick_time
    if tick_time < _lowest_tick then
      _lowest_tick = tick_time
    end
    let avg_tick = (_total_tick / _world.tick.f64())

    let render_start = Time.nanos()
    let rendered = _world.render()
    let render_finish = Time.nanos()
    let render_time = (render_finish - render_start).f64()
    _total_render = _total_render + render_time
    if render_time < _lowest_render then
      _lowest_render = render_time
    end
    let avg_render = (_total_render / _world.tick.f64())

    if not _minimal then
      _env.out.write(_clear_screen)
    end

    // Pony does not have native string formatting (i.e. printf),
    // so falling back to string concatenation
    _env.out.write(
      "#" + _world.tick.string() +
      " - World Tick (L: " + _f(_lowest_tick) + "; A: " + _f(avg_tick) + ")" +
      " - Rendering (L: " + _f(_lowest_render) + "; A: " + _f(avg_render) + ")" +
      "\n"
    )

    if not _minimal then
      _env.out.print(rendered.clone() + _show_screen)
    end

    _tick()

  fun _f(value: F64): String =>
    // nanoseconds -> milliseconds, padded to 3 decimal places
    Format.float[F64](
      (value / 1_000_000.0) where fmt = FormatFix, prec = 3
    )
