//
//  UINavigationBar+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UINavigationBar+CHBase.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"

static const int CH_UI_NAVIGATION_SHADOW_IMAGE_VIEW_BACKGROUND_COLOR_KEY;

@implementation UINavigationBar (CHBase)

#pragma mark - Base
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selectors = @[
            [NSValue ch_valueWithSelector:@selector(layoutSubviews)],
        ];
        CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix(self, selectors, @"_ch_ui_navigation_bar_");
    });
}

- (UIView *)ch_backgroundView {
    return [self valueForKey:@"_backgroundView"];
}

- (__kindof UIView *)ch_backgroundContentView {
    UIView *view = nil;
    if (@available(iOS 10, *)) {
        UIImageView *imageView = [self.ch_backgroundView valueForKey:@"_backgroundImageView"];
        UIVisualEffectView *visualEffectView = [self.ch_backgroundView valueForKey:@"_backgroundEffectView"];
        UIView *customView = [self.ch_backgroundView valueForKey:@"_customBackgroundView"];
        view = customView && customView.superview ? customView : (imageView && imageView.superview ? imageView : visualEffectView);
    } else {
        UIView *backdropView = [self.ch_backgroundView valueForKey:@"_adaptiveBackdrop"];
        view = backdropView && backdropView.superview ? backdropView : self.ch_backgroundView;
    }
    return view;
}

- (UIImageView *)ch_shadowImageView {
    return [self.ch_backgroundView valueForKey:@"_shadowView"];
}

- (void)setCh_shadowImageViewBackgroundColor:(UIColor *)color {
    [self ch_setAssociatedValue:color withKey:&CH_UI_NAVIGATION_SHADOW_IMAGE_VIEW_BACKGROUND_COLOR_KEY];
}

- (UIColor *)ch_shadowImageViewBackgroundColor {
    UIColor *color = [self ch_getAssociatedValueForKey:&CH_UI_NAVIGATION_SHADOW_IMAGE_VIEW_BACKGROUND_COLOR_KEY];
    if (!color) {
        color = self.ch_shadowImageView.backgroundColor;
        [self setCh_shadowImageViewBackgroundColor:color];
    }
    return color;
}

#pragma mark - Swizzle
- (void)_ch_ui_navigation_bar_layoutSubviews {
    [self _ch_ui_navigation_bar_layoutSubviews];
    
    self.ch_shadowImageView.backgroundColor = self.ch_shadowImageViewBackgroundColor;
}

@end
