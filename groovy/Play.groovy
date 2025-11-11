class Play {
  private static int WORLD_WIDTH = 150
  private static int WORLD_HEIGHT = 40

  public static void main(String[] args) {
    run()
  }

  public static void run() {
    def world = new World(
      WORLD_WIDTH,
      WORLD_HEIGHT,
    )

    def minimal = System.getenv("MINIMAL") != null

    if (!minimal) {
      System.out.println(world.render())
    }

    def total_tick = 0.0
    def lowest_tick = Double.MAX_VALUE
    def total_render = 0.0
    def lowest_render = Double.MAX_VALUE

    while (true) {
      def tick_start = System.nanoTime()
      world._tick()
      def tick_finish = System.nanoTime()
      def tick_time = (tick_finish - tick_start) / 1d
      total_tick += tick_time
      lowest_tick = Math.min(lowest_tick, tick_time)
      def avg_tick = (total_tick / world.tick).doubleValue()

      def render_start = System.nanoTime()
      def rendered = world.render()
      def render_finish = System.nanoTime()
      def render_time = (render_finish - render_start) / 1d
      total_render += render_time
      lowest_render = Math.min(lowest_render, render_time)
      def avg_render = (total_render / world.tick).doubleValue()

      if (!minimal) {
        System.out.print("\u001b[H\u001b[2J")
      }

      System.out.println(
        String.format(
          "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
          world.tick,
          _f(lowest_tick),
          _f(avg_tick),
          _f(lowest_render),
          _f(avg_render)
        )
      )

      if (!minimal) {
        System.out.print(rendered)
      }
    }
  }

  private static double _f(double value) {
    // nanoseconds -> milliseconds
    value / 1000000
  }
}
