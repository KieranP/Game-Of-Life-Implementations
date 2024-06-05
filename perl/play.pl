use v5.36;
use strict;
use warnings;

use lib './';
use world;
use Time::HiRes qw(clock_gettime CLOCK_MONOTONIC);
use List::Util qw(min);

use constant World_Width => 150;
use constant World_Height => 40;

sub run {
  my $world = World->new({
    width => World_Width,
    height => World_Height,
  });

  my $minimal = $ENV{MINIMAL} != "";

  if (!$minimal) {
    print $world->render();
  }

  my $total_tick = 0;
  my $lowest_tick = 9**9**9;
  my $total_render = 0;
  my $lowest_render = 9**9**9;

  while (1) {
    my $tick_start = clock_gettime(CLOCK_MONOTONIC);
    $world->tick();
    my $tick_finish = clock_gettime(CLOCK_MONOTONIC);
    my $tick_time = ($tick_finish - $tick_start);
    $total_tick += $tick_time;
    $lowest_tick = min($lowest_tick, $tick_time);
    my $avg_tick = $total_tick / $world->{tick};

    my $render_start = clock_gettime(CLOCK_MONOTONIC);
    my $rendered = $world->render();
    my $render_finish = clock_gettime(CLOCK_MONOTONIC);
    my $render_time = ($render_finish - $render_start);
    $total_render += $render_time;
    $lowest_render = min($lowest_render, $render_time);
    my $avg_render = $total_render / $world->{tick};

    if (!$minimal) {
      print "\033[0;0H\033[2J";
    }
    print sprintf(
      "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
      $world->{tick},
      _f($lowest_tick),
      _f($avg_tick),
      _f($lowest_render),
      _f($avg_render)
    );
    if (!$minimal) {
      print $rendered;
    }
  }
}

sub _f($value) {
  # value is in seconds, convert to milliseconds
  $value * 1_000;
}

run();
