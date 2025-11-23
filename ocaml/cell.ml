class cell x y ?(alive = false) () =
  object (self)
    val x : int = x
    val y : int = y
    val mutable alive : bool = alive
    val mutable next_state : bool option = None
    val mutable neighbours : cell array = [||]

    method x = x
    method y = y
    method alive = alive
    method set_alive value = alive <- value
    method next_state = next_state
    method set_next_state value = next_state <- value
    method neighbours = neighbours
    method set_neighbours value = neighbours <- value

    method to_char =
      if alive then 'o' else ' '

    method alive_neighbours =
      (* The following is slower *)
      (* Array.fold_left (fun count neighbour -> if neighbour#alive then count + 1 else count) 0 neighbours *)

      (* The following is slower *)
      (* let alive_neighbours = ref 0 in
      Array.iter (fun neighbour ->
        if neighbour#alive then
          alive_neighbours := !alive_neighbours + 1
      ) neighbours;
      !alive_neighbours *)

      (* The following is the fastest *)
      let alive_neighbours = ref 0 in
      let count = Array.length neighbours in
      for i = 0 to count - 1 do
        let neighbour = neighbours.(i) in
        if neighbour#alive then
          alive_neighbours := !alive_neighbours + 1
      done;
      !alive_neighbours
  end
