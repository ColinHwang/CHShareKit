//
//  UITableViewCell+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UITableViewCell+CHBase.h"
#import "NSObject+CHBase.h"

const CGSize CHUITableViewCellAccessoryDisclosureIndicatorBackgroundImageSize = {8, 13};
static const int CH_UI_TABLE_VIEW_CELL_CUSTOM_SELECTED_BACKGROUND_VIEW_KEY;

@interface UITableViewCell ()

@property (nonatomic, strong, setter=_ch_setCustomSelectedBackgroundView:) UIView *_ch_customSelectedBackgroundView;

@end

@implementation UITableViewCell (CHBase)

#pragma mark - Base
- (UIView *)_ch_customSelectedBackgroundView {
    if (self.selectionStyle == UITableViewCellSelectionStyleNone) return nil;
    
    UIView *customSelectedBackgroundView = [self ch_getAssociatedValueForKey:&CH_UI_TABLE_VIEW_CELL_CUSTOM_SELECTED_BACKGROUND_VIEW_KEY];
    if (!customSelectedBackgroundView) {
        customSelectedBackgroundView = [UIView new];
        [self _ch_setCustomSelectedBackgroundView:customSelectedBackgroundView];
    }
    return customSelectedBackgroundView;
}

- (void)_ch_setCustomSelectedBackgroundView:(UIView *)view {
    if (self.selectionStyle == UITableViewCellSelectionStyleNone) return;
    
    [self ch_setAssociatedValue:view withKey:&CH_UI_TABLE_VIEW_CELL_CUSTOM_SELECTED_BACKGROUND_VIEW_KEY];
}

- (UIColor *)ch_selectedBackgroundViewColor {
    if (self.selectionStyle == UITableViewCellSelectionStyleNone) return nil;
    
    return self.selectedBackgroundView.backgroundColor;
}

- (void)ch_setSelectedBackgroundViewColor:(UIColor *)color {
    if (self.selectionStyle == UITableViewCellSelectionStyleNone) return;
    
    self._ch_customSelectedBackgroundView.backgroundColor = color;
    self.selectedBackgroundView = self._ch_customSelectedBackgroundView;
}

#pragma mark - Accessory
- (UIView *)ch_defaultAccessoryView {
    return [self valueForKey:@"_accessoryView"];
}

- (UIView *)ch_defaultEditingAccessoryView {
    return [self valueForKey:@"_editingAccessoryView"];
}

- (UIView *)ch_currentAccessoryView {
    if (self.editing) {
        if (self.editingAccessoryView) return self.editingAccessoryView;
        
        return self.ch_defaultEditingAccessoryView;
    }
    
    if (self.accessoryView) return self.accessoryView;
    
    return self.ch_defaultAccessoryView;
}

- (void)ch_prepareForAccessoryDisclosureIndicatorColor {
    if (self.accessoryType != UITableViewCellAccessoryDisclosureIndicator) return;
    
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            UIImage *image = [button backgroundImageForState:UIControlStateNormal];
            if (CGSizeEqualToSize(image.size, CHUITableViewCellAccessoryDisclosureIndicatorBackgroundImageSize)) {
                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                return;
            }
        }
    }
}

@end
