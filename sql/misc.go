package main

import (
  "os"
)

func envOr(key string, fallback string) string {
  if value := os.Getenv(key); value != "" {
    return value
  }
  return fallback
}

func readFile(path string) string {
  content, err := os.ReadFile(path)
  if err != nil {
    panic(err)
  }
  return string(content)
}
