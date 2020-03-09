//
//  UIView+CHBase.m
//  CHCategories
//
//  Created by CHwang on 16/12/31.
//  Copyright © 2016年 Colin. All rights reserved.
//

#import "UIView+CHBase.h"
#import "NSArray+CHBase.h"
#import "UIGestureRecognizer+CHBase.h"

@implementation UIView (CHBase)

#pragma mark - Base
- (CGFloat)ch_visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    
    if (!self.window) return 0;
    
    CGFloat alpha = 1;
    UIView *view = self;
    while (view) {
        if (view.hidden) {
            alpha = 0;
            break;
        }
        
        alpha *= view.alpha;
        view = view.superview;
    }
    return alpha;
}

- (UIView *)ch_topSuperView {
    UIView *topSuperView = self.superview;
    
    if (topSuperView == nil) {
        topSuperView = self;
    } else {
        while (topSuperView.superview) {
            topSuperView = topSuperView.superview;
        }
    }
    
    return topSuperView;
}

- (UIViewController *)ch_viewController {
    // 遍历自身及superview
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder]; // 响应链
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)ch_bringToFront {
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
}

- (void)ch_sendToBack {
    if (self.superview) {
        [self.superview sendSubviewToBack:self];
    }
}

- (void)ch_removeSubview:(UIView *)subview {
    if ([self.subviews containsObject:subview]) {
        [subview removeFromSuperview];
    }
}

- (void)ch_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (BOOL)ch_containsSubview:(UIView *)subview {
    if (!subview) return NO;
    if (![subview isKindOfClass:[UIView class]]) return NO;
    if (!subview.superview) return NO;
    if (!self.subviews.count) return NO;
    
    return [self.subviews ch_containsObjectAtIndexes:self.subviews.ch_indexesOfAll options:kNilOptions recursive:YES usingBlock:^BOOL(id  _Nonnull obj, NSIndexPath * _Nonnull indexPath, NSUInteger idx) {
        if ([obj isEqual:subview]) return YES;
        
        return NO;
    }];
}

#pragma mark - Layout
- (CGFloat)ch_x {
    return self.frame.origin.x;
}

- (void)setCh_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)ch_y {
    return self.frame.origin.y;
}

- (void)setCh_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGPoint)ch_origin {
    return self.frame.origin;
}

- (void)setCh_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)ch_width {
    return self.frame.size.width;
}

- (void)setCh_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)ch_height {
    return self.frame.size.height;
}

- (void)setCh_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)ch_size {
    return self.frame.size;
}

- (void)setCh_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)ch_centerX {
    return self.center.x;
}

- (void)setCh_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)ch_centerY {
    return self.center.y;
}

- (void)setCh_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)ch_left {
    return self.frame.origin.x;
}

- (void)setCh_left:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)ch_top {
    return self.frame.origin.y;
}

- (void)setCh_top:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)ch_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setCh_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ch_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setCh_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)ch_originXEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.ch_origin toView:self.ch_topSuperView];
    CGPoint newOrigin = [self.ch_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.ch_x = newOrigin.x;
}

- (void)ch_originYEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.ch_origin toView:self.ch_topSuperView];
    CGPoint newOrigin = [self.ch_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.ch_y = newOrigin.y;
}

- (void)ch_originEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.ch_origin toView:self.ch_topSuperView];
    CGPoint newOrigin = [self.ch_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.ch_origin = newOrigin;
}

- (void)ch_widthEqualToView:(UIView *)view {
    self.ch_width = view.ch_width;
}

- (void)ch_heightEqualToView:(UIView *)view {
    self.ch_height = view.ch_height;
}

- (void)ch_sizeEqualToView:(UIView *)view {
    self.ch_size = view.ch_size;
}

- (void)ch_centerXEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.ch_topSuperView];
    CGPoint centerPoint = [self.ch_topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.ch_centerX = centerPoint.x;
}

- (void)ch_centerYEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.ch_topSuperView];
    CGPoint centerPoint = [self.ch_topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.ch_centerY = centerPoint.y;
}

- (void)ch_centerEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.ch_topSuperView];
    CGPoint centerPoint = [self.ch_topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.ch_centerX = centerPoint.x;
    self.ch_centerY = centerPoint.y;
}

- (void)ch_leftEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.ch_origin toView:self.ch_topSuperView];
    CGPoint newOrigin = [self.ch_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.ch_x = newOrigin.x;
}

- (void)ch_topEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.ch_origin toView:self.ch_topSuperView];
    CGPoint newOrigin = [self.ch_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.ch_y = newOrigin.y;
}

- (void)ch_rightEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.ch_origin toView:self.ch_topSuperView];
    CGPoint newOrigin = [self.ch_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.ch_x = newOrigin.x + view.ch_width - self.ch_width;
}

- (void)ch_bottomEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.ch_origin toView:self.ch_topSuperView];
    CGPoint newOrigin = [self.ch_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.ch_y = newOrigin.y + view.ch_height - self.ch_height;
}

#pragma mark - Convert
- (CGPoint)ch_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)ch_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)ch_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)ch_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}

#pragma mark - Count Down
- (void)ch_changeWithCountDown:(NSInteger)seconds countDownHandler:(void (^)(id sender, NSInteger second, BOOL finished))countDownHandler {
    //倒计时时间
    __block NSInteger timeOut = seconds;
    __block BOOL finished = NO;
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        NSInteger second = timeOut;
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                finished = YES;
                !countDownHandler?:countDownHandler(weakSelf, second, finished);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                !countDownHandler?:countDownHandler(weakSelf, second, finished);
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Nib
+ (instancetype)ch_viewFromNib {
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (instancetype)ch_viewFromNib:(NSString *)name {
    return  [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject];
}

#pragma mark - Shadow
- (void)ch_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - Snapshot
- (UIImage *)ch_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

- (UIImage *)ch_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self ch_snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

#pragma mark - Gesture Recognizer
- (UITapGestureRecognizer *)ch_addTapGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UITapGestureRecognizer *)ch_addTapGestureRecognizerWithActionBlock:(void (^)(id sender))block {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:block];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UIPinchGestureRecognizer *)ch_addPinchGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UIPinchGestureRecognizer *)ch_addPinchGestureRecognizerWithActionBlock:(void (^)(id sender))block {
    UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithActionBlock:block];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UIRotationGestureRecognizer *)ch_addRotationGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UIRotationGestureRecognizer *recognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UIRotationGestureRecognizer *)ch_addRotationGestureRecognizerWithActionBlock:(void (^)(id sender))block {
    UIRotationGestureRecognizer *recognizer = [[UIRotationGestureRecognizer alloc] initWithActionBlock:block];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UISwipeGestureRecognizer *)ch_addSwipeGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UISwipeGestureRecognizer *)ch_addSwipeGestureRecognizerWithActionBlock:(void (^)(id sender))block {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithActionBlock:block];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UIPanGestureRecognizer *)ch_addPanGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UIPanGestureRecognizer *)ch_addPanGestureRecognizerWithActionBlock:(void (^)(id sender))block {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithActionBlock:block];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UIScreenEdgePanGestureRecognizer *)ch_addScreenEdgePanGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UIScreenEdgePanGestureRecognizer *)ch_addScreenEdgePanGestureRecognizerWithActionBlock:(void (^)(id sender))block {
    UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithActionBlock:block];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UILongPressGestureRecognizer *)ch_addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UILongPressGestureRecognizer *)ch_addLongPressGestureRecognizerWithActionBlock:(void (^)(id sender))block {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithActionBlock:block];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

@end
