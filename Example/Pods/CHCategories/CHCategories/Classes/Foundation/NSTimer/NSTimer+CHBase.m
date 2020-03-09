//
//  NSTimer+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/4.
//

#import "NSTimer+CHBase.h"

@implementation NSTimer (CHBase)

#pragma mark - Base
+ (NSTimer *)ch_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_ch_executeBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)ch_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_ch_executeBlock:) userInfo:[block copy] repeats:repeats];
}

+ (void)_ch_executeBlock:(NSTimer *)timer {
    // [timer userInfo] == NSTimerExecutionWhileFiring block
    if ([timer userInfo])  {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

@end
