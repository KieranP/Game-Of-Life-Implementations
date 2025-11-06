#include "hashmap.h"
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

/* FNV-1a 32-bit */
static inline uint32_t hash_full(const char *key) {
  auto hash = 2166136261u;
  auto p = (const unsigned char *)key;
  while (*p) {
    hash ^= (uint32_t)(*p++);
    hash *= 16777619u;
  }
  return hash;
}

static inline int fast_strcmp(const char *s1, const char *s2) {
  while (*s1 && (*s1 == *s2)) {
    s1++;
    s2++;
  }
  return (unsigned char)*s1 - (unsigned char)*s2;
}

HashMap *hashmap_new(void) {
  auto map = (HashMap *)malloc(sizeof(HashMap));
  if (!map) {
    return NULL;
  }

  auto capacity = (size_t)HASH_TABLE_SIZE;
  assert((capacity & (capacity - 1)) == 0);

  map->entries = calloc(capacity, sizeof(HashEntry));
  if (!map->entries) {
    free(map);
    return NULL;
  }

  map->capacity = capacity;
  map->count = 0;
  for (auto i = 0; i < capacity; ++i) {
    map->entries[i].state = HASH_ENTRY_EMPTY;
  }

  return map;
}

bool hashmap_put(HashMap *map, const char *key, void *value) {
  if (!map || !key) {
    return false;
  }

  auto hash = hash_full(key);
  auto capacity = map->capacity;
  auto mask = capacity - 1;
  auto idx = (size_t)hash & mask;

  for (auto probe = 0; probe < capacity; ++probe) {
    auto entry = &map->entries[idx];

    if (entry->state == HASH_ENTRY_OCCUPIED) {
      if (entry->hash == hash && fast_strcmp(entry->key, key) == 0) {
        map->entries[idx].value = value;
        return true;
      } else {
        idx = (idx + 1) & mask;
      }
    } else {
      auto dup = strdup(key);
      if (!dup) {
        return false;
      }

      entry->key = dup;
      entry->value = value;
      entry->hash = hash;
      entry->state = HASH_ENTRY_OCCUPIED;

      map->count += 1;

      return true;
    }
  }

  return false;
}

void *hashmap_get(HashMap *map, const char *key) {
  if (!map || !key) {
    return NULL;
  }

  auto hash = hash_full(key);
  auto capacity = map->capacity;
  auto mask = capacity - 1;
  auto idx = (size_t)hash & mask;

  for (auto probe = 0; probe < capacity; ++probe) {
    auto entry = &map->entries[idx];

    if (entry->state == HASH_ENTRY_OCCUPIED) {
      if (entry->hash == hash && fast_strcmp(entry->key, key) == 0) {
        return entry->value;
      } else {
        idx = (idx + 1) & mask;
      }
    } else {
      return NULL;
    }
  }

  return NULL;
}

void **hashmap_get_all_values(HashMap *map) {
  if (!map) {
    return NULL;
  }

  auto values = (void **)malloc(map->count * sizeof(void *));
  if (!values) {
    return NULL;
  }

  auto j = 0;
  for (auto i = 0; i < map->capacity; ++i) {
    if (map->entries[i].state == HASH_ENTRY_OCCUPIED) {
      values[j++] = map->entries[i].value;
    }
  }

  return values;
}

HashMapIterator hashmap_iterator(HashMap *map) {
  HashMapIterator it;
  it._map = map;
  it._index = 0;
  return it;
}

bool hashmap_iterator_next(HashMapIterator *it) {
  auto map = it->_map;
  while (it->_index < map->capacity) {
    auto i = it->_index;
    it->_index++;
    if (map->entries[i].state == HASH_ENTRY_OCCUPIED) {
      auto entry = map->entries[i];
      it->key = entry.key;
      it->value = entry.value;
      return true;
    }
  }
  return false;
}

void hashmap_iterator_reset(HashMapIterator *it) { it->_index = 0; }
