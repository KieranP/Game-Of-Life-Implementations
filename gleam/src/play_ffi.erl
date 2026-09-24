-module(play_ffi).
-export([get_env/1, monotonic_time/0]).

get_env(Name) ->
  unicode:characters_to_binary(os:getenv(binary_to_list(Name), "")).

monotonic_time() ->
  erlang:monotonic_time(nanosecond).
