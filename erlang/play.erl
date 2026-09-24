#!/usr/bin/env escript
%% -*- erlang -*-

-define(WORLD_WIDTH, 150).
-define(WORLD_HEIGHT, 40).

-define(CLEAR_SCREEN, "\x1b[?2026h\x1b[H\x1b[2J").
-define(SHOW_SCREEN, "\x1b[?2026l").

main(_) ->
  World = world:new(?WORLD_WIDTH, ?WORLD_HEIGHT),

  Minimal = os:getenv("MINIMAL") =:= "1",

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
    false -> io:format(?CLEAR_SCREEN);
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
    false -> io:format("~s" ?SHOW_SCREEN "~n", [Rendered]);
    true -> ok
  end,

  loop(NewWorld, Minimal, NewTotalTick, NewLowestTick, NewTotalRender, NewLowestRender).

'_f'(Value) ->
  %% microseconds -> milliseconds
  Value / 1000.
