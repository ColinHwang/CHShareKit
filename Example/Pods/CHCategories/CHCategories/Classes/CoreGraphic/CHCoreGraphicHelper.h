//
//  CHCoreGraphicHelper.h
//  Pods
//
//  Created by CHwang on 17/1/9.
//

#import <Foundation/Foundation.h>

#if defined(__LP64__) && __LP64__
# define CHCGFLOAT_EPSILON DBL_EPSILON
#else
# define CHCGFLOAT_EPSILON FLT_EPSILON
#endif

typedef NS_ENUM(NSInteger, CHCGPointQuadrant) { ///< 点相对矩形中心点所处的象限
    CHCGPointQuadrantOrigin = 0,                ///< 原点
    CHCGPointQuadrantFirst  = 1,                ///< 第一象限
    CHCGPointQuadrantSecond = 2,                ///< 第二象限
    CHCGPointQuadrantThird  = 3,                ///< 第三象限
    CHCGPointQuadrantForth  = 4,                ///< 第四象限
};

#pragma mark - Info
/**
 获取屏幕的Scale
 
 @return 屏幕的Scale
 */
CGFloat CHScreenScale(void);


/**
 获取屏幕的尺寸
 
 @return 屏幕的尺寸
 */
CGSize CHScreenSize(void);

#pragma mark - Utilities
/**
 判断两个CGFloat值是否相等

 @param float1 float1
 @param float2 float2
 @return 相等返回YES, 否则返回NO
 */
CG_INLINE BOOL CHCGFloatEqualeToFloat(CGFloat float1, CGFloat float2) {
    return float1 == float2 || fabs(float1 - float2) < __FLT_EPSILON__;
}

/**
 将角度值转换为弧度值

 @param degrees 角度值
 @return 弧度值
 */
CG_INLINE CGFloat CHDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/**
 将弧度值转换为角度值

 @param radians 弧度值
 @return 角度值
 */
CG_INLINE CGFloat CHRadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

/**
 反转UIEdgeInsets

 @param insets 原UIEdgeInsets
 @return 反转后的UIEdgeInsets
 */
CG_INLINE UIEdgeInsets CHUIEdgeInsetsInvert(UIEdgeInsets insets) {
    return UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
}

/**
 获取UIEdgeInsets在水平方向的值
 
 @param insets UIEdgeInsets
 @return UIEdgeInsets在水平方向的值
 */
CG_INLINE CGFloat CHUIEdgeInsetsGetValuesInHorizontal(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/**
 获取UIEdgeInsets在垂直方向的值

 @param insets UIEdgeInsets
 @return UIEdgeInsets在垂直方向的值
 */
CG_INLINE CGFloat CHUIEdgeInsetsGetValuesInVertical(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

/**
 判断尺寸是否为空(长或宽小于等于0)
 
 @param size 尺寸
 @return 为空返回YES, 否则返回NO(长或宽小于等于0)
 */
CG_INLINE BOOL CHCGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}


/**
 根据尺寸创建CGRect

 @param size 尺寸
 @return CGRect
 */
CG_INLINE CGRect CHCGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

/**
 设置Rect的X值

 @param rect Rect
 @param x X值
 @return CGRect
 */
CG_INLINE CGRect CHCGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = x;
    return rect;
}

/**
 设置Rect的Y值

 @param rect Rect
 @param y Y值
 @return CGRect
 */
CG_INLINE CGRect CHCGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = y;
    return rect;
}

/**
 设置Rect的宽度

 @param rect Rect
 @param width 宽度
 @return CGRect
 */
CG_INLINE CGRect CHCGRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = width;
    return rect;
}

/**
 设置Rect的高度

 @param rect Rect
 @param height 宽度
 @return CGRect
 */
CG_INLINE CGRect CHCGRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = height;
    return rect;
}

/**
 根据宽度偏移量及高度偏移量, 伸缩Rect

 @param rect Rect
 @param widthOffset 宽度偏移量
 @param heightOffset 高度偏移量
 @return CGRect
 */
CG_INLINE CGRect CHCGRectStretch(CGRect rect, CGFloat widthOffset, CGFloat heightOffset) {
    rect.size.width += widthOffset;
    rect.size.height += heightOffset;
    return rect;
}

/**
 判断Rect是否包含特定的Point(类似`CGRectContainsPoint()`, 边界点亦判断包含)

 @param rect Rect
 @param point Point
 @return 包含返回YES, 否则返回NO
 */
