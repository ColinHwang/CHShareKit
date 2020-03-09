//
//  UIViewController+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2020/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CHBase)

/**
 设置全局偏好呈现转场风格(Default is UIModalPresentationAutomatic)

 @param style 呈现转场风格
*/
+ (void)ch_setupPreferredModalPresentationStyle:(UIModalPresentationStyle)style;

/**
 获取全局偏好呈现转场风格
 
 @return 全局偏好呈现转场风格
*/
+ (UIModalPresentationStyle)ch_preferredModalPresentationStyle;

@end

NS_ASSUME_NONNULL_END
