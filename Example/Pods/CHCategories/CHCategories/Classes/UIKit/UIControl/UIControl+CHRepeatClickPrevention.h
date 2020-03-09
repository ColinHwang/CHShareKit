//
//  UIControl+CHRepeatClickPrevention.h
//  Pods
//
//  Created by CHwang on 17/2/11.
//
//  重复点击保护处理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (CHRepeatClickPrevention)

@property (nonatomic, assign) BOOL ch_repeatClickPrevention;         ///< 是否开启重复点击保护, 默认为NO
@property (nonatomic, assign) NSTimeInterval ch_acceptEventInterval; ///< 指定秒数间隔后响应事件, 仅当ch_repeatClickPrevention为YES时有效

/**
 根据Target对应的类, 添加重复点击保护白名单
 
 @param aClass Target对应的类
 */
+ (void)ch_addRepeatClickPreventionClassForTargetsToWhitelist:(Class)aClass;

/**
 根据Target对应的类, 移除重复点击保护白名单
 
 @param aClass Target对应的类
 */
+ (void)ch_removeRepeatClickPreventionClassForTargetsFromWhitelist:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
