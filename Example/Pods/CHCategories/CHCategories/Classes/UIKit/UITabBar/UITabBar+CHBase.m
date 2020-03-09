//
//  UITabBar+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UITabBar+CHBase.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"

static const int CH_TAB_BAR_SHADOW_IMAGE_VIEW_BACKGROUND_COLOR_KEY;

@implementation UITabBar (CHBase)

#pragma mark - Base
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selectors = @[
            [NSValue ch_valueWithSelector:@selector(layoutSubviews)],
        ];
        CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix(self, selectors, @"ch_ui_tab_bar_");
    });
}

- (UIView *)ch_backgroundView {
    return [self valueForKey:@"_backgroundView"];
}

- (UIImageView *)ch_shadowImageView {
    if (@available(iOS 10, *)) {
        return [self.ch_backgroundView valueForKey:@"_shadowView"];
    }
    
    //iOS10以前, shadowView在首次layoutSubviews后才创建
    UIImageView *shadowView = [self valueForKey:@"_shadowView"];
    if (!shadowView) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        shadowView = [self valueForKey:@"_shadowView"];
    }
    return shadowView;
}

- (void)setCh_shadowImageViewBackgroundColor:(UIColor *)color {
    [self ch_setAssociatedValue:color withKey:&CH_TAB_BAR_SHADOW_IMAGE_VIEW_BACKGROUND_COLOR_KEY];
}

- (UIColor *)ch_shadowImageViewBackgroundColor {
    UIColor *color = [self ch_getAssociatedValueForKey:&CH_TAB_BAR_SHADOW_IMAGE_VIEW_BACKGROUND_COLOR_KEY];
    if (!color) {
        color = self.ch_shadowImageView.backgroundColor;
        [self setCh_shadowImageViewBackgroundColor:color];
    }
    return color;
}

#pragma mark - Swizzle
- (void)_ch_ui_tab_bar_layoutSubviews {
    [self _ch_ui_tab_bar_layoutSubviews];
    
    self.ch_shadowImageView.backgroundColor = self.ch_shadowImageViewBackgroundColor;
}

@end
