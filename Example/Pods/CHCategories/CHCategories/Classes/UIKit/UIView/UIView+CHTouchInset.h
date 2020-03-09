//
//  UIView+CHTouchInset.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//  点击区域

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CHTouchInset)
/**
 扩大视图点击区域(正数->内距; 负数->外边)
 */
@property (nonatomic) UIEdgeInsets ch_touchInset;

@end

NS_ASSUME_NONNULL_END
