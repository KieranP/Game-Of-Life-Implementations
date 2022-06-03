use strict;
use warnings;

package Cell;

sub new {
  my ($class, $x, $y, $alive) = @_;

  my $self = {
    x => $x,
    y => $y,
    alive => $alive || 0,
    next_state => undef,
    neighbours => undef
  };

  bless $self, $class;

  return $self;
}

sub to_char {
  my $self = shift;
  $self->{alive} ? 'o' : ' '
}

1;
