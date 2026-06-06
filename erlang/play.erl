#!/usr/bin/env escript
%% -*- erlang -*-

-define(WORLD_WIDTH, 150).
-define(WORLD_HEIGHT, 40).

main(_) ->
  World = world:new(?WORLD_WIDTH, ?WORLD_HEIGHT),

  Minimal = os:getenv("MINIMAL") /= false,

  case Minimal of
    false -> io:format("~s~n", [world:render(World)]);
    true -> ok
  end,

  loop(World, Minimal, 0, infinity, 0, infinity).

loop(World, Minimal, TotalTick, LowestTick, TotalRender, LowestRender) ->
  {TickTime, NewWorld} = timer:tc(world, dotick, [World]),
  NewTotalTick = TotalTick + TickTime,
  NewLowestTick = min(LowestTick, TickTime),
  AvgTick = NewTotalTick / world:tick(NewWorld),

  {RenderTime, Rendered} = timer:tc(world, render, [NewWorld]),
  NewTotalRender = TotalRender + RenderTime,
  NewLowestRender = min(LowestRender, RenderTime),
  AvgRender = NewTotalRender / world:tick(NewWorld),

  case Minimal of
    false -> io:format("\e[H\e[2J~n");
    true -> ok
  end,

  io:format(
    "#~B - World Tick (L: ~.3f; A: ~.3f) - Rendering (L: ~.3f; A: ~.3f)~n",
    [
      world:tick(NewWorld),
      '_f'(NewLowestTick),
      '_f'(AvgTick),
      '_f'(NewLowestRender),
      '_f'(AvgRender)
    ]
  ),

  case Minimal of
    false -> io:format("~s~n", [Rendered]);
    true -> ok
  end,

  loop(NewWorld, Minimal, NewTotalTick, NewLowestTick, NewTotalRender, NewLowestRender).

'_f'(Value) ->
  %% microseconds -> milliseconds
  Value / 1000.
