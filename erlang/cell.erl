-module(cell).
-include("cell.hrl").

-export([new/2, new/3, to_char/1, alive_neighbours/2]).
-export_type([cell/0]).

-spec new(integer(), integer()) -> cell().
new(X, Y) ->
  new(X, Y, false).

-spec new(integer(), integer(), boolean()) -> cell().
new(X, Y, Alive) ->
  #cell{
    x = X,
    y = Y,
    alive = Alive
  }.

-spec to_char(cell()) -> char().
to_char(#cell{alive = true}) -> $o;
to_char(#cell{alive = false}) -> $\s.

-spec alive_neighbours(cell(), world:world()) -> integer().
alive_neighbours(Cell, World) ->
  Neighbours = maps:with(Cell#cell.neighbours, world:cells(World)),

  %% The following is slower
  %% maps:fold(
  %%   fun(_Key, Neighbour, Count) ->
  %%     case Neighbour#cell.alive of
  %%       true -> Count + 1;
  %%       false -> Count
  %%     end
  %%   end,
  %%   0,
  %%   Neighbours
  %% ).

  %% The following is the fastest
  length([Neighbour || Neighbour <- maps:values(Neighbours), Neighbour#cell.alive]).
