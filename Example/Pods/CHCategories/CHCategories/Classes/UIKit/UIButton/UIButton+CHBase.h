//
//  UIButton+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/12.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CHBase)

#pragma mark - Base
/**
 根据图片和文本, 创建按钮

 @param image 图片
 @param title 文本
 @return 按钮
 */
- (instancetype)ch_initWithImage:(UIImage *)image title:(NSString *)title;

#pragma mark - Count Down
/**
 根据倒计时间, 倒计标题, 倒计背景颜色, 结束标题及结束背景颜色, 修改Button(每秒修改)
 
 @param seconds                 倒计时间
 @param title                   倒计标题
 @param backgroundColor         倒计背景颜色
 @param finishedTitle           结束标题
 @param finishedBackgroundColor 结束背景颜色
 */
- (void)ch_changeWithCountDown:(NSInteger)seconds
                         title:(NSString *)title
               backgroundColor:(UIColor *)backgroundColor
                 finishedTitle:(NSString *)finishedTitle
       finishedBackgroundColor:(UIColor *)finishedBackgroundColor;

@end

NS_ASSUME_NONNULL_END
