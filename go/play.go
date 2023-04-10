package main

import (
  "fmt"
  "math/rand"
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
    tick_time := tick_finish.Sub(tick_start).Nanoseconds()
    total_tick += tick_time
    avg_tick := total_tick / world.tick

    render_start := time.Now()
    rendered := world.render()
    render_finish := time.Now()
    render_time := render_finish.Sub(render_start).Nanoseconds()
    total_render += render_time
    avg_render := total_render / world.tick

    fmt.Print("\u001b[H\u001b[2J")
    // value is in nanoseconds, convert to milliseconds
    fmt.Printf("#%d - World tick took %.3f (%.3f) - Rendering took %.3f (%.3f)\n",
      world.tick,
      float64(tick_time) / 1000000,
      float64(avg_tick) / 1000000,
      float64(render_time) / 1000000,
      float64(avg_render) / 1000000,
    )
    fmt.Println(rendered)
  }

}

func main() {
  // Initialize the random seed generator
  rand.Seed(time.Now().UnixNano())

  run()
}
