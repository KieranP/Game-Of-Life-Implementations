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
    neighbours => undef
  };

  bless $self, $class;

  return $self;
}

sub to_char($self) {
  $self->{alive} ? 'o' : ' '
}

1;
