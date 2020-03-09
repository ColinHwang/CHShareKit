//
//  CALayer+CHBase.h
//  CHCategories
//
//  Created by CHwang on 17/1/6.
//  Base

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@class UIColor, UIImage;

@interface CALayer (CHBase)

#pragma mark - Base
/**
 根据Layer的contentsGravity属性, 获取其对应的contentMode
 */
@property (nonatomic) UIViewContentMode ch_contentMode;

/**
 根据Index, 交换指定的Sublayer的位置

 @param index1 Sublayer对应的Index
 @param index2 Sublayer对应的Index
 */
- (void)ch_exchangeSublayerAtIndex:(unsigned)index1 withSublayerAtIndex:(unsigned)index2;

/**
 把指定的Sublayer移动到当前所有Sublayers的最前面(Sublayer须已添加到当前Layer上)

 @param sublayer 指定的Sublayer
 */
- (void)ch_bringSublayerToFront:(CALayer *)sublayer;

/**
 把指定的Sublayer移动到当前所有Sublayers的最后面(Sublayer须已添加到当前Layer上)

 @param sublayer 指定的Sublayer
 */
- (void)ch_sendSublayerToBack:(CALayer *)sublayer;

/**
 将Layer移动到父Layer的最前面
 */
- (void)ch_bringToFront;

/**
 将Layer移动到父Layer的最后面
 */
- (void)ch_sendToBack;

/**
 移除Layer内指定的Sublayer(勿在layer的drawInContext:方法内调用此方法)

 @param sublayer 指定的Sublayer
 */
- (void)ch_removeSublayer:(CALayer *)sublayer;

/**
 移除所有子Layers(勿在layer的drawInContext:方法内调用此方法)
 */
- (void)ch_removeAllSublayers;

#pragma mark - Layout
@property (nonatomic) CGFloat ch_x;                                                 ///< Layer的x值 -> self.frame.origin.x
@property (nonatomic) CGFloat ch_y;                                                 ///< Layer的y值 -> self.frame.origin.y
@property (nonatomic) CGPoint ch_origin;                                            ///< Layer的origin值 -> self.frame.origin
@property (nonatomic) CGFloat ch_width;                                             ///< Layer的width值 -> self.frame.size.width
@property (nonatomic) CGFloat ch_height;                                            ///< Layer的height值 -> self.frame.size.height
@property (nonatomic, getter=ch_frameSize, setter=setCh_frameSize:) CGSize ch_size; ///< Layer的size值 -> self.frame.size
@property (nonatomic) CGFloat ch_centerX;                                           ///< Layer的center值 -> self.center
@property (nonatomic) CGFloat ch_centerY;                                           ///< Layer的centerX值 -> self.center.x
@property (nonatomic) CGPoint ch_center;                                            ///< Layer的centerY值 -> self.center.y
@property (nonatomic) CGFloat ch_left;                                              ///< self.frame.origin.x
@property (nonatomic) CGFloat ch_top;                                               ///< self.frame.origin.y
@property (nonatomic) CGFloat ch_right;                                             ///< self.frame.origin.x + self.frame.size.width
@property (nonatomic) CGFloat ch_bottom;                                            ///< self.frame.origin.y + self.frame.size.height

#pragma mark - Shadow
/**
 设置layer阴影
 
 @param color  阴影颜色
 @param offset 阴影偏移量
 @param radius 阴影角度
 */
- (void)ch_setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 设置layer阴影
 
 @param color   阴影颜色
 @param offset  阴影偏移量
 @param radius  阴影角度
 @param opacity 阴影透明度
 */
- (void)ch_setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;

#pragma mark - Snapshot
/**
 获取当前layer截图(无视transform, 根据bouns截图)
 
 @return 当前layer截图
 */
- (UIImage *)ch_snapshotImage;

@end

NS_ASSUME_NONNULL_END
