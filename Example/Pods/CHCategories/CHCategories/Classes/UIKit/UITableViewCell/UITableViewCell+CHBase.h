//
//  UITableViewCell+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (CHBase)

#pragma mark - Base
/**
 Cell选中时的背景颜色, SelectionStyle为UITableViewCellSelectionStyleNone时为nil
 */
@property (nullable, nonatomic, readonly) UIColor *ch_selectedBackgroundViewColor;

/**
 设置Cell选中时的背景颜色, SelectionStyle为UITableViewCellSelectionStyleNone时无效

 @param color 背景颜色
 */
- (void)ch_setSelectedBackgroundViewColor:(UIColor *)color;

#pragma mark - Accessory
@property (nonatomic, readonly) UIView *ch_defaultAccessoryView;        ///< 获取系统的默认AccessoryView
@property (nonatomic, readonly) UIView *ch_defaultEditingAccessoryView; ///< 获取编辑状态下系统的默认EditingAccessoryView

/**
 获取当前的AccessoryView(优先级:编辑状态下自定义的EditingAccessoryView -> 编辑状态下系统的默认EditingAccessoryView -> 自定义的AccessoryView -> 系统的默认AccessoryView)
 */
@property (nonatomic, readonly) UIView *ch_currentAccessoryView;

/**
 准备设置Cell的AccessoryDisclosureIndicator的颜色, 在Cell调用"setTintColor:"方法前调用
 Usage:
 
 [cell ch_prepareForAccessoryDisclosureIndicatorColor];
 [cell setTintColor:[UIColor blackColor]];
 */
- (void)ch_prepareForAccessoryDisclosureIndicatorColor;

@end

NS_ASSUME_NONNULL_END
