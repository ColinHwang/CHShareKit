//
//  UIGestureRecognizer+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/10.
//
//

#import "UIGestureRecognizer+CHBase.h"
#import "NSObject+CHBase.h"

static const int CH_UI_GESTURE_RECOGNIZER_BLOCK_KEY;

@interface CHUIGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation CHUIGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id sender))block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    !_block?:_block(sender);
}

@end


@implementation UIGestureRecognizer (CHBase)

#pragma mark - Base
- (UIView *)ch_targetView {
    CGPoint location = [self locationInView:self.view];
    return [self.view hitTest:location withEvent:nil];
}

+ (instancetype)ch_gestureRecognizerWithActionBlock:(void (^)(id sender))block {
    return [[self alloc] initWithActionBlock:block];
}

- (instancetype)initWithActionBlock:(void (^)(id sender))block {
    self = [self init];
    if (self) {
        [self ch_addActionBlock:block];
    }
    return self;
}

- (void)ch_addActionBlock:(void (^)(id sender))block {
    CHUIGestureRecognizerBlockTarget *target = [[CHUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self _ch_allUIGestureRecognizerBlockTargets];
    [targets addObject:target];
}

- (void)ch_removeAllActionBlocks {
    NSMutableArray *targets = [self _ch_allUIGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)_ch_allUIGestureRecognizerBlockTargets{
    NSMutableArray *targets = [self ch_getAssociatedValueForKey:&CH_UI_GESTURE_RECOGNIZER_BLOCK_KEY];
    if (!targets) {
        targets = [NSMutableArray array];
        [self ch_setAssociatedValue:targets withKey:&CH_UI_GESTURE_RECOGNIZER_BLOCK_KEY];
    }
    return targets;
}

@end
