//
//  UISwipeGestureRecognizer+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/10.
//
//

#import "UISwipeGestureRecognizer+CHBase.h"
#import "UIGestureRecognizer+CHBase.h"

const UISwipeGestureRecognizerDirection CHUISwipeGestureRecognizerDirectionHorizontal = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;

const UISwipeGestureRecognizerDirection CHUISwipeGestureRecognizerDirectionVertical = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;

@implementation UISwipeGestureRecognizer (CHBase)

#pragma mark - Base
+ (instancetype)ch_swipeGestureRecognizerWithDirection:(UISwipeGestureRecognizerDirection)direction target:(id)target action:(SEL)action {
    return [[self alloc] initWithDirection:direction target:target action:action];
}

+ (instancetype)ch_swipeGestureRecognizerWithDirection:(UISwipeGestureRecognizerDirection)direction actionBlock:(void (^)(id sender))block {
    return [[self alloc] initWithDirection:direction actionBlock:block];
}

- (instancetype)initWithDirection:(UISwipeGestureRecognizerDirection)direction target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        self = [self initWithTarget:target action:action];
        [self setDirection:direction];
    }
    return self;
}

- (instancetype)initWithDirection:(UISwipeGestureRecognizerDirection)direction actionBlock:(void (^)(id sender))block {
    self = [super init];
    if (self) {
        if (block) {
            self = [self initWithActionBlock:block];
        }
        [self setDirection:direction];
    }
    return self;
}

@end
