exception LocationOccupied of string

let directions = [|
  (-1, 1);  (0, 1);  (1, 1);  (* above *)
  (-1, 0);           (1, 0);  (* sides *)
  (-1, -1); (0, -1); (1, -1); (* below *)
|]

class world ~width ~height =
  object (self)
    val mutable tick : int = 0
    val width : int = width
    val height : int = height
    val mutable cells : (string, Cell.cell) Hashtbl.t = Hashtbl.create 1

    initializer
      cells <- Hashtbl.create (width * height);
      self#populate_cells;
      self#prepopulate_neighbours

    method tick = tick

    method dotick =
      (* First determine the action for all cells *)
      Hashtbl.iter (fun _ cell ->
        let alive_neighbours = cell#alive_neighbours in
        if not cell#alive && alive_neighbours = 3 then
          cell#set_next_state (Some true)
        else if alive_neighbours < 2 || alive_neighbours > 3 then
          cell#set_next_state (Some false)
        else
          cell#set_next_state (Some cell#alive)
      ) cells;

      (* Then execute the determined action for all cells *)
      Hashtbl.iter (fun _ cell ->
        Option.iter cell#set_alive cell#next_state
      ) cells;

      tick <- tick + 1

    method render =
      (* The following is slower *)
      (* let rendering = ref "" in
      for y = 0 to height - 1 do
        for x = 0 to width - 1 do
          let cell = self#cell_at x y in
          (match cell with
           | Some c ->
             rendering := !rendering ^ String.make 1 c#to_char
           | None -> ())
        done;
        rendering := !rendering ^ "\n"
      done;
      !rendering *)

      (* The following is slower *)
      (* let rendering = ref [] in
      for y = 0 to height - 1 do
        for x = 0 to width - 1 do
          let cell = self#cell_at x y in
          (match cell with
           | Some c ->
             rendering := String.make 1 c#to_char :: !rendering
           | None -> ())
        done;
        rendering := "\n" :: !rendering
      done;
      String.concat "" (List.rev !rendering) *)

      (* The following is the fastest *)
      let render_size = width * height + height in
      let rendering = Bytes.create render_size in
      let idx = ref 0 in
      for y = 0 to height - 1 do
        for x = 0 to width - 1 do
          let cell = self#cell_at x y in
          (match cell with
           | Some c ->
             Bytes.set rendering !idx c#to_char;
             incr idx
           | None -> ())
        done;
        Bytes.set rendering !idx '\n';
        incr idx
      done;
      Bytes.to_string rendering

    method private make_key x y =
      (* The following is slower *)
      (* Printf.sprintf "%d-%d" x y *)

      (* The following is slower *)
      (* string_of_int x ^ "-" ^ string_of_int y *)

      (* The following is the fastest *)
      String.concat "-" [string_of_int x; string_of_int y]

    method private cell_at x y =
      let key = self#make_key x y in
      Hashtbl.find_opt cells key

    method private add_cell x y ?(alive=false) () =
      let key = self#make_key x y in
      if Hashtbl.mem cells key then
        raise (LocationOccupied key);

      let cell = new Cell.cell x y ~alive () in
      Hashtbl.add cells key cell;
      true

    method private populate_cells =
      Random.self_init ();
      for y = 0 to height - 1 do
        for x = 0 to width - 1 do
          let alive = Random.int 101 <= 20 in
          ignore (self#add_cell x y ~alive ())
        done
      done

    method private prepopulate_neighbours =
      Hashtbl.iter (fun _ cell ->
        let x = cell#x in
        let y = cell#y in
        let neighbours_list = ref [] in

        Array.iter (fun (rel_x, rel_y) ->
          let nx = x + rel_x in
          let ny = y + rel_y in

          if nx >= 0 && ny >= 0 then
            if nx < width && ny < height then
              Option.iter (fun n -> neighbours_list := n :: !neighbours_list)
                (self#cell_at nx ny)
        ) directions;

        cell#set_neighbours (Array.of_list !neighbours_list)
      ) cells
  end
