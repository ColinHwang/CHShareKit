//
//  UISlider+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISlider (CHBase)

#pragma mark - Base
@property (nonatomic, readonly) CGRect ch_trackRect; ///< 获取Slider的Track图片的Rect, Rect根据Slider的Bounds计算
@property (nonatomic, readonly) CGRect ch_thumbRect; ///< 获取Slider的Thumb图片的Rect, Rect根据Slider的Bounds计算

@end

NS_ASSUME_NONNULL_END
