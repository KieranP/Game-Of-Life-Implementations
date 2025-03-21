use v5.40;
use strict;
use warnings;
use builtin qw(false);

use lib './';
use cell;

package World;

my $LocationOccupied = "LocationOccupied";

sub new($class, $args) {
  my $self = {
    width => $args->{width},
    height => $args->{height},
    tick => 0,
    cells => {},
    cached_directions => [
      [-1, 1],  [0, 1],  [1, 1], # above
      [-1, 0],           [1, 0], # sides
      [-1, -1], [0, -1], [1, -1] # below
    ]
  };

  bless $self, $class;

  $self->populate_cells();
  $self->prepopulate_neighbours();

  return $self;
}

sub tick($self) {
  # First determine the next state for all cells
  foreach my $cell (values %{$self->{cells}}) {
    my $alive_neighbours = $self->alive_neighbours_around($cell);
    if (!$cell->{alive} && $alive_neighbours == 3) {
      $cell->{next_state} = 1;
    } elsif ($alive_neighbours < 2 || $alive_neighbours > 3) {
      $cell->{next_state} = 0;
    } else {
      $cell->{next_state} = $cell->{alive};
    }
  }

  # Then execute the determined action for all cells
  foreach my $cell (values %{$self->{cells}}) {
    $cell->{alive} = $cell->{next_state};
  }

  $self->{tick} += 1;
}

# Implement first using string concatenation. Then implement any
# special string builders, and use whatever runs the fastest
sub render($self) {
  # The following was the fastest method
  my $rendering = "";
  for my $y ((0..$self->{height}-1)) {
    for my $x ((0..$self->{width}-1)) {
      my $cell = $self->cell_at($x, $y);
      $rendering .= $cell->to_char();
    }
    $rendering .= "\n";
  }
  $rendering;

  # The following works but is slower
  # my @rendering = ();
  # for my $y ((0..$self->{height}-1)) {
  #   for my $x ((0..$self->{width}-1)) {
  #     my $cell = $self->cell_at($x, $y);
  #     push(@rendering, $cell->to_char());
  #   }
  #   push(@rendering, "\n");
  # }
  # join("", @rendering);
}

sub populate_cells($self) {
  for my $y ((0..$self->{height}-1)) {
    for my $x ((0..$self->{width}-1)) {
      my $alive = rand() <= 0.2;
      $self->add_cell($x, $y, $alive);
    }
  }
}

sub prepopulate_neighbours($self) {
  foreach my $cell (values %{$self->{cells}}) {
    $self->neighbours_around($cell);
  }
}

sub add_cell($self, $x, $y, $alive = false) {
  if ($self->cell_at($x, $y)) {
    die $LocationOccupied;
  }

  my $cell = Cell->new($x, $y, $alive);
  $self->{cells}{"$x-$y"} = $cell;
  $self->cell_at($x, $y);
}

sub cell_at($self, $x, $y) {
  $self->{cells}{"$x-$y"};
}

sub neighbours_around($self, $cell) {
  if (!defined($cell->{neighbours})) {
    $cell->{neighbours} = [];
    foreach my $set (@{$self->{cached_directions}}) {
      my $neighbour = $self->cell_at(
        ($cell->{x} + @$set[0]),
        ($cell->{y} + @$set[1])
      );

      if ($neighbour) {
        push(@{$cell->{neighbours}}, $neighbour);
      }
    }
  }

  $cell->{neighbours};
}

# Implement first using filter/lambda if available. Then implement
# foreach. Use whatever implementation runs the fastest
sub alive_neighbours_around($self, $cell) {
  my $neighbours = $self->neighbours_around($cell);

  # The following was the fastest method
  grep { $_->{alive} } @$neighbours;

  # The following also works but is slower
  # my $alive_neighbours = 0;
  # foreach my $neighbour (@$neighbours) {
  #   if ($neighbour->{alive}) {
  #     $alive_neighbours += 1;
  #   }
  # }
  # $alive_neighbours;

  # The following also works but is slower
  # my $alive_neighbours = 0;
  # for (my $i = 0; $i < @$neighbours; $i++) {
  #   my $neighbour = @$neighbours[$i];
  #   if ($neighbour->{alive}) {
  #     $alive_neighbours += 1;
  #   }
  # }
  # $alive_neighbours;
}

1;
