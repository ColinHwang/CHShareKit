//
//  UIImage+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/10.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger, CHUIImageResizeModel) {
//    CHUIImageResizeModeleScaleToFill,
//    CHUIImageResizeModeleScaleAspectFit,
//    CHUIImageResizeModeleScaleAspectFill,
//    CHUIImageResizeModeleScaleAspectFillTop,
//    CHUIImageResizeModeleScaleAspectFillBottom,
//};

@interface UIImage (CHBase)

#pragma mark - Base
@property (nonatomic, readonly) CGSize ch_sizeInPixel; ///< 获取图片的像素大小(根据图片倍数调整)
@property (nullable, nonatomic, readonly) UIColor *ch_averageColor; ///< 获取图片的均色(error -> nil)

/**
 根据自定义绘制上下文和图片尺寸, 创建图片(error -> nil)

 @param size      图片尺寸(宽高不能为0)
 @param drawBlock 自定义绘制上下文
 @return 新图片(error -> nil)
 */
+ (nullable UIImage *)ch_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;

/**
 根据自定义绘制上下文、图片尺寸、图片是否透明及图片倍数, 创建图片(error -> nil)

 @param size 图片尺寸(宽高不能为0)
 @param opaque 图片是否透明(YES不透明, NO半透明)
 @param scale 图片倍数(0则获取当前屏幕倍数)
 @param drawBlock 自定义绘制上下文
 @return 新图片(error -> nil)
 */
+ (nullable UIImage *)ch_imageWithSize:(CGSize)size
                                opaque:(BOOL)opaque
                                 scale:(CGFloat)scale
                             drawBlock:(void (^)(CGContextRef context))drawBlock;

#pragma mark - Check
/**
 判断两个图片是否相等

 @param other 另一个图片
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isEqualToImage:(UIImage *)other;

/**
 图片是否包含Alpha通道

 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_hasAlphaChannel;

#pragma mark - Modify
/**
 根据图片显示contentMode, 在指定的矩形rect内绘制图片(该方法依据图片设置, 在当前图形上下文内绘制图片。默认坐标系下, 图片以矩形左上为原点绘制。该方法可在当前图形上下文内任意变换)

 @param rect        指定的矩形rect
 @param contentMode 图片显示contentMode
 @param clips       是否裁切图片
 */
- (void)ch_drawInRect:(CGRect)rect
      withContentMode:(UIViewContentMode)contentMode
        clipsToBounds:(BOOL)clips;

/**
 根据叠加图片及位置, 在当前图片上叠加新的图片(叠加图片超出部分将被裁切)
 
 @param image 叠加图片
 @param point 位置
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByAddingImage:(UIImage *)image toPoint:(CGPoint)point;

#pragma mark - Resize
/**
 根据指定宽度，等比例调整图片尺寸

 @param width 指定宽度
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByResizeToWidth:(CGFloat)width;

/**
 根据指定宽度及图片倍数，等比例调整图片尺寸

 @param width 指定宽度
 @param scale 图片倍数
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByResizeToWidth:(CGFloat)width scale:(CGFloat)scale;

/**
 根据图片新的尺寸, 调整图片(图片可能会被拉伸)

 @param size 图片的新尺寸(正数)
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByResizeToSize:(CGSize)size;

/**
 根据图片新的尺寸及图片倍数, 调整图片(图片可能会被拉伸)

 @param size  图片的新尺寸(正数)
 @param scale 图片倍数
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByResizeToSize:(CGSize)size scale:(CGFloat)scale;

/**
 根据图片新的尺寸和contentMode, 调整图片(图片内容根据contentMode变化)

 @param size 图片的新尺寸(正数)
 @param contentMode 图片显示contentMode
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

#pragma mark - Orientation Fixed
/**
 将图片调整为方向向上的图片
 
 @return 新图片(error -> nil)
 */
- (nullable UIImage *)ch_imageByFixToOrientationUp;

#pragma mark - Emoji Image
/**
 根据苹果emoji表情, 创建一张正方形图片(图片缩放比例与屏幕scale一致, 原始AppleColorEmoji格式emoji图片的尺寸为160*160 px, error -> nil)
 
 @param emoji 单个emoji(😄)
 @param size  图片大小(单边)
 @return 新图片(error -> nil)
 */
+ (nullable UIImage *)ch_imageWithEmoji:(NSString *)emoji size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
