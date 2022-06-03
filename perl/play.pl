use strict;
use warnings;

use lib './';
use world;
use Time::HiRes qw(time);

use constant World_Width => 150;
use constant World_Height => 40;

sub run {
  my $world = World->new({
    width => World_Width,
    height => World_Height
  });

  print $world->render();

  my $total_tick = 0;
  my $total_render = 0;

  while (1) {
    my $tick_start = time();
    $world->tick();
    my $tick_finish = time();
    my $tick_time = ($tick_finish - $tick_start);
    $total_tick += $tick_time;
    my $avg_tick = $total_tick / $world->{tick};

    my $render_start = time();
    my $rendered = $world->render();
    my $render_finish = time();
    my $render_time = ($render_finish - $render_start);
    $total_render += $render_time;
    my $avg_render = $total_render / $world->{tick};

    my $output = "#$world->{tick}";
    $output .= " - World tick took ${\_f($tick_time * 1000)} (${\_f($avg_tick * 1000)})";
    $output .= " - Rendering took ${\_f($render_time * 1000)} (${\_f($avg_render * 1000)})";
    $output .= "\n$rendered";
    print "\033[0;0H\033[2J";
    print $output;
  }
}

sub _f {
  my $value = shift;
  sprintf("%.3f", $value);
}

run();
