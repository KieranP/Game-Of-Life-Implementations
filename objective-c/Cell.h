#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property (nonatomic, assign) NSUInteger x;
@property (nonatomic, assign) NSUInteger y;
@property (nonatomic, assign) BOOL alive;
@property (nonatomic, strong) NSNumber *nextState;
@property (nonatomic, strong) NSMutableArray<Cell *> *neighbours;

- (instancetype)initWithX:(NSUInteger)x y:(NSUInteger)y alive:(BOOL)alive;
- (NSString *)toChar;
- (NSUInteger)aliveNeighbours;

@end
