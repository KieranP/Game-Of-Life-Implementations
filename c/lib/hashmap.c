#include "hashmap.h"
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

// Doubles the expected count to decrease hash collisions, then rounds up to a
// power of two for masking (150 * 40 = 6,000 gives 16,384)
HashMap *hashmap_new(size_t expected_count) {
  HashMap *map = malloc(sizeof(*map));
  if (!map) {
    return nullptr;
  }

  auto capacity = (size_t)1;
  while (capacity < expected_count * 2) {
    capacity *= 2;
  }

  map->entries = calloc(capacity, sizeof(HashEntry));
  if (!map->entries) {
    free(map);
    return nullptr;
  }

  map->capacity = capacity;
  map->count = 0;
  map->values = nullptr;
  for (auto i = 0; i < capacity; ++i) {
    map->entries[i].state = HASH_ENTRY_EMPTY;
  }

  return map;
}

// Frees the keys only; the caller owns the values
void hashmap_free(HashMap *map) {
  for (auto i = 0; i < map->capacity; ++i) {
    if (map->entries[i].state == HASH_ENTRY_OCCUPIED) {
      free(map->entries[i].key);
    }
  }
  free(map->entries);
  free(map->values);
  free(map);
}

// Doubles the table, reusing each entry's stored hash
static bool hashmap_grow(HashMap *map) {
  auto capacity = map->capacity * 2;
  HashEntry *entries = calloc(capacity, sizeof(HashEntry));
  if (!entries) {
    return false;
  }

  auto mask = capacity - 1;
  for (auto i = 0; i < map->capacity; ++i) {
    auto entry = map->entries[i];
    if (entry.state == HASH_ENTRY_OCCUPIED) {
      auto idx = (size_t)entry.hash & mask;
      while (entries[idx].state == HASH_ENTRY_OCCUPIED) {
        idx = (idx + 1) & mask;
      }
      entries[idx] = entry;
    }
  }

  free(map->entries);
  map->entries = entries;
  map->capacity = capacity;
  return true;
}

bool hashmap_put(HashMap *map, const char *key, void *value) {
  if (!map || !key) {
    return false;
  }

  // Past half full, probe chains lengthen and a full table drops inserts
  if ((map->count + 1) * 2 > map->capacity) {
    if (!hashmap_grow(map)) {
      return false;
    }
  }

  free(map->values);
  map->values = nullptr;

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
    return nullptr;
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
      return nullptr;
    }
  }

  return nullptr;
}

// The map owns the returned array, which stays valid until the next put
void **hashmap_get_all_values(HashMap *map) {
  if (!map) {
    return nullptr;
  }

  if (map->values) {
    return map->values;
  }

  void **values = malloc(map->count * sizeof(*values));
  if (!values) {
    return nullptr;
  }

  auto j = 0;
  for (auto i = 0; i < map->capacity; ++i) {
    if (map->entries[i].state == HASH_ENTRY_OCCUPIED) {
      values[j++] = map->entries[i].value;
    }
  }

  map->values = values;
  return values;
}
