#ifndef HASHMAP_H
#define HASHMAP_H

#include <stddef.h>
#include <stdint.h>

typedef enum { HASH_ENTRY_EMPTY = 0, HASH_ENTRY_OCCUPIED } HashEntryState;

typedef struct {
  HashEntryState state;
  uint32_t hash;
  char *key;
  void *value;
} HashEntry;

typedef struct {
  HashEntry *entries;
  size_t capacity;
  size_t count;
  void **values;
} HashMap;

HashMap *hashmap_new(size_t expected_count);
void hashmap_free(HashMap *map);
bool hashmap_put(HashMap *map, const char *key, void *value);
void *hashmap_get(HashMap *map, const char *key);
void **hashmap_get_all_values(HashMap *map);

#endif
