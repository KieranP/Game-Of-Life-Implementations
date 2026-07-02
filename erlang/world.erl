-module(world).
-include("cell.hrl").

-export([new/2, dotick/1, render/1, cells/1, tick/1]).
-export_type([world/0]).

-record(world, {
  width :: integer(),
  height :: integer(),
  tick = 0 :: integer(),
  cells = #{} :: #{string() => cell()}
}).
-type world() :: #world{}.

-define(DIRECTIONS, [
  {-1, 1},  {0, 1},  {1, 1}, % above
  {-1, 0},           {1, 0}, % sides
  {-1, -1}, {0, -1}, {1, -1} % below
]).

-spec new(integer(), integer()) -> world().
new(Width, Height) ->
  World = #world{
    width = Width,
    height = Height
  },

  Populated = populate_cells(World),
  prepopulate_neighbours(Populated).

-spec dotick(world()) -> world().
dotick(World) ->
  Cells = maps:map(
    fun(_Key, Cell) ->
      AliveNeighbours = cell:alive_neighbours(Cell, World),
      if
        not Cell#cell.alive andalso AliveNeighbours =:= 3 ->
          Cell#cell{alive = true};
        AliveNeighbours < 2 orelse AliveNeighbours > 3 ->
          Cell#cell{alive = false};
        true ->
          Cell
      end
    end,
    World#world.cells
  ),

  World#world{tick = World#world.tick + 1, cells = Cells}.

-spec render(world()) -> string().
render(World) ->
  %% The following is the fastest
  lists:flatten([
    begin
      Line = [
        begin
          Cell = cell_at(World, X, Y),
          cell:to_char(Cell)
        end
        || X <- lists:seq(0, World#world.width - 1)
      ],
      Line ++ "\n"
    end
    || Y <- lists:seq(0, World#world.height - 1)
  ]).

  %% The following is slower
  %% lists:foldl(
  %%   fun(Y, Rendering) ->
  %%     Line = lists:foldl(
  %%       fun(X, LineAcc) ->
  %%         Cell = cell_at(World, X, Y),
  %%         LineAcc ++ [cell:to_char(Cell)]
  %%       end,
  %%       [],
  %%       lists:seq(0, World#world.width - 1)
  %%     ),
  %%     Rendering ++ Line ++ "\n"
  %%   end,
  %%   [],
  %%   lists:seq(0, World#world.height - 1)
  %% ).

-spec cells(world()) -> #{string() => cell()}.
cells(#world{cells = Cells}) -> Cells.

-spec tick(world()) -> integer().
tick(#world{tick = Tick}) -> Tick.

-spec make_key(integer(), integer()) -> string().
make_key(X, Y) ->
  %% The following is the fastest
  integer_to_list(X) ++ "-" ++ integer_to_list(Y).

  %% The following is slower
  %% lists:concat([X, "-", Y]).

  %% The following is slower
  %% lists:flatten(io_lib:format("~B-~B", [X, Y])).

-spec cell_at(world(), integer(), integer()) -> cell() | undefined.
cell_at(World, X, Y) ->
  Key = make_key(X, Y),
  maps:get(Key, World#world.cells, undefined).

-spec populate_cells(world()) -> world().
populate_cells(World) ->
  lists:foldl(
    fun(Y, YWorld) ->
      lists:foldl(
        fun(X, XWorld) ->
          Alive = (rand:uniform() =< 0.2),
          {NewWorld, _Success} = add_cell(XWorld, X, Y, Alive),
          NewWorld
        end,
        YWorld,
        lists:seq(0, World#world.width - 1)
      )
    end,
    World,
    lists:seq(0, World#world.height - 1)
  ).

-spec add_cell(world(), integer(), integer(), boolean()) -> {world(), boolean()}.
add_cell(World, X, Y, Alive) ->
  Existing = cell_at(World, X, Y),
  case Existing of
    undefined -> ok;
    _ -> erlang:error({location_occupied, X, Y})
  end,

  Key = make_key(X, Y),
  Cell = cell:new(X, Y, Alive),
  NewWorld = World#world{cells = maps:put(Key, Cell, World#world.cells)},
  {NewWorld, true}.

-spec prepopulate_neighbours(world()) -> world().
prepopulate_neighbours(World) ->
  Cells = maps:map(
    fun(_Key, Cell) ->
      Neighbours = [
        Key
        || {RelX, RelY} <- ?DIRECTIONS,
           Nx <- [Cell#cell.x + RelX],
           Ny <- [Cell#cell.y + RelY],
           not (Nx < 0 orelse Ny < 0),
           not (Nx >= World#world.width orelse Ny >= World#world.height),
           Key <- [make_key(Nx, Ny)],
           maps:is_key(Key, World#world.cells)
      ],
      Cell#cell{neighbours = Neighbours}
    end,
    World#world.cells
  ),

  World#world{cells = Cells}.
