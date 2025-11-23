class play =
  object (self)
    val world_width : int = 150
    val world_height : int = 40

    method run : unit =
      let world = new World.world
        ~width:world_width
        ~height:world_height
      in

      let minimal = try ignore (Sys.getenv "MINIMAL"); true with Not_found -> false in

      if not minimal then
        print_endline (world#render);

      let total_tick = ref 0.0 in
      let lowest_tick = ref Float.infinity in
      let total_render = ref 0.0 in
      let lowest_render = ref Float.infinity in

      while true do
        let tick_start = Sys.time () in
        world#_tick;
        let tick_finish = Sys.time () in
        let tick_time = tick_finish -. tick_start in
        total_tick := !total_tick +. tick_time;
        lowest_tick := min !lowest_tick tick_time;
        let avg_tick = !total_tick /. float_of_int world#tick in

        let render_start = Sys.time () in
        let rendered = world#render in
        let render_finish = Sys.time () in
        let render_time = render_finish -. render_start in
        total_render := !total_render +. render_time;
        lowest_render := min !lowest_render render_time;
        let avg_render = !total_render /. float_of_int world#tick in

        if not minimal then
          print_string "\027[H\027[2J";

        Printf.printf "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n"
          world#tick
          (self#_f !lowest_tick)
          (self#_f avg_tick)
          (self#_f !lowest_render)
          (self#_f avg_render);

        if not minimal then
          print_string rendered;

        flush stdout
      done

    method private _f value =
      (* seconds -> milliseconds *)
      value *. 1_000.0
  end;;

let () =
  let p = new play in
  p#run
