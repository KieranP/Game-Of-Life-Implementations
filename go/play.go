package main

import (
  "fmt"
  "time"
)

const World_Width = 150
const World_Height = 40

func run() {
  world := newWorld(World_Width, World_Height)

  fmt.Print(world.render())

  var total_tick int64
  var total_render int64

  for true {
    tick_start := time.Now()
    world._tick()
    tick_finish := time.Now()

    tick_time := tick_finish.Sub(tick_start)
    total_tick += tick_time.Nanoseconds()
    avg_tick := float64(total_tick) / float64(world.tick) / 1000000000

    render_start := time.Now()
    rendered := world.render()
    render_finish := time.Now()

    render_time := render_finish.Sub(render_start)
    total_render += render_time.Nanoseconds()
    avg_render := float64(total_render) / float64(world.tick) / 1000000000

    fmt.Print("\033[H\033[2J")
    fmt.Printf("#%d - World tick took %.5f (%.5f) - Rendering took %.5f (%.5f)\n",
      world.tick,
      float64(tick_time.Nanoseconds())/1000000000, avg_tick,
      float64(render_time.Nanoseconds())/1000000000, avg_render,
    )
    fmt.Println(rendered)
  }

}

func main() {
  run()
}
