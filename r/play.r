source("world.r")

Play <- list(
  WORLD_WIDTH = 150,
  WORLD_HEIGHT = 40,

  run = function() {
    world <- World(
      width = Play$WORLD_WIDTH,
      height = Play$WORLD_HEIGHT
    )

    minimal <- !is.na(Sys.getenv("MINIMAL", unset = NA))

    if (!minimal) {
      cat(world$render())
    }

    total_tick <- 0
    lowest_tick <- Inf
    total_render <- 0
    lowest_render <- Inf

    repeat {
      tick_start <- Sys.time()
      world$dotick()
      tick_finish <- Sys.time()
      tick_time <- as.numeric(tick_finish - tick_start, units = "secs")
      total_tick <- total_tick + tick_time
      lowest_tick <- min(lowest_tick, tick_time)
      avg_tick <- (total_tick / world$tick)

      render_start <- Sys.time()
      rendered <- world$render()
      render_finish <- Sys.time()
      render_time <- as.numeric(render_finish - render_start, units = "secs")
      total_render <- total_render + render_time
      lowest_render <- min(lowest_render, render_time)
      avg_render <- (total_render / world$tick)

      if (!minimal) {
        cat("\033[H\033[2J")
      }

      cat(sprintf(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
        world$tick,
        Play$f(lowest_tick),
        Play$f(avg_tick),
        Play$f(lowest_render),
        Play$f(avg_render)
      ))

      if (!minimal) {
        cat(rendered)
      }
    }
  },

  f = function(value) {
    # seconds -> milliseconds
    value * 1000
  }
)

Play$run()
