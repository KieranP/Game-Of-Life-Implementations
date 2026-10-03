#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property (nonatomic, assign, readonly) uint32_t x;
@property (nonatomic, assign, readonly) uint32_t y;
@property (nonatomic, assign) BOOL alive;
@property (nonatomic, strong) NSNumber *nextState;
@property (nonatomic, strong) NSMutableArray<Cell *> *neighbours;

- (instancetype)initWithX:(uint32_t)x y:(uint32_t)y alive:(BOOL)alive;
- (NSString *)toChar;
- (uint32_t)aliveNeighbours;

@end
