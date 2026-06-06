-module(play_ffi).
-export([is_env_set/1, monotonic_time/0]).

is_env_set(Name) ->
  case os:getenv(binary_to_list(Name)) of
    false -> false;
    _ -> true
  end.

monotonic_time() ->
  erlang:monotonic_time(nanosecond).
