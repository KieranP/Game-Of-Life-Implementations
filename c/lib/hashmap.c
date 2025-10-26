#include "hashmap.h"
#include <stdlib.h>
#include <string.h>

// FNV-1a hash function for strings - fast and good distribution
static inline unsigned int hash_full(const char *key) {
  unsigned int hash = 2166136261u;
  while (*key) {
    hash ^= (unsigned char)(*key++);
    hash *= 16777619u;
  }
  return hash;
}

static inline unsigned int hash(const char *key) {
  return hash_full(key) & (HASH_TABLE_SIZE - 1);
}

// Fast string comparison - optimized for short keys
static inline int fast_strcmp(const char *s1, const char *s2) {
  while (*s1 && (*s1 == *s2)) {
    s1++;
    s2++;
  }
  return *(const unsigned char *)s1 - *(const unsigned char *)s2;
}

HashMap *hashmap_new(void) {
  HashMap *map = malloc(sizeof(HashMap));
  map->count = 0;
  for (int i = 0; i < HASH_TABLE_SIZE; i++) {
    map->buckets[i] = NULL;
  }
  return map;
}

void hashmap_put(HashMap *map, const char *key, void *value) {
  unsigned int full_hash = hash_full(key);
  unsigned int index = full_hash & (HASH_TABLE_SIZE - 1);
  HashNode *node = malloc(sizeof(HashNode));
  node->key = strdup(key);
  node->value = value;
  node->hash = full_hash;
  node->next = map->buckets[index];
  map->buckets[index] = node;
  map->count++;
}

void *hashmap_get(HashMap *map, const char *key) {
  unsigned int full_hash = hash_full(key);
  unsigned int index = full_hash & (HASH_TABLE_SIZE - 1);
  HashNode *node = map->buckets[index];
  while (node != NULL) {
    if (node->hash == full_hash && fast_strcmp(node->key, key) == 0) {
      return node->value;
    }
    node = node->next;
  }
  return NULL;
}

void hashmap_free(HashMap *map) {
  for (int i = 0; i < HASH_TABLE_SIZE; i++) {
    HashNode *node = map->buckets[i];
    while (node != NULL) {
      HashNode *next = node->next;
      free(node->key);
      free(node);
      node = next;
    }
  }
  free(map);
}

void **hashmap_get_all_values(HashMap *map) {
  void **values = malloc(map->count * sizeof(void *));
  int idx = 0;
  for (int i = 0; i < HASH_TABLE_SIZE; i++) {
    HashNode *node = map->buckets[i];
    while (node != NULL) {
      values[idx++] = node->value;
      node = node->next;
    }
  }
  return values;
}
