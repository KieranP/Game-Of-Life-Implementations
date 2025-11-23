exception LocationOccupied of string

let directions = [|
  [|-1; 1|];  [|0; 1|];  [|1; 1|];  (* above *)
  [|-1; 0|];             [|1; 0|];  (* sides *)
  [|-1; -1|]; [|0; -1|]; [|1; -1|]; (* below *)
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

    method _tick =
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
        if Option.is_some cell#next_state then
          cell#set_alive (Option.get cell#next_state)
      ) cells;

      tick <- tick + 1

    method render =
      (* The following is slower *)
      (* let rendering = ref "" in
      for y = 0 to height - 1 do
        for x = 0 to width - 1 do
          let cell = self#cell_at x y in
          if Option.is_some cell then
            rendering := !rendering ^ String.make 1 (Option.get cell)#to_char
        done;
        rendering := !rendering ^ "\n"
      done;
      !rendering *)

      (* The following is slower *)
      (* let rendering = ref [] in
      for y = 0 to height - 1 do
        for x = 0 to width - 1 do
          let cell = self#cell_at x y in
          if Option.is_some cell then
            rendering := String.make 1 (Option.get cell)#to_char :: !rendering
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
          if Option.is_some cell then begin
            Bytes.set rendering !idx (Option.get cell)#to_char;
            idx := !idx + 1
          end
        done;
        Bytes.set rendering !idx '\n';
        idx := !idx + 1
      done;
      Bytes.to_string rendering

    method private cell_at x y =
      let key = string_of_int x ^ "-" ^ string_of_int y in
      Hashtbl.find_opt cells key

    method private add_cell x y ?(alive=false) () =
      let existing = self#cell_at x y in
      if Option.is_some existing then
        raise (LocationOccupied (string_of_int x ^ "-" ^ string_of_int y));

      let cell = new Cell.cell x y ~alive () in
      let key = string_of_int x ^ "-" ^ string_of_int y in
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

        Array.iter (fun dir ->
          let nx = x + dir.(0) in
          let ny = y + dir.(1) in

          if nx >= 0 && ny >= 0 then
            if nx < width && ny < height then
              let neighbour = self#cell_at nx ny in
              if Option.is_some neighbour then
                neighbours_list := Option.get neighbour :: !neighbours_list
        ) directions;

        cell#set_neighbours (Array.of_list !neighbours_list)
      ) cells
  end
