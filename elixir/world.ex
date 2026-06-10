defmodule World do
  defstruct [
    :width,
    :height,
    tick: 0,
    cells: %{}
  ]

  defmodule LocationOccupied do
    defexception [:x, :y]
    def message(e), do:
      "LocationOccupied(#{e.x}-#{e.y})"
  end

  @directions [
    {-1, 1},  {0, 1},  {1, 1}, # above
    {-1, 0},           {1, 0}, # sides
    {-1, -1}, {0, -1}, {1, -1} # below
  ]

  def new(width: width, height: height) do
    world = %World{
      width: width,
      height: height
    }

    world
    |> populate_cells()
    |> prepopulate_neighbours()
  end

  def tick(world) do
    cells =
      for {key, cell} <- world.cells, into: %{} do
        alive_neighbours = Cell.alive_neighbours(cell, world)

        cond do
          not cell.alive and alive_neighbours == 3 ->
            {key, %{cell | alive: true}}

          alive_neighbours < 2 or alive_neighbours > 3 ->
            {key, %{cell | alive: false}}

          true ->
            {key, cell}
        end
      end

    %{world | tick: world.tick + 1, cells: cells}
  end

  def render(world) do
    # The following is the fastest
    for y <- 0..(world.height - 1), reduce: "" do
      rendering ->
        for x <- 0..(world.width - 1), reduce: rendering do
          rendering ->
            cell = cell_at(world, x, y)
            if cell do
              rendering <> Cell.to_char(cell)
            else
              rendering
            end
        end <> "\n"
    end

    # The following is slower
    # Enum.map(0..(world.height - 1), fn y ->
    #   Enum.map(0..(world.width - 1), fn x ->
    #     cell = cell_at(world, x, y)
    #     if cell do
    #       Cell.to_char(cell)
    #     end
    #   end) ++ ["\n"]
    # end)
    # |> Enum.join()

    # The following is slower
    # Enum.map_join(0..(world.height - 1), fn y ->
    #   Enum.map_join(0..(world.width - 1), fn x ->
    #     cell = cell_at(world, x, y)
    #     if cell do
    #       Cell.to_char(cell)
    #     end
    #   end) <> "\n"
    # end)
  end

  defp make_key(x, y) do
    # The following is slower
    # "#{x}-#{y}"

    # The following is slower
    # "#{x}" <> "-" <> "#{y}"

    # The following is the fastest
    Enum.join([x, y], "-")
  end

  defp cell_at(world, x, y) do
    key = make_key(x, y)
    Map.get(world.cells, key)
  end

  defp populate_cells(world) do
    for y <- 0..(world.height - 1), reduce: world do
      world ->
        for x <- 0..(world.width - 1), reduce: world do
          world ->
            alive = :rand.uniform() <= 0.2
            {world, _success} = add_cell(world, x, y, alive)
            world
        end
    end
  end

  defp add_cell(world, x, y, alive) do
    existing = cell_at(world, x, y)
    if existing do
      raise LocationOccupied, x: x, y: y
    end

    key = make_key(x, y)
    cell = Cell.new(x, y, alive)
    world = put_in(world.cells[key], cell)
    {world, true}
  end

  defp prepopulate_neighbours(world) do
    for {_key, cell} <- world.cells, reduce: world do
      world ->
        neighbours =
          for {rel_x, rel_y} <- @directions do
            make_key(cell.x + rel_x, cell.y + rel_y)
          end

        put_in(world.cells[make_key(cell.x, cell.y)].neighbours, neighbours)
    end
  end
end
