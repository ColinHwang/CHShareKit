//
//  UIGestureRecognizer+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/10.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (CHBase)

#pragma mark - Base
/**
 获取当前手势响应的View(.view -> 手势添加的View, .ch_targetView -> 手势响应的View)
 */
@property (nullable, nonatomic, weak, readonly) UIView *ch_targetView;

/**
 创建一个包含回调事件的手势响应者

 @param block 手势回调事件
 @return 手势响应者
 */
+ (instancetype)ch_gestureRecognizerWithActionBlock:(void (^)(id sender))block;

/**
 初始化一个包含回调事件的手势响应者

 @param block 手势回调事件
 @return 手势响应者
 */
- (instancetype)initWithActionBlock:(void (^)(id sender))block;

/**
 为手势响应者添加回调事件

 @param block 手势回调事件
 */
- (void)ch_addActionBlock:(void (^)(id sender))block;

/**
 移除手势响应者的所有回调事件(通过ch_addActionBlock:添加)
 */
- (void)ch_removeAllActionBlocks;

@end

NS_ASSUME_NONNULL_END
