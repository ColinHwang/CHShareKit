//
//  UIImage+CHImageEffect.h
//  CHCategories
//
//  Created by CHwang on 2019/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGPoint CHUIImageGradientPointTop;        ///< 上{0.5, 0}
UIKIT_EXTERN const CGPoint CHUIImageGradientPointBottom;     ///< 下{0.5, 1}
UIKIT_EXTERN const CGPoint CHUIImageGradientPointLeft;       ///< 左{1, 0.5}
UIKIT_EXTERN const CGPoint CHUIImageGradientPointRight;      ///< 右{0.5, 0}
UIKIT_EXTERN const CGPoint CHUIImageGradientPointCenter;     ///< 中心{0.5, 0.5}
UIKIT_EXTERN const CGPoint CHUIImageGradientPointUpperLeft;  ///< 左上角{0, 0}
UIKIT_EXTERN const CGPoint CHUIImageGradientPointLowerLeft;  ///< 左下角{0, 1}
UIKIT_EXTERN const CGPoint CHUIImageGradientPointUpperRight; ///< 右上角{1, 0}
UIKIT_EXTERN const CGPoint CHUIImageGradientPointLowerRight; ///< 右下角{1, 1}

typedef NS_ENUM(NSInteger, CHUIImageCropStyle) {  ///< 裁切类型
    CHUIImageCropStyleLeft = 0,                   ///< 左半部分
    CHUIImageCropStyleRight,                      ///< 右半部分
    CHUIImageCropStyleCenter,                     ///< 中间部分
    CHUIImageCropStyleTop,                        ///< 上半部分
    CHUIImageCropStyleBottom,                     ///< 下半部分
};

typedef NS_OPTIONS(NSUInteger, CHUIImageBorderStyle) { ///< 边框风格
    CHUIImageBorderStyleTop    = 1 << 0,               ///< 上边框
    CHUIImageBorderStyleLeft   = 1 << 1,               ///< 左边框
    CHUIImageBorderStyleBottom = 1 << 2,               ///< 下边框
    CHUIImageBorderStyleRight  = 1 << 3,               ///< 右边框
    CHUIImageBorderStyleAll    = ~0UL,                 ///< 全部边框
};

@interface UIImage (CHImageEffect)

#pragma mark - Blurred Image
/**
 返回一张带灰度滤镜的图片(error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByGrayscale;

/**
 返回一张带模糊滤镜的图片(柔光, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByBlurSoft;

/**
 返回一张带模糊滤镜的图片(白亮, 类似iOS控制台, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByBlurLight;

/**
 返回一张带模糊滤镜的图片(特亮, 类似iOSNavigationBar白色, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByBlurExtraLight;

/**
 返回一张带模糊滤镜的图片(暗度, 类似iOS通知中心, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByBlurDark;

/**
 根据着色颜色, 返回一张带颜色的模糊滤镜的图片(error -> nil)
 
 @param tintColor 着色颜色
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByBlurWithTint:(UIColor *)tintColor;

/**
 根据图片模糊度, 着色颜色, 饱和度或遮罩图片, 为图片添加滤镜(内存不够/error -> nil)
 
 @param blurRadius    图片模糊度(0 -> 无模糊效果)
 @param tintColor     着色颜色(可选, 与模糊度和饱和度混合作用于图片。颜色的alpha通道决定着色强度。nil -> 无着色)
 @param tintBlendMode 混合模式(默认kCGBlendModeNormal<0>)
 @param saturation    饱和度(1.0 -> 不影响图片; <1.0 -> 图片变淡; >1.0 -> 图片加深)
 @param maskImage     遮罩图片(若指定, 仅在遮罩图片范围内有滤镜效果。图片必须为遮罩或满足CGContextClipToMask遮罩参数的要求)
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByBlurRadius:(CGFloat)blurRadius
                                 tintColor:(nullable UIColor *)tintColor
                                  tintMode:(CGBlendMode)tintBlendMode
                                saturation:(CGFloat)saturation
                                 maskImage:(nullable UIImage *)maskImage;

#pragma mark - Colored Image
/**
 根据图片颜色, 创建一张1x1 point大小的图片(error -> nil)
 
 @param color 图片颜色
 @return 新图片(error -> nil)
 */
+ (nullable UIImage *)ch_imageWithColor:(UIColor *)color;

/**
 根据图片颜色和尺寸, 创建图片(error -> nil)
 
 @param color 图片颜色
 @param size  图片尺寸
 @return 新图片(error -> nil)
 */
+ (nullable UIImage *)ch_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 根据着色颜色, 填充图片的alpha通道(error -> nil)
 
 @param color 着色颜色
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByTintColor:(UIColor *)color;

/**
 根据透明度, 获取透明图片(error -> nil)
 
 @param alphaDelta 透明度
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByChangeAlpha:(CGFloat)alphaDelta;

#pragma mark - Gradient Image
/**
 根据图片尺寸, 渐变起点, 渐变终点, 渐变颜色集及颜色分割点集, 创建线性渐变颜色图片(使用方式类似CAGradientLayer)
 
 @param size       图片尺寸
 @param startPoint 渐变起点[{0, 0}-{1, 1}]
 @param endPoint   渐变终点[{0, 0}-{1, 1}]
 @param colors     渐变颜色集
 @param locations  颜色分割点集(可选, nil则使用默认分割点集)
 @return 线性渐变颜色图片
 */
+ (UIImage *)ch_gradientColorImageWithSize:(CGSize)size
                                startPoint:(CGPoint)startPoint
                                  endPoint:(CGPoint)endPoint
                                    colors:(NSArray<UIColor *> *)colors
                                 locations:(NSArray<NSNumber *> *)locations;

