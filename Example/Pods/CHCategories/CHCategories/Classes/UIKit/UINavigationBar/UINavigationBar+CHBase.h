//
//  UINavigationBar+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (CHBase)

#pragma mark - Base
/**
 获取UINavigationBar的背景界面
 iOS10以前 -> _UINavigationBarBackground
 iOS10以后 -> _UIBarBackground
 */
@property (nonatomic, readonly) UIView *ch_backgroundView;

/**
 获取UINavigationBar的背景内容界面
 iOS10以后:
    显示磨砂 -> UIVisualEffectView
    显示背景图 -> UIImageView
 iOS10以前:
    显示磨砂 -> _UIBackdropView
    显示背景图 -> _UINavigationBarBackground(ch_backgroundView)
 
 */
@property (nonatomic, readonly) __kindof UIView *ch_backgroundContentView;

@property (nonatomic, readonly) UIImageView *ch_shadowImageView; ///< UINavigationBar的底部分割线
@property (nonatomic, strong) UIColor *ch_shadowImageViewBackgroundColor; ///< UINavigationBar的底部分割线颜色

@end

NS_ASSUME_NONNULL_END
