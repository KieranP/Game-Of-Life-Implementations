#ifndef HASHMAP_H
#define HASHMAP_H

#define HASH_TABLE_SIZE 65536

typedef struct HashNode {
  char *key;
  void *value;
  unsigned int hash;
  struct HashNode *next;
} HashNode;

typedef struct {
  HashNode *buckets[HASH_TABLE_SIZE];
  int count;
} HashMap;

HashMap *hashmap_new(void);
void hashmap_free(HashMap *map);
void hashmap_put(HashMap *map, const char *key, void *value);
void *hashmap_get(HashMap *map, const char *key);
void **hashmap_get_all_values(HashMap *map);

#endif
