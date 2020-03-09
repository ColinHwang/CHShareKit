//
//  UIView+CHBase.h
//  CHCategories
//
//  Created by CHwang on 16/12/31.
//  Copyright © 2016年 Colin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CHBase)

#pragma mark - Base
/**
 View可见的Alpha值(综合考虑Subview及Window情况)
 */
@property (nonatomic, readonly) CGFloat ch_visibleAlpha;

/**
 View最顶部的SuperView(无则为self)
 */
@property (nonatomic, readonly) UIView *ch_topSuperView;

/**
 View所属的ViewController(或为nil)
 */
@property (nullable, nonatomic, readonly) UIViewController *ch_viewController;

/**
 将View移动到父View的最前面
 */
- (void)ch_bringToFront;

/**
 将View移动到父View的最后面
 */
- (void)ch_sendToBack;

/**
 移除View内指定的Subview(勿在view的drawRect:方法内调用此方法)

 @param subview 指定的Subview
 */
- (void)ch_removeSubview:(UIView *)subview;

/**
 移除所有Subviews(勿在view的drawRect:方法内调用此方法)
 */
- (void)ch_removeAllSubviews;

/**
 判断View是否包含指定的子视图(递归遍历子视图)

 @param subview 指定的子视图
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsSubview:(UIView *)subview;

#pragma mark - Layout
@property (nonatomic, assign) CGFloat ch_x;       ///< self.frame.origin.x
@property (nonatomic, assign) CGFloat ch_y;       ///< self.frame.origin.y
@property (nonatomic, assign) CGPoint ch_origin;  ///< self.frame.origin
@property (nonatomic, assign) CGFloat ch_width;   ///< self.frame.size.width
@property (nonatomic, assign) CGFloat ch_height;  ///< self.frame.size.height
@property (nonatomic, assign) CGSize  ch_size;    ///< self.frame.size
@property (nonatomic, assign) CGFloat ch_centerX; ///< self.center.x
@property (nonatomic, assign) CGFloat ch_centerY; ///< self.center.y
@property (nonatomic, assign) CGFloat ch_left;    ///< self.frame.origin.x
@property (nonatomic, assign) CGFloat ch_top;     ///< self.frame.origin.y
@property (nonatomic, assign) CGFloat ch_right;   ///< self.frame.origin.x + self.frame.size.width
@property (nonatomic, assign) CGFloat ch_bottom;  ///< self.frame.origin.y + self.frame.size.height

- (void)ch_originXEqualToView:(UIView *)view;
- (void)ch_originYEqualToView:(UIView *)view;
- (void)ch_originEqualToView:(UIView *)view;

- (void)ch_widthEqualToView:(UIView *)view;
- (void)ch_heightEqualToView:(UIView *)view;
- (void)ch_sizeEqualToView:(UIView *)view;

- (void)ch_centerXEqualToView:(UIView *)view;
- (void)ch_centerYEqualToView:(UIView *)view;
- (void)ch_centerEqualToView:(UIView *)view;

- (void)ch_leftEqualToView:(UIView *)view;
- (void)ch_topEqualToView:(UIView *)view;
- (void)ch_rightEqualToView:(UIView *)view;
- (void)ch_bottomEqualToView:(UIView *)view;

#pragma mark - Convert
/**
  将Point由Point所在视图转换到目标视图View或Window中

 @param point Point
 @param view 目标视图view或window
 @return 在目标视图view中或window的point
 */
- (CGPoint)ch_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view;

/**
 将Point从Point所在View或Window中转换到当前视图中

 @param point Point
 @param view Point所在View或Window
 @return 在当前视图中的Point值
 */
- (CGPoint)ch_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;

/**
 将Rect由Rect所在视图转换到目标视图View或Window中

 @param rect Rect
 @param view 目标视图View或Window
 @return 在目标视图View中或Window的Rect
 */
- (CGRect)ch_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view;

/**
 将Rect从Rect所在View或Window中转换到当前视图中

 @param rect Rect
 @param view Rect所在View或Window
 @return 在当前视图中的Rect值
 */
- (CGRect)ch_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view;

#pragma mark - Count Down
/**
 根据倒计时间及倒计回调处理, 改变View
 
 @param seconds 倒计时间
 @param countDownHandler 倒计回调处理(每秒执行一次回调, 当且仅当倒计结束, finished为YES)
 */
