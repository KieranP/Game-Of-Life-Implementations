use v5.40;
use strict;
use warnings;
use builtin qw(false);

package Cell;

sub new($class, $x, $y, $alive = false) {
  my $self = {
    x => $x,
    y => $y,
    alive => $alive,
    next_state => undef,
    neighbours => []
  };

  bless $self, $class;

  return $self;
}

sub to_char($self) {
  $self->{alive} ? 'o' : ' '
}

# Implement first using filter/lambda if available. Then implement
# foreach. Use whatever implementation runs the fastest
sub alive_neighbours($self) {
  # The following was the fastest method
  grep { $_->{alive} } @{$self->{neighbours}};

  # The following also works but is slower
  # my $alive_neighbours = 0;
  # foreach my $neighbour (@{$self->{neighbours}}) {
  #   if ($neighbour->{alive}) {
  #     $alive_neighbours += 1;
  #   }
  # }
  # $alive_neighbours;

  # The following also works but is slower
  # my $alive_neighbours = 0;
  # for (my $i = 0; $i < @{$self->{neighbours}}; $i++) {
  #   my $neighbour = @{$self->{neighbours}}[$i];
  #   if ($neighbour->{alive}) {
  #     $alive_neighbours += 1;
  #   }
  # }
  # $alive_neighbours;
}

1;
