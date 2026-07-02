#import "Cell.h"

@implementation Cell

- (instancetype)initWithX:(NSUInteger)x y:(NSUInteger)y alive:(BOOL)alive {
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

- (NSUInteger)aliveNeighbours {
  // The following is slower
  // NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Cell *cell, NSDictionary *bindings) {
  //   return cell.alive;
  // }];
  // return [[self.neighbours filteredArrayUsingPredicate:predicate] count];

  // The following is the fastest
  NSUInteger aliveNeighbours = 0;
  for (Cell *neighbour in self.neighbours) {
    if (neighbour.alive) {
      aliveNeighbours++;
    }
  }
  return aliveNeighbours;

  // The following is slower
  // NSUInteger aliveNeighbours = 0;
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
