#!/bin/bash

source adapters.sh

DB_TYPE=${DB_TYPE:-sqlite}
$DB_CMD < "$DB_TYPE/init.sql"

# Bash doesn't support floating point math
# So if we want 123.45, we need to do this
format_time() {
  awk "BEGIN {printf \"%.3f\", $1 / 1000000}"
}

MINIMAL=${MINIMAL:-""}

if [ -z "$MINIMAL" ]; then
  $DB_CMD < "$DB_TYPE/render.sql"
fi

tick_count=0
total_tick=0
lowest_tick=999999999999
total_render=0
lowest_render=999999999999

while true; do
  tick_count=$((tick_count + 1))

  tick_start=$(date +%s%N)
  $DB_CMD < "$DB_TYPE/tick.sql"
  tick_finish=$(date +%s%N)
  tick_time=$((tick_finish - tick_start))
  total_tick=$((total_tick + tick_time))
  if [ "$tick_time" -lt "$lowest_tick" ]; then
    lowest_tick=$tick_time
  fi
  avg_tick=$((total_tick / tick_count))

  render_start=$(date +%s%N)
  rendered=$($DB_CMD < "$DB_TYPE/render.sql")
  render_finish=$(date +%s%N)
  render_time=$((render_finish - render_start))
  total_render=$((total_render + render_time))
  if [ "$render_time" -lt "$lowest_render" ]; then
    lowest_render=$render_time
  fi
  avg_render=$((total_render / tick_count))

  if [ -z "$MINIMAL" ]; then
    printf "\033[H\033[2J"
  fi

  printf "#%d - World Tick (L: %s; A: %s) - Rendering (L: %s; A: %s)\n" \
    "$tick_count" \
    "$(format_time $lowest_tick)" \
    "$(format_time $avg_tick)" \
    "$(format_time $lowest_render)" \
    "$(format_time $avg_render)"

  if [ -z "$MINIMAL" ]; then
    echo "$rendered"
  fi
done