CG_INLINE BOOL CHCGRectContainsPoint(CGRect rect, CGPoint point) {
   return point.x <= CGRectGetMaxX(rect) && point.x >= CGRectGetMinX(rect) && point.y <= CGRectGetMaxY(rect) && point.y >= CGRectGetMinY(rect);
}

/**
 获取矩形的中心点

 @param rect 矩形
 @return 矩形rect的中心点
 */
CG_INLINE CGPoint CHCGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/**
 获取矩形的面积

 @param rect 矩形
 @return 矩形的面积
 */
CG_INLINE CGFloat CHCGRectGetArea(CGRect rect) {
    if (CGRectIsNull(rect)) return 0;
    rect = CGRectStandardize(rect); // 根据一个矩形创建一个标准的矩形
    return rect.size.width * rect.size.height;
}

/**
 判断矩形是否为正方形

 @param rect 矩形
 @return 是返回YES, 否则返回NO
 */
CG_INLINE BOOL CHCGRectIsSquare(CGRect rect) {
    if (CGRectIsNull(rect)) return NO;
    if (CGRectIsEmpty(rect)) return NO;
    
    rect = CGRectStandardize(rect);
    return rect.size.width == rect.size.height;
}

/**
 获取矩形中间的正方形(无法获取, 返回CGRectZero)

 @param rect 矩形
 @return 正方形的矩形(无法获取, 返回CGRectZero)
 */
CG_INLINE CGRect CHCGRectGetCenterSquareRect(CGRect rect) {
    if (CGRectIsNull(rect)) return CGRectZero;
    if (CGRectIsEmpty(rect)) return CGRectZero;
    
    rect = CGRectStandardize(rect);
    CGFloat rectX = rect.origin.x, rectY = rect.origin.y, rectWidth = rect.size.width, rectHeight = rect.size.height;
    
    if (rectWidth > rectHeight) {
        rectX = (rectWidth - rectHeight)/2;
        rectWidth = rectHeight;
    } else if (rectWidth < rectHeight) {
        rectY = (rectHeight - rectWidth)/2;
        rectHeight = rectWidth;
    }
    
    return CGRectMake(rectX, rectY, rectWidth, rectHeight);
}

/**
 获取两点的直线距离

 @param point1 point1
 @param point2 point2
 @return 两点的直线距离
 */
CG_INLINE CGFloat CHCGPointGetDistanceToPoint(CGPoint point1, CGPoint point2) {
    return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
}

/**
 获取点到矩形的最小距离(垂直/水平)

 @param point 点
 @param rect 矩形
 @return 点到矩形的最小距离
 */
CG_INLINE CGFloat CHCGPointGetDistanceToRect(CGPoint point, CGRect rect) {
    rect = CGRectStandardize(rect);
    if (CGRectContainsPoint(rect, point)) return 0; //  Rect是否包含Point
    CGFloat distV, distH; // 垂直距离, 水平距离
    // Point in [rect.origin.y, rect.origin.y + rect.size.height]
    if (CGRectGetMinY(rect) <= point.y && point.y <= CGRectGetMaxY(rect)) {
        distV = 0;
    } else {
        distV = point.y < CGRectGetMinY(rect) ? CGRectGetMinY(rect) - point.y : point.y - CGRectGetMaxY(rect); // Rect上/下
    }
    
    // Point in [rect.origin.x, rect.origin.x + rect.size.width]
    if (CGRectGetMinX(rect) <= point.x && point.x <= CGRectGetMaxX(rect)) {
        distH = 0;
    } else {
        distH = point.x < CGRectGetMinX(rect) ? CGRectGetMinX(rect) - point.x : point.x - CGRectGetMaxX(rect); // Rect左/右
    }
    return MAX(distV, distH); // (0, 10) -> 10; (10, 20) -> 20
}

/**
 获取某点相对于矩形中心点所处的象限

 @param point 点
 @param rect 矩形
 @return 点相对于矩形中心点所处的象限
 */
