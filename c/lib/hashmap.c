#include "hashmap.h"
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

/* FNV-1a 32-bit */
static inline uint32_t hash_full(const char *key) {
  uint32_t hash = 2166136261u;
  const unsigned char *p = (const unsigned char *)key;
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
  HashMap *map = malloc(sizeof(HashMap));
  if (!map) {
    return NULL;
  }

  size_t capacity = (size_t)HASH_TABLE_SIZE;
  assert((capacity & (capacity - 1)) == 0);

  map->entries = calloc(capacity, sizeof(HashEntry));
  if (!map->entries) {
    free(map);
    return NULL;
  }

  map->capacity = capacity;
  map->count = 0;
  for (size_t i = 0; i < capacity; ++i) {
    map->entries[i].state = HASH_ENTRY_EMPTY;
  }

  return map;
}

bool hashmap_put(HashMap *map, const char *key, void *value) {
  if (!map || !key) {
    return false;
  }

  uint32_t hash = hash_full(key);
  size_t capacity = map->capacity;
  size_t mask = capacity - 1;
  size_t idx = (size_t)hash & mask;

  for (size_t probe = 0; probe < capacity; ++probe) {
    HashEntry *entry = &map->entries[idx];

    if (entry->state == HASH_ENTRY_OCCUPIED) {
      if (entry->hash == hash && fast_strcmp(entry->key, key) == 0) {
        map->entries[idx].value = value;
        return true;
      } else {
        idx = (idx + 1) & mask;
      }
    } else {
      char *dup = strdup(key);
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

  uint32_t hash = hash_full(key);
  size_t capacity = map->capacity;
  size_t mask = capacity - 1;
  size_t idx = (size_t)hash & mask;

  for (size_t probe = 0; probe < capacity; ++probe) {
    HashEntry *entry = &map->entries[idx];

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

  void **values = malloc(map->count * sizeof(void *));
  if (!values) {
    return NULL;
  }

  size_t j = 0;
  for (size_t i = 0; i < map->capacity; ++i) {
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
  HashMap *map = it->_map;
  while (it->_index < map->capacity) {
    size_t i = it->_index;
    it->_index++;
    if (map->entries[i].state == HASH_ENTRY_OCCUPIED) {
      HashEntry entry = map->entries[i];
      it->key = entry.key;
      it->value = entry.value;
      return true;
    }
  }
  return false;
}

void hashmap_iterator_reset(HashMapIterator *it) {
  it->_index = 0;
}
