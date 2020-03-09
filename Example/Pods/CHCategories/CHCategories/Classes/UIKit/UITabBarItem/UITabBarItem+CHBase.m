//
//  UITabBarItem+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2019/2/16.
//

#import "UITabBarItem+CHBase.h"
#import "UIBarItem+CHBase.h"
#import "UIDevice+CHMachineInfo.h"

@implementation UITabBarItem (CHBase)

#pragma mark - Base
- (UIImageView *)ch_imageView {
    return [self _ch_imageViewInTabBarButton:self.ch_view];
}

- (UIImageView *)_ch_imageViewInTabBarButton:(UIView *)tabBarButton {
    if (!tabBarButton) return nil;
    
    for (UIView *subview in tabBarButton.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITabBarSwappableImageView"]) {
            return (UIImageView *)subview;
        }
        
        if (![UIDevice currentDevice].ch_isiOS10Later) {
            if ([subview isKindOfClass:[UIImageView class]] && ![NSStringFromClass([subview class]) isEqualToString:@"UITabBarSelectionIndicatorView"]) {
                return (UIImageView *)subview;
            }
        }
    }
    return nil;
}

@end
