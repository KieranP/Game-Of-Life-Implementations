use v5.40;
use experimental 'class';

class Cell {
  field $x :param :reader;
  field $y :param :reader;
  field $alive :param :reader :writer = false;
  field $next_state :reader :writer;
  field $neighbours :reader = [];

  method add_neighbour($neighbour) {
    push $neighbours->@*, $neighbour;
  }

  method to_char() {
    $alive ? 'o' : ' '
  }

  method alive_neighbours() {
    # The following is the fastest
    return grep { $_->alive } $neighbours->@*;

    # The following is slower
    # my $alive_neighbours = 0;
    # foreach my $neighbour ($neighbours->@*) {
    #   if ($neighbour->alive) {
    #     $alive_neighbours += 1;
    #   }
    # }
    # $alive_neighbours;

    # The following is slower
    # my $alive_neighbours = 0;
    # my $count = $neighbours->@*;
    # for (my $i = 0; $i < $count; $i++) {
    #   my $neighbour = $neighbours->[$i];
    #   if ($neighbour->alive) {
    #     $alive_neighbours += 1;
    #   }
    # }
    # $alive_neighbours;
  }
}

1;