CG_INLINE CHCGPointQuadrant CHCGPointQuadrantInRect(CGPoint point, CGRect rect) {
    CGPoint mid = CHCGRectGetCenter(rect);
    if (point.x > mid.x) {
        if (point.y < mid.y) return CHCGPointQuadrantFirst;
        if (point.y > mid.y) return CHCGPointQuadrantForth;
    }

    if (point.x < mid.x) {
        if (point.y < mid.y) return CHCGPointQuadrantSecond;
        if (point.y > mid.y) return CHCGPointQuadrantThird;
    }
    return CHCGPointQuadrantOrigin;
}

#pragma mark - Point & Pixel
/**
 将PT值转为像素值

 @param value PT值
 @return 像素值
 */
CG_INLINE CGFloat CHCGFloatToPixel(CGFloat value) {
    return value * CHScreenScale();
}

/**
 将像素值转为PT值

 @param value 像素值
 @return PT值
 */
CG_INLINE CGFloat CHCGFloatFromPixel(CGFloat value) {
    return value / CHScreenScale();
}

/**
 向下取整像素值对应的PT值(像素对齐)

 @param value 像素值
 @return PT值(像素对齐)
 */
CG_INLINE CGFloat CHCGFloatPixelFloor(CGFloat value) {
    CGFloat scale = CHScreenScale();
    return floor(value * scale) / scale;
}

/**
 四舍五入像素值对应的PT值(像素对齐)

 @param value 像素值
 @return PT值(像素对齐)
 */
CG_INLINE CGFloat CHCCGFloatPixelRound(CGFloat value) {
    CGFloat scale = CHScreenScale();
    return round(value * scale) / scale;
}

/**
 向上取整像素值对应的PT值(像素对齐)

 @param value 像素值
 @return PT值(像素对齐)
 */
CG_INLINE CGFloat CHCGFloatPixelCeil(CGFloat value) {
    CGFloat scale = CHScreenScale();
    return ceil(value * scale) / scale;
}

/**
 round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)

 @param value 像素值
 @return PT值(像素对齐)
 */
CG_INLINE CGFloat CHCCGFloatPixelHalf(CGFloat value) {
    CGFloat scale = CHScreenScale();
    return (floor(value * scale) + 0.5) / scale;
}


/**
 floor point value for pixel-aligned

 @param point CGPoint 像素值
 @return CGPoint PT值(像素对齐)
 */
CG_INLINE CGPoint CHCGPointPixelFloor(CGPoint point) {
    CGFloat scale = CHScreenScale();
    return CGPointMake(floor(point.x * scale) / scale,
                       floor(point.y * scale) / scale);
}

/**
 round point value for pixel-aligned

 @param point CGPoint 像素值
 @return PT值(像素对齐)
 */
CG_INLINE CGPoint CHCGPointPixelRound(CGPoint point) {
    CGFloat scale = CHScreenScale();
    return CGPointMake(round(point.x * scale) / scale,
                       round(point.y * scale) / scale);
}

/**
 ceil point value for pixel-aligned

 @param point CGPoint 像素值
 @return PT值(像素对齐)
 */
CG_INLINE CGPoint CHCGPointPixelCeil(CGPoint point) {
    CGFloat scale = CHScreenScale();
    return CGPointMake(ceil(point.x * scale) / scale,
                       ceil(point.y * scale) / scale);
}

/**
 round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)

 @param point CGPoint 像素值
 @return PT值(像素对齐)
 */
CG_INLINE CGPoint CHCGPointPixelHalf(CGPoint point) {
    CGFloat scale = CHScreenScale();
    return CGPointMake((floor(point.x * scale) + 0.5) / scale,
                       (floor(point.y * scale) + 0.5) / scale);
}

/// floor point value for pixel-aligned
CG_INLINE CGSize CHCGSizePixelFloor(CGSize size) {
    CGFloat scale = CHScreenScale();
    return CGSizeMake(floor(size.width * scale) / scale,
                      floor(size.height * scale) / scale);
}

/**
 round point value for pixel-aligned

 @param size CGSize 像素值
 @return CGSize PT值(像素对齐)
 */
CG_INLINE CGSize CHCGSizePixelRound(CGSize size) {
    CGFloat scale = CHScreenScale();
    return CGSizeMake(round(size.width * scale) / scale,
                      round(size.height * scale) / scale);
}

/**
 ceil point value for pixel-aligned

 @param size CGSize 像素值
 @return CGSize PT值(像素对齐)
 */
CG_INLINE CGSize CHCGSizePixelCeil(CGSize size) {
    CGFloat scale = CHScreenScale();
    return CGSizeMake(ceil(size.width * scale) / scale,
                      ceil(size.height * scale) / scale);
}

