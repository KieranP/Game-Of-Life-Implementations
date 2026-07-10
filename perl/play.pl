use v5.40;
use experimental 'builtin';

use lib './';
use world;
use Time::HiRes qw(clock_gettime CLOCK_MONOTONIC);
use List::Util qw(min);

use constant WORLD_WIDTH => 150;
use constant WORLD_HEIGHT => 40;
use constant CLEAR_SCREEN => "\x1b[?2026h\x1b[H\x1b[2J";
use constant SHOW_SCREEN => "\x1b[?2026l";

sub run {
  my $world = World->new(
    width => WORLD_WIDTH,
    height => WORLD_HEIGHT,
  );

  my $minimal = length($ENV{MINIMAL} // '');

  if (!$minimal) {
    print $world->render();
  }

  my $total_tick = 0;
  my $lowest_tick = builtin::inf;
  my $total_render = 0;
  my $lowest_render = builtin::inf;

  while (1) {
    my $tick_start = clock_gettime(CLOCK_MONOTONIC);
    $world->dotick();
    my $tick_finish = clock_gettime(CLOCK_MONOTONIC);
    my $tick_time = ($tick_finish - $tick_start);
    $total_tick += $tick_time;
    $lowest_tick = min($lowest_tick, $tick_time);
    my $avg_tick = $total_tick / $world->tick;

    my $render_start = clock_gettime(CLOCK_MONOTONIC);
    my $rendered = $world->render();
    my $render_finish = clock_gettime(CLOCK_MONOTONIC);
    my $render_time = ($render_finish - $render_start);
    $total_render += $render_time;
    $lowest_render = min($lowest_render, $render_time);
    my $avg_render = $total_render / $world->tick;

    if (!$minimal) {
      print CLEAR_SCREEN;
    }

    printf(
      "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
      $world->tick,
      _f($lowest_tick),
      _f($avg_tick),
      _f($lowest_render),
      _f($avg_render)
    );

    if (!$minimal) {
      print $rendered . SHOW_SCREEN;
    }

    # stdout is buffered and the frame ends with SHOW_SCREEN (no trailing newline), so without
    # an explicit flush the terminal won't commit the synchronized update until the next tick.
    STDOUT->flush();
  }
}

sub _f($value) {
  # seconds -> milliseconds
  $value * 1_000;
}

run();
