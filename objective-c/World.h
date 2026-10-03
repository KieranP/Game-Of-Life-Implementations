#import <Foundation/Foundation.h>
#import "Cell.h"

@interface World : NSObject

@property (nonatomic, assign, readonly) uint32_t tick;

- (instancetype)initWithWidth:(uint32_t)width height:(uint32_t)height;
- (void)doTick;
- (NSString *)render;

@end
