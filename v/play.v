import time

const world_width = 150
const world_height = 40

fn run() {
  mut world := new_world(
    world_width,
    world_height
  )

  println(world.render())

  mut total_tick := i64(0)
  mut total_render := i64(0)

  for {
    tick_start := time.now()
    world.tick()
    tick_finish := time.now()
    tick_time := (tick_finish - tick_start)
    total_tick += tick_time
    avg_tick := (total_tick / world.tick)

    render_start := time.now()
    rendered := world.render()
    render_finish := time.now()
    render_time := (render_finish - render_start)
    total_render += render_time
    avg_render := (total_render / world.tick)

    mut output := '#${world.tick}'
    output += ' - World tick took ${f(tick_time)} (${f(avg_tick)})'
    output += ' - Rendering took ${f(render_time)} (${f(avg_render)})'
    output += '\n${rendered}'
    println('\u001b[H\u001b[2J')
    println(output)
  }
}

fn f(value i64) string {
  r := (f64(value) / 1000000)
  return '${r:.3}'
}

fn main() {
  run()
}
