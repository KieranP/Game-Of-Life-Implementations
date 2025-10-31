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
    [-1, 1],  [0, 1],  [1, 1], # above
    [-1, 0],           [1, 0], # sides
    [-1, -1], [0, -1], [1, -1] # below
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
        alive_neighbours = Cell.alive_neighbours(cell, world)

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

  defp cell_at(world, x, y) do
    Map.get(world.cells, "#{x}-#{y}")
  end

  defp populate_cells(world) do
    for y <- 0..(world.height - 1), reduce: world do
      world ->
        for x <- 0..(world.width - 1), reduce: world do
          world ->
            alive = Enum.random(1..100) <= 20
            {world, _success} = add_cell(world, x, y, alive)
            world
        end
    end
  end

  defp add_cell(world, x, y, alive) do
    if cell_at(world, x, y) do
      raise LocationOccupied, x: x, y: y
    end

    cell = Cell.new(x, y, alive)
    world = put_in(world.cells["#{x}-#{y}"], cell)
    {world, true}
  end

  defp prepopulate_neighbours(world) do
    for {_key, cell} <- world.cells, reduce: world do
      world ->
        neighbours =
          for set <- @directions, into: [] do
            "#{cell.x + Enum.at(set, 0)}-#{cell.y + Enum.at(set, 1)}"
          end

        world = put_in(world.cells["#{cell.x}-#{cell.y}"].neighbours, neighbours)
        world
    end
  end
end
