#import "Cell.h"

@implementation Cell

- (instancetype)initWithX:(uint32_t)x y:(uint32_t)y alive:(BOOL)alive {
  self = [super init];
  if (self) {
    _x = x;
    _y = y;
    _alive = alive;
    _nextState = nil;
    _neighbours = [NSMutableArray array];
  }
  return self;
}

- (NSString *)toChar {
  return self.alive ? @"o" : @" ";
}

- (uint32_t)aliveNeighbours {
  // The following is slower
  // NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Cell *cell, NSDictionary *bindings) {
  //   return cell.alive;
  // }];
  // return [[self.neighbours filteredArrayUsingPredicate:predicate] count];

  // The following is the fastest
  uint32_t aliveNeighbours = 0;
  for (Cell *neighbour in self.neighbours) {
    if (neighbour.alive) {
      aliveNeighbours++;
    }
  }
  return aliveNeighbours;

  // The following is slower
  // uint32_t aliveNeighbours = 0;
  // NSUInteger count = [self.neighbours count];
  // for (NSUInteger i = 0; i < count; i++) {
  //   Cell *neighbour = self.neighbours[i];
  //   if (neighbour.alive) {
  //     aliveNeighbours++;
  //   }
  // }
  // return aliveNeighbours;
}

@end
