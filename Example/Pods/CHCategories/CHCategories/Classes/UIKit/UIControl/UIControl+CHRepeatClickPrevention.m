//
//  UIControl+CHRepeatClickPrevention.m
//  Pods
//
//  Created by CHwang on 17/2/11.
//
//

#import "UIControl+CHRepeatClickPrevention.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"

static const int CH_UI_CONTROL_REPEAT_CLICK_PREVENTION_KEY;
static const int CH_UI_CONTROL_ACCEPT_EVENT_INTERVAL_KEY;
static const int CH_UI_CONTROL_IGNORE_EVENT_KEY;

@implementation UIControl (CHRepeatClickPrevention)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selectors = @[
            [NSValue ch_valueWithSelector:@selector(sendAction:to:forEvent:)],
        ];
        CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix(self, selectors, @"_ch_ui_control_");
    });
}

- (BOOL)ch_repeatClickPrevention {
    return [[self ch_getAssociatedValueForKey:&CH_UI_CONTROL_REPEAT_CLICK_PREVENTION_KEY] boolValue];
}

- (void)setCh_repeatClickPrevention:(BOOL)repeatClickPrevention {
    [self ch_setAssociatedValue:@(repeatClickPrevention) withKey:&CH_UI_CONTROL_REPEAT_CLICK_PREVENTION_KEY];
}

- (NSTimeInterval)ch_acceptEventInterval {
    return [[self ch_getAssociatedValueForKey:&CH_UI_CONTROL_ACCEPT_EVENT_INTERVAL_KEY] doubleValue];
}

- (void)setCh_acceptEventInterval:(NSTimeInterval)acceptEventInterval {
    [self ch_setAssociatedValue:@(acceptEventInterval) withKey:&CH_UI_CONTROL_ACCEPT_EVENT_INTERVAL_KEY];
}

- (BOOL)ch_ignoreEvent {
    return [[self ch_getAssociatedValueForKey:&CH_UI_CONTROL_IGNORE_EVENT_KEY] boolValue];
}

- (void)setCh_ignoreEvent:(BOOL)ignoreEvent {
    [self ch_setAssociatedValue:@(ignoreEvent) withKey:&CH_UI_CONTROL_IGNORE_EVENT_KEY];
}

+ (NSMutableSet *)_ch_ui_control_getRepeatClickPreventionClassForTargetsOfWhitelist {
    static dispatch_once_t onceToken;
    static NSMutableSet *set;
    dispatch_once(&onceToken, ^{
        set = [NSMutableSet set];
    });
    return set;
}

+ (void)ch_addRepeatClickPreventionClassForTargetsToWhitelist:(Class)aClass {
    if (!aClass) return;
    
    NSMutableSet *set = [self _ch_ui_control_getRepeatClickPreventionClassForTargetsOfWhitelist];
    [set addObject:aClass];
}

+ (void)ch_removeRepeatClickPreventionClassForTargetsFromWhitelist:(Class)aClass {
    if (!aClass) return;
    
    NSMutableSet *set = [self _ch_ui_control_getRepeatClickPreventionClassForTargetsOfWhitelist];
    [set removeObject:aClass];
}

#pragma mark - Swizzle
- (void)_ch_ui_control_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSMutableSet *whitelist = [[self class] _ch_ui_control_getRepeatClickPreventionClassForTargetsOfWhitelist];
    if ([whitelist containsObject:[target class]]) {
        [self _ch_ui_control_sendAction:action to:target forEvent:event];
        return;
    }
    
    if (!self.ch_repeatClickPrevention) {
        [self _ch_ui_control_sendAction:action to:target forEvent:event];
        return;
    }
    
    if (self.ch_ignoreEvent) return;
    if (self.ch_acceptEventInterval > 0) {
        self.ch_ignoreEvent = YES;
        [self performSelector:@selector(_ch_setupIgnoreEvent:) withObject:@(NO) afterDelay:self.ch_acceptEventInterval];
    }
    
    [self _ch_ui_control_sendAction:action to:target forEvent:event];
}

- (void)_ch_setupIgnoreEvent:(NSNumber *)value {
    BOOL ignoreEvent = [value boolValue];
    [self setCh_ignoreEvent:ignoreEvent];
}

@end
