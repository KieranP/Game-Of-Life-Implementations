#ifndef HASHMAP_H
#define HASHMAP_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

// Start with the expected size of the hash table (150 * 40 = 6,000)
// Then round up to a power of two (2**ceil(log2(6000))) = 8,192
// Then double it in order to decrease hash collisions = 16,384
#define HASH_TABLE_SIZE 16384

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
} HashMap;

typedef struct {
  const char *key;
  void *value;
  HashMap *_map;
  size_t _index;
} HashMapIterator;

HashMap *hashmap_new(void);
bool hashmap_put(HashMap *map, const char *key, void *value);
void *hashmap_get(HashMap *map, const char *key);
void **hashmap_get_all_values(HashMap *map);
HashMapIterator hashmap_iterator(HashMap *map);
bool hashmap_iterator_next(HashMapIterator *it);
void hashmap_iterator_reset(HashMapIterator *it);

#endif
