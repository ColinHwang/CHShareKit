//
//  UIImage+CHImageCompression.h
//  Pods
//
//  Created by CHwang on 17/2/11.
//
//  图片压缩处理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CHImageCompression)

/**
 获取PNG格式的图片数据(error -> nil)
 
 @return PNG格式的图片数据(error -> nil)
 */
- (nullable NSData *)ch_compressToPNGFormatData;

/**
 根据压缩精度系数([1e-10, 0.1])及文件大小(单位字节)，获取压缩后的JPEG格式的图片数据(error -> nil)
 
 @param factor   压缩精度系数([1e-10, 0.1])
 @param fileSize 文件大小(单位字节)
 @return JPEG格式的图片数据(error -> nil)
 */
- (nullable NSData *)ch_compressToJPEGFormatDataWithFactor:(CGFloat)factor maxFileSize:(u_int64_t)fileSize;

/**
 指定图片宽度及图片文件大小(单位字节), 压缩图片(图片将等比例缩放, error -> nil)
 
 @param width       图片指定宽度
 @param maxFileSize 图片文件大小(单位字节)
 @return JPEG格式的图片数据(error -> nil)
 */
- (nullable NSData *)ch_resetImageDataWithImageWidth:(CGFloat)width maxFileSize:(uint64_t)maxFileSize;

/**
 指定图片尺寸及图片文件大小(单位字节)，压缩图片(图片可能会被拉伸, error -> nil)
 
 @param size        图片指定尺寸
 @param maxFileSize 图片文件大小(单位字节)
 @return JPEG格式的图片数据(error -> nil)
 */
- (nullable NSData *)ch_resetImageDataWithImageSize:(CGSize)size maxFileSize:(uint64_t)maxFileSize;

@end

NS_ASSUME_NONNULL_END
