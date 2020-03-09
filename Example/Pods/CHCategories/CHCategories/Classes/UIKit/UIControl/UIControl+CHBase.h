//
//  UIControl+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/10.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (CHBase)

#pragma mark - Base
/**
 根据指定的响应事件, 为控件添加或替换Target和Action

 @param target        target
 @param action        action
 @param controlEvents 响应事件
 */
- (void)ch_setTarget:(id)target
              action:(SEL)action
    forControlEvents:(UIControlEvents)controlEvents;

/**
 根据指定的响应事件, 为控件添加或替换回调事件(替代编辑)

 @param controlEvents 响应事件
 @param block         回调事件
 */
- (void)ch_setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/**
 根据指定的响应事件, 为控件添加回调事件(增量编辑)

 @param controlEvents 指定的响应事件
 @param block         回调事件
 */
- (void)ch_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/**
 根据指定的响应事件, 移除控件所有的回调事件(通过ch_setBlockForControlEvents:block:或ch_addBlockForControlEvents:block:添加)

 @param controlEvents 指定的响应事件
 */
- (void)ch_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

/**
 移除控件所有响应事件的targets
 */
- (void)ch_removeAllTargets;

#pragma mark - Touch Up Inside
/**
 根据TouchUpInside响应事件, 为控件添加或替换Target和Action

 @param target target
 @param action action
 */
- (void)ch_setTarget:(id)target actionForTouchUpInsideControlEvent:(SEL)action;

/**
 根据TouchUpInside响应事件, 为控件添加Target和Action

 @param target target
 @param action action
 */
- (void)ch_addTarget:(id)target actionForTouchUpInsideControlEvent:(SEL)action;

/**
 根据TouchUpInside响应事件, 为控件移除Target和Action

 @param target target
 @param action action
 */
- (void)ch_removeTarget:(id)target actionForTouchUpInsideControlEvent:(SEL)action;

/**
 根据TouchUpInside响应事件, 为控件添加或替换回调事件(替代编辑)

 @param block 回调事件
 */
- (void)ch_setBlockForTouchUpInsideControlEvent:(void (^)(id sender))block;

/**
 根据TouchUpInside响应事件, 为控件添加回调事件(增量编辑)

 @param block 回调事件
 */
- (void)ch_addBlockForTouchUpInsideControlEvent:(void (^)(id sender))block;

/**
 *  根据TouchUpInside响应事件, 移除控件所有的回调事件(通过ch_setBlockForControlEvents:block:或ch_addBlockForControlEvents:block:添加)
 */
- (void)ch_removeAllBlocksForTouchUpInsideControlEvent;

@end

NS_ASSUME_NONNULL_END
