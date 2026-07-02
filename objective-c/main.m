#import <Foundation/Foundation.h>
#import "World.h"

static const NSUInteger WorldWidth = 150;
static const NSUInteger WorldHeight = 40;

@interface Play : NSObject
+ (void)run;
@end

@implementation Play

+ (void)run {
  @autoreleasepool {
    World *world = [[World alloc] initWithWidth:WorldWidth height:WorldHeight];

    BOOL minimal = (getenv("MINIMAL") != NULL);

    if (!minimal) {
      printf("%s", [[world render] UTF8String]);
    }

    double totalTick = 0.0;
    double lowestTick = DBL_MAX;
    double totalRender = 0.0;
    double lowestRender = DBL_MAX;

    NSProcessInfo *processInfo = [NSProcessInfo processInfo];

    while (true) {
      NSTimeInterval tickStart = processInfo.systemUptime;
      [world doTick];
      NSTimeInterval tickFinish = processInfo.systemUptime;
      double tickTime = tickFinish - tickStart;
      totalTick += tickTime;
      lowestTick = fmin(lowestTick, tickTime);
      double avgTick = totalTick / (double)world.tick;

      NSTimeInterval renderStart = processInfo.systemUptime;
      NSString *rendered = [world render];
      NSTimeInterval renderFinish = processInfo.systemUptime;
      double renderTime = renderFinish - renderStart;
      totalRender += renderTime;
      lowestRender = fmin(lowestRender, renderTime);
      double avgRender = totalRender / (double)world.tick;

      if (!minimal) {
        printf("\033[H\033[2J");
      }

      printf("#%lu - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
             (unsigned long)world.tick,
             [self _f:lowestTick],
             [self _f:avgTick],
             [self _f:lowestRender],
             [self _f:avgRender]);

      if (!minimal) {
        printf("%s", [rendered UTF8String]);
      }
    }
  }
}

+ (double)_f:(double)value {
  // value is in seconds, convert to milliseconds
  return value * 1000.0;
}

@end

int main(int argc, const char * argv[]) {
  [Play run];
  return 0;
}
