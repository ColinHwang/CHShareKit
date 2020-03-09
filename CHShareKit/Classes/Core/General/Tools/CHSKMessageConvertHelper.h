//
//  CHSKMessageConvertHelper.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>
#import "CHSKDefines.h"
#import "CHSKPrivateDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CHSKShareMessage转换工具
 */
@interface CHSKMessageConvertHelper : NSObject

/**
 根据分享图片、分享图片大小、缩略图及缩略图片大小，对图片进行下载或压缩处理
 */
+ (void)configureShareImageDataWithImage:(id)image
                             maxFileSize:(NSInteger)fileSize
                          thumbnailImage:(id)thumbnailImage
                    maxThumbnailFileSize:(NSInteger)thumbnailFileSize
                       completionHandler:(CHSKImageDataConvertCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
