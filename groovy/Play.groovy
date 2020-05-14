class Play {

  private static int World_Width  = 150
  private static int World_Height = 40

  public static void main(String[] args) {
    run()
  }

  public static void run() {
    def world = new World(
      World_Width,
      World_Height
    )

    System.out.println(world.render())

    def total_tick = 0.0
    def total_render = 0.0

    while (true) {
      def tick_start = System.currentTimeMillis()
      world._tick()
      def tick_finish = System.currentTimeMillis()
      def tick_time = (tick_finish - tick_start) / 1d
      total_tick += tick_time
      def avg_tick = (total_tick / world.tick)

      def render_start = System.currentTimeMillis()
      def rendered = world.render()
      def render_finish = System.currentTimeMillis()
      def render_time = (render_finish - render_start) / 1d
      total_render += render_time
      def avg_render = (total_render / world.tick)

      def output = "#"+world.tick
      output += " - World tick took "+_f(tick_time)+" ("+_f(avg_tick)+")"
      output += " - Rendering took "+_f(render_time)+" ("+_f(avg_render)+")"
      output += "\n"+rendered
      System.out.print("\u001b[H\u001b[2J")
      System.out.println(output)
    }
  }

  private static String _f(double value) {
    String.format("%.3f", value)
  }

}
