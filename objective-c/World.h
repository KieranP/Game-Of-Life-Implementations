#import <Foundation/Foundation.h>
#import "Cell.h"

@interface World : NSObject

@property (nonatomic, assign) NSUInteger tick;

- (instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height;
- (void)doTick;
- (NSString *)render;

@end
