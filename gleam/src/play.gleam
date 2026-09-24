import gleam/float
import gleam/int
import gleam/io
import gleam/string
import world.{type World}

const world_width = 150
const world_height = 40
const clear_screen = "\u{001b}[?2026h\u{001b}[H\u{001b}[2J"
const show_screen = "\u{001b}[?2026l"

// Gleam has no infinity literal or float max constant
const infinity = 9_999_999_999_999.0

pub fn main() {
  let world = world.new(world_width, world_height)

  let minimal = get_env("MINIMAL") == "1"

  case minimal {
    False -> io.println(world.render(world))
    True -> Nil
  }

  loop(world, minimal, 0.0, infinity, 0.0, infinity)
}

fn loop(
  world: World,
  minimal: Bool,
  total_tick: Float,
  lowest_tick: Float,
  total_render: Float,
  lowest_render: Float,
) -> Nil {
  let tick_start = monotonic_time()
  let world = world.dotick(world)
  let tick_finish = monotonic_time()
  let tick_time = int.to_float(tick_finish - tick_start)
  let total_tick = total_tick +. tick_time
  let lowest_tick = float.min(lowest_tick, tick_time)
  let avg_tick = total_tick /. int.to_float(world.tick)

  let render_start = monotonic_time()
  let rendered = world.render(world)
  let render_finish = monotonic_time()
  let render_time = int.to_float(render_finish - render_start)
  let total_render = total_render +. render_time
  let lowest_render = float.min(lowest_render, render_time)
  let avg_render = total_render /. int.to_float(world.tick)

  case minimal {
    False -> io.print(clear_screen)
    True -> Nil
  }

  io.println(
    "#" <> int.to_string(world.tick)
    <> " - World Tick (L: " <> f(lowest_tick) <> "; A: " <> f(avg_tick) <> ")"
    <> " - Rendering (L: " <> f(lowest_render) <> "; A: " <> f(avg_render) <> ")",
  )

  case minimal {
    False -> io.println(rendered <> show_screen)
    True -> Nil
  }

  loop(world, minimal, total_tick, lowest_tick, total_render, lowest_render)
}

fn f(value: Float) -> String {
  // nanoseconds -> milliseconds, padded to 3 decimal places
  let assert Ok(#(whole, fraction)) =
    float.to_precision(value /. 1_000_000.0, 3)
    |> float.to_string()
    |> string.split_once(".")

  whole <> "." <> string.pad_end(fraction, to: 3, with: "0")
}

@external(erlang, "play_ffi", "get_env")
fn get_env(name: String) -> String

@external(erlang, "play_ffi", "monotonic_time")
fn monotonic_time() -> Int
