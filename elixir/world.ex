defmodule World do
  defmodule LocationOccupied do
    defexception [:message]
  end

  defstruct [
    :width,
    :height,
    tick: 0,
    cells: %{},
    cached_directions: [
      [-1, 1],  [0, 1],  [1, 1], # above
      [-1, 0],           [1, 0], # sides
      [-1, -1], [0, -1], [1, -1] # below
    ]
  ]

  def new(width: width, height: height) do
    world = %World{
      width: width,
      height: height
    }

    world = populate_cells(world)
    world = prepopulate_neighbours(world)
    world
  end

  def tick(world) do
    cells =
      for {key, cell} <- world.cells, into: %{} do
        alive_neighbours = alive_neighbours_around(world, cell)

        cond do
          !cell.alive && alive_neighbours == 3 ->
            {key, %Cell{cell | alive: true}}

          alive_neighbours < 2 || alive_neighbours > 3 ->
            {key, %Cell{cell | alive: false}}

          true ->
            {key, cell}
        end
      end

    %{world | tick: world.tick + 1, cells: cells}
  end

  # Implement first using string concatenation. Then implement any
  # special string builders, and use whatever runs the fastest
  def render(world) do
    # The following was the fastest method
    for y <- 0..(world.height - 1), reduce: "" do
      rendering ->
        for x <- 0..(world.width - 1), reduce: rendering do
          rendering ->
            cell = cell_at(world, x, y)
            rendering <> Cell.to_char(cell)
        end <> "\n"
    end

    # The following works but it slower
    # Enum.map(0..(world.height - 1), fn y ->
    #   Enum.map(0..(world.width - 1), fn x ->
    #     cell = cell_at(world, x, y)
    #     Cell.to_char(cell)
    #   end) ++ ["\n"]
    # end)
    # |> Enum.join()

    # The following works but it slower
    # Enum.map_join(0..(world.height - 1), fn y ->
    #   Enum.map_join(0..(world.width - 1), fn x ->
    #     cell = cell_at(world, x, y)
    #     Cell.to_char(cell)
    #   end) <> "\n"
    # end)
  end

  defp populate_cells(world) do
    for y <- 0..(world.height - 1), reduce: world do
      world ->
        for x <- 0..(world.width - 1), reduce: world do
          world ->
            alive = Enum.random(1..100) <= 20
            {world, _cell} = add_cell(world, x, y, alive)
            world
        end
    end
  end

  defp prepopulate_neighbours(world) do
    for {_key, cell} <- world.cells, reduce: world do
      world ->
        {world, _neighbours} = neighbours_around(world, cell)
        world
    end
  end

  defp add_cell(world, x, y, alive) do
    if cell_at(world, x, y) do
      raise LocationOccupied, message: "LocationOccupied(#{x}-#{y})"
    end

    cell = Cell.new(x, y, alive)
    world = put_in(world.cells["#{x}-#{y}"], cell)
    {world, cell}
  end

  defp cell_at(world, x, y) do
    Map.get(world.cells, "#{x}-#{y}")
  end

  defp neighbours_around(world, cell) do
    if !cell.neighbours do
      neighbours =
        for set <- world.cached_directions, into: [] do
          cell_at(world, cell.x + Enum.at(set, 0), cell.y + Enum.at(set, 1))
        end
        |> Enum.reject(&is_nil/1)

      world = put_in(world.cells["#{cell.x}-#{cell.y}"].neighbours, neighbours)

      {world, neighbours}
    else
      {world, cell.neighbours}
    end
  end

  # Implement first using filter/lambda if available. Then implement
  # foreach and for. Use whatever implementation runs the fastest
  defp alive_neighbours_around(world, cell) do
    {world, neighbours} = neighbours_around(world, cell)

    # The following works but is slower
    # Enum.count(neighbours, fn neighbour ->
    #   neighbour = cell_at(world, neighbour.x, neighbour.y)
    #   neighbour.alive
    # end)

    # The following was the fastest method
    for neighbour <- neighbours, reduce: 0 do
      count ->
        neighbour = cell_at(world, neighbour.x, neighbour.y)

        if neighbour.alive do
          count + 1
        else
          count
        end
    end
  end
end
