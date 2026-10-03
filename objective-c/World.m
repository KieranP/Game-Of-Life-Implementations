#import "World.h"

@interface LocationOccupied : NSException

- (instancetype)initWithX:(uint32_t)x y:(uint32_t)y;

@end

@implementation LocationOccupied

- (instancetype)initWithX:(uint32_t)x y:(uint32_t)y {
  NSString *reason = [NSString stringWithFormat:@"LocationOccupied(%u-%u)", x, y];
  return [super initWithName:@"LocationOccupied" reason:reason userInfo:nil];
}

@end

@interface World ()

@property (nonatomic, assign, readwrite) uint32_t tick;
@property (nonatomic, assign) uint32_t width;
@property (nonatomic, assign) uint32_t height;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Cell *> *cells;

@end

@implementation World

static NSArray<NSArray<NSNumber *> *> *Directions;

+ (void)initialize {
  if (self == [World class]) {
    Directions = @[
      @[@(-1), @(1)],  @[@(0), @(1)],  @[@(1), @(1)],  // above
      @[@(-1), @(0)],                  @[@(1), @(0)],  // sides
      @[@(-1), @(-1)], @[@(0), @(-1)], @[@(1), @(-1)]  // below
    ];
  }
}

- (instancetype)initWithWidth:(uint32_t)width height:(uint32_t)height {
  self = [super init];
  if (self) {
    _tick = 0;
    _width = width;
    _height = height;
    _cells = [NSMutableDictionary dictionary];

    [self populateCells];
    [self prepopulateNeighbours];
  }
  return self;
}

// Breaks the neighbour retain cycles so ARC can free the cells
- (void)dealloc {
  for (Cell *cell in [self.cells objectEnumerator]) {
    [cell.neighbours removeAllObjects];
  }
}

- (void)doTick {
  // First determine the action for all cells
  for (Cell *cell in [self.cells objectEnumerator]) {
    uint32_t aliveNeighbours = [cell aliveNeighbours];
    if (!cell.alive && aliveNeighbours == 3) {
      cell.nextState = @(YES);
    } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
      cell.nextState = @(NO);
    } else {
      cell.nextState = @(cell.alive);
    }
  }

  // Then execute the determined action for all cells
  for (Cell *cell in [self.cells objectEnumerator]) {
    cell.alive = [cell.nextState boolValue];
  }

  self.tick++;
}

- (NSString *)render {
  // The following is slower
  // NSString *rendering = @"";
  // for (uint32_t y = 0; y < self.height; y++) {
  //   for (uint32_t x = 0; x < self.width; x++) {
  //     Cell *cell = [self cellAtX:x y:y];
  //     if (cell != nil) {
  //       rendering = [rendering stringByAppendingString:[cell toChar]];
  //     }
  //   }
  //   rendering = [rendering stringByAppendingString:@"\n"];
  // }
  // return rendering;

  // The following is slower
  // NSMutableArray<NSString *> *rendering = [NSMutableArray array];
  // for (uint32_t y = 0; y < self.height; y++) {
  //   for (uint32_t x = 0; x < self.width; x++) {
  //     Cell *cell = [self cellAtX:x y:y];
  //     if (cell != nil) {
  //       [rendering addObject:[cell toChar]];
  //     }
  //   }
  //   [rendering addObject:@"\n"];
  // }
  // return [rendering componentsJoinedByString:@""];

  // The following is the fastest
  uint32_t renderSize = self.width * self.height + self.height;
  NSMutableString *rendering = [NSMutableString stringWithCapacity:renderSize];
  for (uint32_t y = 0; y < self.height; y++) {
    for (uint32_t x = 0; x < self.width; x++) {
      Cell *cell = [self cellAtX:x y:y];
      if (cell != nil) {
        [rendering appendString:[cell toChar]];
      }
    }
    [rendering appendString:@"\n"];
  }
  return rendering;
}

- (NSString *)makeKeyWithX:(uint32_t)x y:(uint32_t)y {
  // The following is the fastest
  return [NSString stringWithFormat:@"%u-%u", x, y];

  // The following is slower
  // return [[@(x).stringValue stringByAppendingString:@"-"] stringByAppendingString:@(y).stringValue];

  // The following is slower
  // return [@[@(x).stringValue, @(y).stringValue] componentsJoinedByString:@"-"];
}

- (Cell *)cellAtX:(uint32_t)x y:(uint32_t)y {
  NSString *key = [self makeKeyWithX:x y:y];
  return self.cells[key];
}

- (void)populateCells {
  for (uint32_t y = 0; y < self.height; y++) {
    for (uint32_t x = 0; x < self.width; x++) {
      BOOL alive = ((double)arc4random() / UINT32_MAX <= 0.2);
      [self addCellX:x y:y alive:alive];
    }
  }
}

- (BOOL)addCellX:(uint32_t)x y:(uint32_t)y alive:(BOOL)alive {
  Cell *existing = [self cellAtX:x y:y];
  if (existing != nil) {
    @throw [[LocationOccupied alloc] initWithX:x y:y];
  }

  Cell *cell = [[Cell alloc] initWithX:x y:y alive:alive];
  NSString *key = [self makeKeyWithX:x y:y];
  self.cells[key] = cell;
  return YES;
}

- (void)prepopulateNeighbours {
  for (Cell *cell in [self.cells objectEnumerator]) {
    int32_t x = (int32_t)cell.x;
    int32_t y = (int32_t)cell.y;

    for (NSArray<NSNumber *> *set in Directions) {
      int32_t relX = [set[0] intValue];
      int32_t relY = [set[1] intValue];

      int32_t nx = x + relX;
      int32_t ny = y + relY;
      if (nx < 0 || ny < 0) {
        continue; // Out of bounds
      }

      uint32_t ux = (uint32_t)nx;
      uint32_t uy = (uint32_t)ny;
      if (ux >= self.width || uy >= self.height) {
        continue; // Out of bounds
      }

      Cell *neighbour = [self cellAtX:ux y:uy];
      if (neighbour != nil) {
        [cell.neighbours addObject:neighbour];
      }
    }
  }
}

@end
