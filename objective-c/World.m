#import "World.h"

@interface World ()

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
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

- (instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height {
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

- (void)doTick {
  // First determine the action for all cells
  for (Cell *cell in [self.cells objectEnumerator]) {
    NSUInteger aliveNeighbours = [cell aliveNeighbours];
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
  // for (NSUInteger y = 0; y < self.height; y++) {
  //   for (NSUInteger x = 0; x < self.width; x++) {
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
  // for (NSUInteger y = 0; y < self.height; y++) {
  //   for (NSUInteger x = 0; x < self.width; x++) {
  //     Cell *cell = [self cellAtX:x y:y];
  //     if (cell != nil) {
  //       [rendering addObject:[cell toChar]];
  //     }
  //   }
  //   [rendering addObject:@"\n"];
  // }
  // return [rendering componentsJoinedByString:@""];

  // The following is the fastest
  NSMutableString *rendering = [NSMutableString string];
  for (NSUInteger y = 0; y < self.height; y++) {
    for (NSUInteger x = 0; x < self.width; x++) {
      Cell *cell = [self cellAtX:x y:y];
      if (cell != nil) {
        [rendering appendString:[cell toChar]];
      }
    }
    [rendering appendString:@"\n"];
  }
  return rendering;
}

- (NSString *)makeKeyWithX:(NSUInteger)x y:(NSUInteger)y {
  // The following is the fastest
  return [NSString stringWithFormat:@"%lu-%lu", (unsigned long)x, (unsigned long)y];

  // The following is slower
  // return [[@(x).stringValue stringByAppendingString:@"-"] stringByAppendingString:@(y).stringValue];

  // The following is slower
  // return [@[@(x).stringValue, @(y).stringValue] componentsJoinedByString:@"-"];
}

- (Cell *)cellAtX:(NSUInteger)x y:(NSUInteger)y {
  NSString *key = [self makeKeyWithX:x y:y];
  return self.cells[key];
}

- (void)populateCells {
  for (NSUInteger y = 0; y < self.height; y++) {
    for (NSUInteger x = 0; x < self.width; x++) {
      BOOL alive = ((double)arc4random() / UINT32_MAX <= 0.2);
      [self addCellX:x y:y alive:alive];
    }
  }
}

- (BOOL)addCellX:(NSUInteger)x y:(NSUInteger)y alive:(BOOL)alive {
  if ([self cellAtX:x y:y] != nil) {
    @throw [NSException exceptionWithName:@"LocationOccupied"
                                   reason:[NSString stringWithFormat:@"LocationOccupied(%lu-%lu)", (unsigned long)x, (unsigned long)y]
                                 userInfo:nil];
  }

  NSString *key = [self makeKeyWithX:x y:y];
  Cell *cell = [[Cell alloc] initWithX:x y:y alive:alive];
  self.cells[key] = cell;
  return YES;
}

- (void)prepopulateNeighbours {
  for (Cell *cell in [self.cells objectEnumerator]) {
    NSInteger x = (NSInteger)cell.x;
    NSInteger y = (NSInteger)cell.y;

    for (NSArray<NSNumber *> *set in Directions) {
      NSInteger relX = [set[0] integerValue];
      NSInteger relY = [set[1] integerValue];

      NSInteger nx = x + relX;
      NSInteger ny = y + relY;
      if (nx < 0 || ny < 0) {
        continue; // Out of bounds
      }

      NSUInteger ux = (NSUInteger)nx;
      NSUInteger uy = (NSUInteger)ny;
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
