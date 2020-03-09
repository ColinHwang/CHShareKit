//
//  UIScrollView+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CHUIScrollViewScrollDirection) { ///<
    CHUIScrollViewScrollDirectionVertical,
    CHUIScrollViewScrollDirectionHorizontal
};

@interface UIScrollView (CHBase)

#pragma mark - Base
/**
 获取UIScrollView的contentInset
 iOS11以前 -> contentInset
 iOS11以后 -> adjustedContentInset
 */
@property (nonatomic, readonly) UIEdgeInsets ch_contentInset;

/**
 显示滚动指示器(同时设置Horizontal及Vertical指示器)
 */
@property (nonatomic, assign) BOOL ch_showsScrollIndicator;

@property (nonatomic, readonly) BOOL ch_isScrolledToTop;    ///< 是否已滑动至顶部
@property (nonatomic, readonly) BOOL ch_isScrolledToLeft;   ///< 是否已滑动至左边
@property (nonatomic, readonly) BOOL ch_isScrolledToBottom; ///< 是否已滑动至底部
@property (nonatomic, readonly) BOOL ch_isScrolledToRight;  ///< 是否已滑动至右边

/**
 判断UIScrollView是否可滑动

 @return 可滑动返回YES, 否则返回NO
 */
- (BOOL)ch_canScroll;

/**
 根据滑动方向, 判断UIScrollView是否可滑动

 @param direction 滑动方向
 @return 可滑动返回YES, 否则返回NO
 */
- (BOOL)ch_canScroll:(CHUIScrollViewScrollDirection)direction;

/**
 滑动到顶部(默认动画)
 */
- (void)ch_scrollToTop;

/**
 滑动到底部(默认动画)
 */
- (void)ch_scrollToBottom;

/**
 滑动到左边(默认动画)
 */
- (void)ch_scrollToLeft;

/**
 滑动到右边(默认动画)
 */
- (void)ch_scrollToRight;

/**
 滑动到右边

 @param animated 动画
 */
- (void)ch_scrollToTop:(BOOL)animated;

/**
 滑动到底部

 @param animated 动画
 */
- (void)ch_scrollToBottom:(BOOL)animated;

/**
 滑动到左边

 @param animated 动画
 */
- (void)ch_scrollToLeft:(BOOL)animated;

/**
 滑动到右边

 @param animated 动画
 */
- (void)ch_scrollToRight:(BOOL)animated;

/**
 设置滑动偏移位置(类似setContentOffset:animated:, 避免重复调用)

 @param contentOffset 偏移位置
 @param animated      动画
 */
- (void)ch_setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

/**
 停止减速滑动
 */
- (void)ch_endDecelerating;

@end

NS_ASSUME_NONNULL_END
