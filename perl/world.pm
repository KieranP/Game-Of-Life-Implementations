use v5.40;
use experimental 'class';

use lib './';
use cell;

class World {
  field $width :param;
  field $height :param;
  field $tick :reader = 0;
  field $cells = {};

  my $DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], # above
    [-1, 0],           [1, 0], # sides
    [-1, -1], [0, -1], [1, -1] # below
  ];

  ADJUST {
    $self->populate_cells();
    $self->prepopulate_neighbours();
  }

  method dotick() {
    # First determine the next state for all cells
    foreach my $cell (values $cells->%*) {
      my $alive_neighbours = $cell->alive_neighbours();
      if (!$cell->alive && $alive_neighbours == 3) {
        $cell->set_next_state(1);
      } elsif ($alive_neighbours < 2 || $alive_neighbours > 3) {
        $cell->set_next_state(0);
      } else {
        $cell->set_next_state($cell->alive);
      }
    }

    # Then execute the determined action for all cells
    foreach my $cell (values $cells->%*) {
      $cell->set_alive($cell->next_state);
    }

    $tick += 1;
  }

  method render() {
    # The following is the fastest
    my $rendering = "";
    for my $y ((0..$height-1)) {
      for my $x ((0..$width-1)) {
        my $cell = $self->cell_at($x, $y);
        if ($cell) {
          $rendering .= $cell->to_char();
        }
      }
      $rendering .= "\n";
    }
    $rendering;

    # The following is slower
    # my @rendering = ();
    # for my $y ((0..$height-1)) {
    #   for my $x ((0..$width-1)) {
    #     my $cell = $self->cell_at($x, $y);
    #     if ($cell) {
    #       push(@rendering, $cell->to_char());
    #     }
    #   }
    #   push(@rendering, "\n");
    # }
    # join("", @rendering);
  }

  method make_key($x, $y) {
    # The following is the fastest
    "$x-$y";

    # The following is slower
    # $x . "-" . $y;

    # The following is slower
    # join("-", $x, $y);
  }

  method cell_at($x, $y) {
    my $key = $self->make_key($x, $y);
    $cells->{$key};
  }

  method populate_cells() {
    for my $y ((0..$height-1)) {
      for my $x ((0..$width-1)) {
        my $alive = rand() <= 0.2;
        $self->add_cell($x, $y, $alive);
      }
    }
  }

  method add_cell($x, $y, $alive = false) {
    my $existing = $self->cell_at($x, $y);
    if ($existing) {
      die "LocationOccupied($x-$y)";
    }

    my $key = $self->make_key($x, $y);
    my $cell = Cell->new(x => $x, y => $y, alive => $alive);
    $cells->{$key} = $cell;
    true;
  }

  method prepopulate_neighbours() {
    foreach my $cell (values $cells->%*) {
      my $x = $cell->x;
      my $y = $cell->y;

      foreach my $set ($DIRECTIONS->@*) {
        my ($rel_x, $rel_y) = $set->@*;
        my $nx = $x + $rel_x;
        my $ny = $y + $rel_y;
        if ($nx < 0 || $ny < 0) {
          next; # Out of bounds
        }

        if ($nx >= $width || $ny >= $height) {
          next; # Out of bounds
        }

        my $neighbour = $self->cell_at($nx, $ny);
        if ($neighbour) {
          $cell->add_neighbour($neighbour);
        }
      }
    }
  }
}

1;
