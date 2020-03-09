//
//  UIScreen+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/9.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGSize CHUIScreenSizeInPoint320X480; ///< 获取320X480屏幕的尺寸(PT为单位, iPhone4/4s)
UIKIT_EXTERN const CGSize CHUIScreenSizeInPoint320X568; ///< 获取320X568屏幕的尺寸(PT为单位, iPhone5/5c/5s/SE)
UIKIT_EXTERN const CGSize CHUIScreenSizeInPoint375X667; ///< 获取375X667屏幕的尺寸(PT为单位, iPhone6/7/8)
UIKIT_EXTERN const CGSize CHUIScreenSizeInPoint375X812; ///< 获取375X812屏幕的尺寸(PT为单位, iPhoneX/iPhoneXS)
UIKIT_EXTERN const CGSize CHUIScreenSizeInPoint414X736; ///< 获取414X736屏幕的尺寸(PT为单位, iPhone6 Plus/7 Plus/8 Plus)
UIKIT_EXTERN const CGSize CHUIScreenSizeInPoint414X896; ///< 获取414X896屏幕的尺寸(PT为单位, iPhoneXR/iPhoneXS Max)

@interface UIScreen (CHBase)

#pragma mark - Base
/**
 获取屏幕的分辨倍率(1.0/2.0/3.0)

 @return 屏幕的分辨倍率(1.0/2.0/3.0)
 */
+ (CGFloat)ch_screenScale;

/**
 获取屏幕当前的width(currentBounds.size.width, 屏幕旋转方向改变)

 @return 屏幕当前的width(currentBounds.size.width, 屏幕旋转方向改变)
 */
- (CGFloat)ch_currentWidth;

/**
 获取屏幕当前的height(currentBounds.size.height, 屏幕旋转方向改变)

 @return 屏幕当前的height(currentBounds.size.height, 屏幕旋转方向改变)
 */
- (CGFloat)ch_currentHeight;

/**
 获取屏幕当前的size(currentBounds.size, 屏幕旋转方向改变)

 @return 屏幕当前的size(currentBounds.size, 屏幕旋转方向改变)
 */
- (CGSize)ch_currentSize;

/**
 获取屏幕当前的bounds(屏幕旋转方向改变)

 @return 屏幕当前的bounds(屏幕旋转方向改变)
 */
- (CGRect)ch_currentBounds;

/**
 根据屏幕旋转方向, 获取屏幕当前的bounds([UIScreen mainScreen].bounds只返回竖屏的bounds)

 @param orientation 屏幕旋转方向
 @return 屏幕当前的bounds
 */
- (CGRect)ch_boundsForOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, readonly) CGSize ch_sizeInPoint;    ///< 获取屏幕的尺寸(PT为单位<iPhone5 -> {320, 568}>, 未知设备获取的并不准确 -> 模拟器)
@property (nonatomic, readonly) CGSize ch_sizeInPixel;    ///< 获取屏幕的尺寸(像素为单位<iPhone5 ->{640, 1136}>, 未知设备获取的并不准确 -> 模拟器)
@property (nonatomic, readonly) CGFloat ch_pixelsPerInch; ///< 获取屏幕的像素密度(PPT 默认为96, 未知设备获取的并不准确 -> 模拟器)

@end

NS_ASSUME_NONNULL_END
