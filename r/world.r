source("cell.r")

DIRECTIONS <- list(
  c(-1, 1),  c(0, 1),  c(1, 1),  # above
  c(-1, 0),            c(1, 0),  # sides
  c(-1, -1), c(0, -1), c(1, -1)  # below
)

location_occupied <- function(x, y) {
  structure(
    class = c("LocationOccupied", "error", "condition"),
    list(message = paste0("LocationOccupied(", x, "-", y, ")"), call = NULL)
  )
}

World <- function(width, height) {
  tick <- 0
  cells <- new.env(hash = TRUE)

  dotick <- function() {
    # First determine the action for all cells
    for (cell in as.list(cells)) {
      alive_neighbours <- cell$alive_neighbours()
      if (!cell$alive && alive_neighbours == 3) {
        cell$next_state <- TRUE
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell$next_state <- FALSE
      } else {
        cell$next_state <- cell$alive
      }
    }

    # Then execute the determined action for all cells
    for (cell in as.list(cells)) {
      cell$alive <- cell$next_state
    }

    tick <<- tick + 1
  }

  render <- function() {
    # The following is slower
    # rendering <- ""
    # for (y in 0:(height - 1)) {
    #   for (x in 0:(width - 1)) {
    #     cell <- cell_at(x, y)
    #     if (!is.null(cell)) {
    #       rendering <- paste0(rendering, cell$to_char())
    #     }
    #   }
    #   rendering <- paste0(rendering, "\n")
    # }
    # rendering

    # The following is slower
    # rendering <- character(0)
    # for (y in 0:(height - 1)) {
    #   for (x in 0:(width - 1)) {
    #     cell <- cell_at(x, y)
    #     if (!is.null(cell)) {
    #       rendering <- c(rendering, cell$to_char())
    #     }
    #   }
    #   rendering <- c(rendering, "\n")
    # }
    # paste(rendering, collapse = "")

    # The following is the fastest
    render_size <- width * height + height
    rendering <- character(render_size)
    idx <- 1
    for (y in 0:(height - 1)) {
      for (x in 0:(width - 1)) {
        cell <- cell_at(x, y)
        if (!is.null(cell)) {
          rendering[idx] <- cell$to_char()
        }
        idx <- idx + 1
      }
      rendering[idx] <- "\n"
      idx <- idx + 1
    }
    paste(rendering, collapse = "")
  }

  make_key <- function(x, y) {
    # The following is the fastest
    sprintf("%d-%d", x, y)

    # The following is slower
    # paste0(x, "-", y)

    # The following is slower
    # paste(c(x, y), collapse = "-")
  }

  cell_at <- function(x, y) {
    key <- make_key(x, y)
    get0(key, envir = cells, inherits = FALSE, ifnotfound = NULL)
  }

  populate_cells <- function() {
    for (y in 0:(height - 1)) {
      for (x in 0:(width - 1)) {
        alive <- (runif(1) <= 0.2)
        add_cell(x, y, alive)
      }
    }
  }

  add_cell <- function(x, y, alive = FALSE) {
    if (!is.null(cell_at(x, y))) {
      stop(location_occupied(x, y))
    }

    key <- make_key(x, y)
    cell <- Cell(x, y, alive)
    assign(key, cell, envir = cells)
    TRUE
  }

  prepopulate_neighbours <- function() {
    for (cell in as.list(cells)) {
      x <- cell$x
      y <- cell$y

      for (direction in DIRECTIONS) {
        rel_x <- direction[1]
        rel_y <- direction[2]
        nx <- x + rel_x
        ny <- y + rel_y

        if (nx < 0 || ny < 0) {
          next  # Out of bounds
        }

        if (nx >= width || ny >= height) {
          next  # Out of bounds
        }

        neighbour <- cell_at(nx, ny)
        if (!is.null(neighbour)) {
          cell$neighbours[[length(cell$neighbours) + 1]] <- neighbour
        }
      }
    }
  }

  populate_cells()
  prepopulate_neighbours()

  environment()
}