/**
 round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)

 @param size CGSize 像素值
 @return CGSize PT值(像素对齐)
 */
CG_INLINE CGSize CHCGSizePixelHalf(CGSize size) {
    CGFloat scale = CHScreenScale();
    return CGSizeMake((floor(size.width * scale) + 0.5) / scale,
                      (floor(size.height * scale) + 0.5) / scale);
}

/**
 floor point value for pixel-aligned

 @param rect CGRect 像素值
 @return CGRect PT值(像素对齐)
 */
CG_INLINE CGRect CHCGRectPixelFloor(CGRect rect) {
    CGPoint origin = CHCGPointPixelCeil(rect.origin);
    CGPoint corner = CHCGPointPixelFloor(CGPointMake(rect.origin.x + rect.size.width,
                                                   rect.origin.y + rect.size.height));
    CGRect ret = CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
    if (ret.size.width < 0) ret.size.width = 0;
    if (ret.size.height < 0) ret.size.height = 0;
    return ret;
}

/**
 round point value for pixel-aligned

 @param rect CGRect 像素值
 @return CGRect PT值(像素对齐)
 */
CG_INLINE CGRect CHCGRectPixelRound(CGRect rect) {
    CGPoint origin = CHCGPointPixelRound(rect.origin);
    CGPoint corner = CHCGPointPixelRound(CGPointMake(rect.origin.x + rect.size.width,
                                                   rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/**
 ceil point value for pixel-aligned

 @param rect CGRect 像素值
 @return CGRect PT值(像素对齐)
 */
CG_INLINE CGRect CHCGRectPixelCeil(CGRect rect) {
    CGPoint origin = CHCGPointPixelFloor(rect.origin);
    CGPoint corner = CHCGPointPixelCeil(CGPointMake(rect.origin.x + rect.size.width,
                                                  rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/**
 round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)

 @param rect CGRect 像素值
 @return CGRect PT值(像素对齐)
 */
CG_INLINE CGRect CHCGRectPixelHalf(CGRect rect) {
    CGPoint origin = CHCGPointPixelHalf(rect.origin);
    CGPoint corner = CHCGPointPixelHalf(CGPointMake(rect.origin.x + rect.size.width,
                                                  rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/**
 floor UIEdgeInset for pixel-aligned

 @param insets UIEdgeInset 像素值
 @return UIEdgeInset PT值(像素对齐)
 */
CG_INLINE UIEdgeInsets CHUIEdgeInsetPixelFloor(UIEdgeInsets insets) {
    insets.top = CHCGFloatPixelFloor(insets.top);
    insets.left = CHCGFloatPixelFloor(insets.left);
    insets.bottom = CHCGFloatPixelFloor(insets.bottom);
    insets.right = CHCGFloatPixelFloor(insets.right);
    return insets;
}

/**
 ceil UIEdgeInset for pixel-aligned

 @param insets UIEdgeInset 像素值
 @return UIEdgeInset PT值(像素对齐)
 */
CG_INLINE UIEdgeInsets CHUIEdgeInsetPixelCeil(UIEdgeInsets insets) {
    insets.top = CHCGFloatPixelCeil(insets.top);
    insets.left = CHCGFloatPixelCeil(insets.left);
    insets.bottom = CHCGFloatPixelCeil(insets.bottom);
    insets.right = CHCGFloatPixelCeil(insets.right);
    return insets;
}

#pragma mark - UIViewContent
/**
 根据CALayer的gravity, 转化为与之对应的UIViewContentMode
 
 @param gravity layer的contentsGravity
 @return 对应的UIViewContentMode
 */
UIViewContentMode CHCAGravityToUIViewContentMode(NSString *gravity);

/**
 根据UIViewContentMode, 转化为与之对应的CALayer的gravity

 @param contentMode UIViewContentMode
 @return 对应的CALayer的contentsGravity
 */
NSString *CHUIViewContentModeToCAGravity(UIViewContentMode contentMode);

/**
 根据contentMode和内容尺寸, 调整并适配绘制Rect

 @param rect 绘制Rect
 @param size 内容尺寸
 @param mode contentMode(UIViewContentModeRedraw == UIViewContentModeScaleToFill)
 @return 调整后的Rect
 */
CGRect CHCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);
