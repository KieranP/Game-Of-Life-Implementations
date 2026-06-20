Cell <- function(x, y, alive = FALSE) {
  # Force the arguments so they are captured as fields now, rather than as
  # lazy promises that would later all resolve to the loop's final value.
  force(x)
  force(y)
  force(alive)

  next_state <- NA
  neighbours <- list()

  to_char <- function() {
    if (alive) "o" else " "
  }

  alive_neighbours <- function() {
    # The following is slower
    # sum(vapply(neighbours, function(neighbour) neighbour$alive, logical(1)))

    # The following is the fastest
    alive_neighbours <- 0
    for (neighbour in neighbours) {
      if (neighbour$alive) {
        alive_neighbours <- alive_neighbours + 1
      }
    }
    alive_neighbours

    # The following is slower
    # alive_neighbours <- 0
    # count <- length(neighbours)
    # for (i in seq_len(count)) {
    #   neighbour <- neighbours[[i]]
    #   if (neighbour$alive) {
    #     alive_neighbours <- alive_neighbours + 1
    #   }
    # }
    # alive_neighbours
  }

  environment()
}
