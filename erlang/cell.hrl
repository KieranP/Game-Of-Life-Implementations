-record(cell, {
  x :: integer(),
  y :: integer(),
  alive :: boolean(),
  neighbours = [] :: [string()]
}).
-type cell() :: #cell{}.
