//
//  UIImageView+CHBase.h
//  CHCategories
//
//  Created by Chwang on 2019/7/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (CHBase)

#pragma mark - Base
@property (nonatomic, assign) BOOL ch_scaleIntrinsicContentSizeEnabled; ///< 是否开启比例调整IntrinsicContentSize
@property (nonatomic, assign) CGFloat ch_preferredScaleIntrinsicContentHeight; ///< IntrinsicContentSize调整瞄定高度
@property (nonatomic, assign) CGFloat ch_preferredScaleIntrinsicContentWidth; ///< IntrinsicContentSize调整瞄定宽度

@end

NS_ASSUME_NONNULL_END
