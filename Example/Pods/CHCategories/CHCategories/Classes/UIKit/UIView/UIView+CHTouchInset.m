//
//  UIView+CHTouchInset.m
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//

#import "UIView+CHTouchInset.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"

static const int CH_UI_VIEW_TOUCH_INSET_KEY;

@implementation UIView (CHTouchInset)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selectors = @[
            [NSValue ch_valueWithSelector:@selector(pointInside:withEvent:)],
        ];
        CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix(self, selectors, @"_ch_ui_view_");
    });
}

- (void)setCh_touchInset:(UIEdgeInsets)touchInset {
    [self ch_setAssociatedValue:[NSValue valueWithUIEdgeInsets:touchInset] withKey:&CH_UI_VIEW_TOUCH_INSET_KEY];
}

- (UIEdgeInsets)ch_touchInset {
    return [[self ch_getAssociatedValueForKey:&CH_UI_VIEW_TOUCH_INSET_KEY] UIEdgeInsetsValue];
}

#pragma mark - Swizzle
- (BOOL)_ch_ui_view_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.ch_touchInset, UIEdgeInsetsZero) || self.hidden || ([self isKindOfClass:UIControl.class] && !((UIControl *)self).enabled)) {
        return [self _ch_ui_view_pointInside:point withEvent:event]; // original implementation
    }
    
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.ch_touchInset);
    hitFrame.size.width = MAX(hitFrame.size.width, 0); // don't allow negative sizes
    hitFrame.size.height = MAX(hitFrame.size.height, 0);
    return CGRectContainsPoint(hitFrame, point);
}

@end
