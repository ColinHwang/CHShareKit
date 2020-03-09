//
//  UITabBar+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (CHBase)

#pragma mark - Base
/**
 获取UITabBar的背景界面
 iOS10以前 -> _UITabBarBackgroundView
 iOS10以后 -> _UIBarBackground
 */
@property (nonatomic, readonly) UIView *ch_backgroundView;

@property (nonatomic, readonly) UIImageView *ch_shadowImageView; ///< UITabBar的顶部分割线
@property (nonatomic, strong) UIColor *ch_shadowImageViewBackgroundColor; ///< UITabBar的顶部分割线颜色

@end

NS_ASSUME_NONNULL_END