- (void)ch_changeWithCountDown:(NSInteger)seconds countDownHandler:(void (^)(id sender, NSInteger second, BOOL finished))countDownHandler;

#pragma mark - Nib
/**
 根据Nib文件名(当前View类名)，创建对应的View(MainBundle, 或为nil)
 
 @return View
 */
+ (instancetype)ch_viewFromNib;

/**
 根据Nib文件名，创建对应的View(MainBundle, 或为nil)
 
 @param name Nib文件名
 @return View
 */
+ (instancetype)ch_viewFromNib:(NSString *)name;

#pragma mark - Shadow
/**
 设置View的阴影
 
 @param color  阴影颜色
 @param offset 阴影偏移量
 @param radius 阴影角度
 */
- (void)ch_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

#pragma mark - Snapshot
/**
 获取当前View截图
 
 @return 当前View截图
 */
- (UIImage *)ch_snapshotImage;

/**
 获取当前View截图(当前屏幕所有重绘操作完成后截图)
 
 @param afterUpdates 是否在屏幕完成所有重绘操作后截屏
 @return 当前view截图
 */
- (UIImage *)ch_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

#pragma mark - Gesture Recognizer
/**
 根据Target及Action, 添加点按手势

 @param target Target
 @param action Action
 @return 点按手势
 */
- (UITapGestureRecognizer *)ch_addTapGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 根据手势回调事件, 添加点按手势

 @param block 手势回调事件
 @return 点按手势
 */
- (UITapGestureRecognizer *)ch_addTapGestureRecognizerWithActionBlock:(void (^)(id sender))block;

/**
 根据Target及Action, 添加捏合手势
 
 @param target Target
 @param action Action
 @return 捏合手势
 */
- (UIPinchGestureRecognizer *)ch_addPinchGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 根据手势回调事件, 添加捏合手势
 
 @param block 手势回调事件
 @return 捏合手势
 */
- (UIPinchGestureRecognizer *)ch_addPinchGestureRecognizerWithActionBlock:(void (^)(id sender))block;
/**
 根据Target及Action, 添加旋转手势
 
 @param target Target
 @param action Action
 @return 旋转手势
 */
- (UIRotationGestureRecognizer *)ch_addRotationGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 根据手势回调事件, 添加旋转手势
 
 @param block 手势回调事件
 @return 旋转手势
 */
- (UIRotationGestureRecognizer *)ch_addRotationGestureRecognizerWithActionBlock:(void (^)(id sender))block;

/**
 根据Target及Action, 添加轻扫手势
 
 @param target Target
 @param action Action
 @return 轻扫手势
 */
- (UISwipeGestureRecognizer *)ch_addSwipeGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 根据手势回调事件, 添加轻扫手势
 
 @param block 手势回调事件
 @return 轻扫手势
 */
- (UISwipeGestureRecognizer *)ch_addSwipeGestureRecognizerWithActionBlock:(void (^)(id sender))block;

/**
 根据Target及Action, 添加拖动手势
 
 @param target Target
 @param action Action
 @return 拖动手势
 */
- (UIPanGestureRecognizer *)ch_addPanGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 根据手势回调事件, 添加拖动手势
 
 @param block 手势回调事件
 @return 拖动手势
 */
- (UIPanGestureRecognizer *)ch_addPanGestureRecognizerWithActionBlock:(void (^)(id sender))block;

/**
 根据Target及Action, 添加屏幕边缘拖动手势
 
 @param target Target
 @param action Action
 @return 屏幕边缘拖动手势
 */
- (UIScreenEdgePanGestureRecognizer *)ch_addScreenEdgePanGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 根据手势回调事件, 添加屏幕边缘拖动手势
 
 @param block 手势回调事件
 @return 屏幕边缘拖动手势
 */
- (UIScreenEdgePanGestureRecognizer *)ch_addScreenEdgePanGestureRecognizerWithActionBlock:(void (^)(id sender))block;

/**
 根据Target及Action, 添加长按手势
 
 @param target Target
 @param action Action
 @return 长按手势
 */
- (UILongPressGestureRecognizer *)ch_addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 根据手势回调事件, 添加长按手势
 
 @param block 手势回调事件
 @return 长按手势
 */
- (UILongPressGestureRecognizer *)ch_addLongPressGestureRecognizerWithActionBlock:(void (^)(id sender))block;

@end

NS_ASSUME_NONNULL_END