#pragma mark - Image Border
/**
 根据内边距和颜色, 设置图片边框(error -> nil)
 
 @param insets 内边距(正数->内距; 负数->外边)
 @param color 边框颜色
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color;

#pragma mark - Image Cropped
/**
 将矩形图片裁切为正方形图片(单位为像素<Pixel>, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByCropToSquare;

/**
 根据裁切类型, 裁切图片(单位为像素<Pixel>, error -> nil)
 
 @param style 裁切类型
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByCropStyle:(CHUIImageCropStyle)style;

/**
 根据裁切后显示的范围, 裁切图片(单位为像素<Pixel>, error -> nil)
 
 @param rect 裁切后显示的范围
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByCropToRect:(CGRect)rect;

/**
 根据裁切后显示的范围及图片倍数, 裁切图片(error -> nil)
 
 @param rect  裁切后显示的范围
 @param scale 图片倍数
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByCropToRect:(CGRect)rect scale:(CGFloat)scale;

#pragma mark - Image Rotation
/**
 根据旋转角度, 旋转图片(中心点旋转, error -> nil)
 
 @param degrees 旋转角度(⟲逆时针旋转)
 @param fitSize 调整尺寸(YES -> 新图片尺寸, 显示全部图片内容; NO -> 原图尺寸不变, 图片内容可能被裁切)
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByDegrees:(CGFloat)degrees fitSize:(BOOL)fitSize;

/**
 根据旋转弧度, 旋转图片(中心点旋转, error -> nil)
 
 @param radians 旋转弧度(⟲逆时针旋转。角度弧度转换 -> degrees * M_PI / 180, 可用CHDegreesToRadians()方法转换)
 @param fitSize 调整尺寸(YES -> 新图片尺寸, 显示全部内容; NO -> 原图尺寸不变, 内容可能被裁切)
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 将图片⤺逆时针旋转90°(宽高替换, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByRotateLeft90;

/**
 将图片⤼顺时针旋转90°(宽高替换, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByRotateRight90;

/**
 将图片↻顺时针旋转180°(error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByRotate180;

/**
 垂直方向翻转图片(⥯, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByFlipVertical;

/**
 水平方向翻转图片(⇋, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByFlipHorizontal;

#pragma mark - Rounded Image
/**
 将矩形图片裁切为圆形图片(以中心点为圆心, 最短边长为直径进行裁切, 单位为像素<Pixel>, error -> nil)
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByCropToRound;

/**
 根据角度值, 设置圆角图片(error -> nil)
 
 @param radius 角度值(若角度值大于图片宽度或高度的一半, 将根据图片宽度或高度的一半调整)
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByRoundCornerRadius:(CGFloat)radius;

/**
 根据角度值, 边框宽度和颜色,设置圆角图片(error -> nil)
 
 @param radius      角度值(若角度值大于图片宽度或高度的一半, 将根据图片宽度或高度的一半调整)
 @param borderWidth 边框宽度(若边框宽度大于图片宽度或高度的一半, 将根据图片宽度或高度的一半调整)
 @param borderColor 边框颜色(nil -> clearColor)
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor;

/**
 根据角度值, 边角, 边框宽度, 边框颜色和边框线连接样式, 设置圆角图片(error -> nil)
 
 @param radius         角度值(若角度值大于图片宽度或高度的一半, 将根据图片宽度或高度的一半调整)
 @param corners        边角(指定上下左右)
 @param borderWidth    边框宽度(若边框宽度大于图片宽度或高度的一半, 将根据图片宽度或高度的一半调整)
 @param borderColor    边框颜色(nil -> clearColor)
 @param borderLineJoin 边框线连接样式
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin;

/**
 根据角度值,边角, 边框宽度, 边框颜色, 边框线连接样式和虚线规则数组, 设置圆角图片(error -> nil)

 @param radius            角度值(若角度值大于图片宽度或高度的一半, 将根据图片宽度或高度的一半调整)
 @param corners           边角(指定上下左右)
 @param borderWidth       边框宽度(若边框宽度大于图片宽度或高度的一半, 将根据图片宽度或高度的一半调整)
 @param borderColor       边框颜色(nil -> clearColor)
 @param borderLineJoin    边框线连接样式
 @param borderDashPattern 虚线规则数组(例, `CGFloat borderDashPattern[] = {2, 3}`)
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin
                                borderDashPattern:(nullable const CGFloat *)borderDashPattern;

#pragma mark - Image Border
/**
 根据边框宽度, 边框颜色和边框风格, 设置边框图片(error -> nil)

 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param borderStyle 边框风格
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByBorderWidth:(CGFloat)borderWidth
                                borderColor:(nullable UIColor *)borderColor
                                borderStyle:(CHUIImageBorderStyle)borderStyle;

/**
 根据边框宽度, 边框颜色, 边框线连接样式, 边框风格和虚线规则数组, 设置边框图片(error -> nil)

 @param borderWidth       边框宽度
 @param borderColor       边框颜色
 @param borderLineJoin    边框线连接样式
 @param borderStyle       边框风格
 @param borderDashPattern 虚线规则数组(例, `CGFloat borderDashPattern[] = {2, 3}`)
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByBorderWidth:(CGFloat)borderWidth
                                borderColor:(nullable UIColor *)borderColor
                             borderLineJoin:(CGLineJoin)borderLineJoin
                                borderStyle:(CHUIImageBorderStyle)borderStyle
                          borderDashPattern:(nullable const CGFloat *)borderDashPattern;

@end

NS_ASSUME_NONNULL_END
