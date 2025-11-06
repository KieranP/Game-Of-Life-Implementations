#include "utils.h"
#include <time.h>

// Get current time in nanoseconds using monotonic clock
double get_time_ns(void) {
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  return (double)ts.tv_sec * 1e9 + (double)ts.tv_nsec;
}

// Return the minimum of two doubles
double min_double(double a, double b) { return a < b ? a : b; }

// Convert nanoseconds to milliseconds
double to_ms(double nanoseconds) { return nanoseconds / 1'000'000.0; }

// Fast integer to string conversion without using sprintf/snprintf
// Writes the string representation of num into buf
// Returns pointer to the end of the written string (not null-terminated)
// This allows efficient chaining of multiple conversions
char *int_to_str(char *buf, int num) {
  if (num == 0) {
    *buf++ = '0';
    return buf;
  }

  char temp[12];
  auto i = 0;
  auto is_negative = num < 0;

  if (is_negative) {
    num = -num;
  }

  while (num > 0) {
    temp[i++] = '0' + (num % 10);
    num /= 10;
  }

  if (is_negative) {
    *buf++ = '-';
  }

  while (i > 0) {
    *buf++ = temp[--i];
  }

  return buf;
}
