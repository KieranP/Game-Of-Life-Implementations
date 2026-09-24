module Timestamp = Runtime_events.Timestamp

class play =
  object (self)
    val world_width : int = 150
    val world_height : int = 40
    val clear_screen = "\x1b[?2026h\x1b[H\x1b[2J"
    val show_screen = "\x1b[?2026l"

    method run : unit =
      let world = new World.world
        ~width:world_width
        ~height:world_height
      in

      let minimal = Option.is_some (Sys.getenv_opt "MINIMAL") in

      if not minimal then
        print_endline (world#render);

      let total_tick = ref 0.0 in
      let lowest_tick = ref Float.infinity in
      let total_render = ref 0.0 in
      let lowest_render = ref Float.infinity in

      while true do
        let tick_start = Timestamp.(to_int64 (get_current ())) in
        world#dotick;
        let tick_finish = Timestamp.(to_int64 (get_current ())) in
        let tick_time = Int64.to_float (Int64.sub tick_finish tick_start) in
        total_tick := !total_tick +. tick_time;
        lowest_tick := Float.min !lowest_tick tick_time;
        let avg_tick = !total_tick /. float_of_int world#tick in

        let render_start = Timestamp.(to_int64 (get_current ())) in
        let rendered = world#render in
        let render_finish = Timestamp.(to_int64 (get_current ())) in
        let render_time = Int64.to_float (Int64.sub render_finish render_start) in
        total_render := !total_render +. render_time;
        lowest_render := Float.min !lowest_render render_time;
        let avg_render = !total_render /. float_of_int world#tick in

        if not minimal then
          print_string clear_screen;

        Printf.printf "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n"
          world#tick
          (self#_f !lowest_tick)
          (self#_f avg_tick)
          (self#_f !lowest_render)
          (self#_f avg_render);

        if not minimal then
          print_string (rendered ^ show_screen);

        (* stdout is buffered and the frame ends with SHOW_SCREEN (no trailing newline), so without
           an explicit flush the terminal won't commit the synchronized update until the next tick. *)
        flush stdout
      done

    method private _f value =
      (* nanoseconds -> milliseconds *)
      value /. 1_000_000.0
  end;;

let () =
  let p = new play in
  p#run
