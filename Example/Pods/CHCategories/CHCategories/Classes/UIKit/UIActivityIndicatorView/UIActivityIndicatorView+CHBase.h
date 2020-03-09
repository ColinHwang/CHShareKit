//
//  UIActivityIndicatorView+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2019/2/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIActivityIndicatorView (CHBase)

#pragma mark - Base
/**
 根据指定类型及大小, 创建UIActivityIndicatorView(类似`initWithActivityIndicatorStyle`, 系统的UIActivityIndicatorView尺寸由UIActivityIndicatorViewStyle决定，固定不变. 创建后通过CGAffineTransformMakeScale将其缩放到指定大小)

 @param style 类型
 @param size 指定大小
 @return UIActivityIndicatorView对象
 */
- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
