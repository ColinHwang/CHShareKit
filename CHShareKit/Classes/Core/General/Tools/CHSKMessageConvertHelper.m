//
//  CHSKMessageConvertHelper.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKMessageConvertHelper.h"

#import "CHSKShareMessage.h"

#import "CHSKImageDownloader.h"
#import "NSError+CHShareKit.h"
#import <CHCategories/CHCategories.h>

@implementation CHSKMessageConvertHelper

#pragma mark - Public methods
/**
 根据分享图片、分享图片大小、缩略图及缩略图片大小，对图片进行下载或压缩处理
 */
+ (void)configureShareImageDataWithImage:(id)image
                             maxFileSize:(NSInteger)fileSize
                          thumbnailImage:(id)thumbnailImage
                    maxThumbnailFileSize:(NSInteger)thumbnailFileSize
                       completionHandler:(CHSKImageDataConvertCompletionHandler)completionHandler {
    __block NSData *aImageData = nil;
    __block NSData *aThumbnailImageData = nil;
    __block NSError *aError = nil;
    
    // image != thumbnailImage
    dispatch_group_t group = dispatch_group_create();
    // 大图
    if (image) {
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
            dispatch_group_enter(group);
            [self configureShareImageDataWithImage:image maxFileSize:fileSize shouldAdjustImageSize:NO imageSize:CGSizeZero completionHandler:^(NSData *imageData, NSData *thumbnailImageData, NSError *error) {
                aImageData = imageData;
                dispatch_group_leave(group);
            }];
        });
    }
    // 缩略图
    if (!thumbnailImage) {
        thumbnailImage = [image copy];
    }
    if (thumbnailImage) {
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
            dispatch_group_enter(group);
            [self configureShareImageDataWithImage:thumbnailImage maxFileSize:thumbnailFileSize shouldAdjustImageSize:YES imageSize:CHSKShareThumbnailImageSize completionHandler:^(NSData *imageData, NSData *thumbnailImageData, NSError *error) {
                aThumbnailImageData = imageData;
                dispatch_group_leave(group);
            }];
        });
    }
    
    dispatch_group_notify(group,dispatch_get_main_queue(), ^ {
        if (!aImageData.length && !aThumbnailImageData.length) {
            aError = [NSError ch_sk_errorWithCode:CHSKErrorCodeInvalidMessageImages];
        }
        !completionHandler ?: completionHandler(aImageData, aThumbnailImageData, aError);
    });
}

#pragma mark - Private methods
/**
 *  根据分享图片、分享图片大小、是否调整分享图片尺寸及分享图片尺寸、对图片进行下载或压缩处理(图片可能会被拉伸)
 */
+ (void)configureShareImageDataWithImage:(id)image
                             maxFileSize:(NSInteger)fileSize
                   shouldAdjustImageSize:(BOOL)shouldAdjustImageSize
                               imageSize:(CGSize)imageSize
                       completionHandler:(CHSKImageDataConvertCompletionHandler)completionHandler {
    __block NSData *imageData = nil;
    __block NSError *error = nil;
    if ([image isKindOfClass:[UIImage class]]) {
        if (shouldAdjustImageSize) {
            imageData = [self ch_resetImageDataWithImage:image imageSize:imageSize maxFileSize:fileSize];
        } else {
            imageData = [image ch_compressToJPEGFormatDataWithFactor:CHSKShareImageCompressionFactor maxFileSize:fileSize];
        }
        if (!imageData) {
            error = [NSError ch_sk_errorWithCode:CHSKErrorCodeInvalidMessageImages];
            completionHandler(nil, nil, error);
            return;
        }
        !completionHandler ?: completionHandler(imageData, nil, nil);
        return;
    }
    
    NSURL *imageUrl = nil;
    // NSString
    if ([image isKindOfClass:[NSString class]]) {
        imageUrl = [NSURL URLWithString:image];
    }
    
    // NSURL
    if ([image isKindOfClass:[NSURL class]]) {
        imageUrl = image;
    }
    
    if (!imageUrl || !imageUrl.absoluteString.length) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeInvalidMessageImages];
        !completionHandler ?: completionHandler(nil, nil, error);
        return;
    }
    
    // Download
    [[CHSKImageDownloader sharedDownloader] downloadImageWithURL:imageUrl completionHandler:^(UIImage *aImage, NSData *aImageData, NSError *aError, BOOL aFinished) {
        if (aError) {
            error = aError;
            !completionHandler ?: completionHandler(nil, nil, error);
            return;
        }
        
        imageData = aImageData;
        if (shouldAdjustImageSize) {
            if (CGSizeEqualToSize(aImage.size, imageSize)) {
                if (imageData && imageData.length < fileSize) {
                    !completionHandler ?: completionHandler(imageData, nil, nil);
                    return;
                }
            }
            
            imageData = [self ch_resetImageDataWithImage:aImage imageSize:imageSize maxFileSize:fileSize];
            if (!imageData) {
                error = [NSError ch_sk_errorWithCode:CHSKErrorCodeInvalidMessageImages];
                !completionHandler ?: completionHandler(nil, nil, error);
                return;
            }
            
            !completionHandler ?: completionHandler(imageData, nil, nil);
            return;
        }
        
        
        if (imageData && imageData.length < fileSize) {
            !completionHandler ?: completionHandler(imageData, nil, nil);
            return;
        }
        
        // 压缩
        imageData = [aImage ch_compressToJPEGFormatDataWithFactor:CHSKShareImageCompressionFactor maxFileSize:fileSize];
        if (!imageData) {
            error = [NSError ch_sk_errorWithCode:CHSKErrorCodeInvalidMessageImages];
            !completionHandler ?: completionHandler(nil, nil, error);
            return;
        }
        
        !completionHandler ?: completionHandler(imageData, nil, nil);
    }];
}

+ (NSData *)ch_resetImageDataWithImage:(UIImage *)image imageSize:(CGSize)imageSize maxFileSize:(u_int64_t)fileSize{
    UIImage *buffer = [image ch_imageByResizeToSize:imageSize contentMode:UIViewContentModeScaleAspectFill];
    return [buffer ch_compressToJPEGFormatDataWithFactor:1e-10 maxFileSize:fileSize];
}

@end
