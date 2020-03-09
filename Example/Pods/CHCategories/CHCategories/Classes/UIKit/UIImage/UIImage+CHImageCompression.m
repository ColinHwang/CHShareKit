//
//  UIImage+CHImageCompression.m
//  Pods
//
//  Created by CHwang on 17/2/11.
//
//

#import "UIImage+CHImageCompression.h"
#import "UIImage+CHBase.h"

@implementation UIImage (CHImageCompression)

#pragma mark - Compress
NS_INLINE CGFloat CHClampCompressionFactor(CGFloat factor) {
    return factor < 1e-10 ? 1e-10 : factor > 0.1 ? 0.1 : factor;
}

- (NSData *)ch_compressToPNGFormatData {
    return UIImagePNGRepresentation(self);
}

- (NSData *)ch_compressToJPEGFormatDataWithFactor:(CGFloat)factor maxFileSize:(u_int64_t)fileSize {
    if (fileSize <= 0) return nil;
    
    NSData *tempImageData = UIImageJPEGRepresentation(self, 1.0);
    if ([tempImageData length] <= fileSize) return tempImageData;
    
    tempImageData = UIImageJPEGRepresentation(self, 0);
    if ([tempImageData length] > fileSize) return nil;
    if ([tempImageData length] == fileSize) return tempImageData;
    
    NSData *targetImageData = nil;
    CGFloat compressionFactor = CHClampCompressionFactor(factor);
    CGFloat minFactor = compressionFactor;
    CGFloat maxFactor = 1.0 - compressionFactor;
    CGFloat midFactor = 0;
    // binary search
    while (fabs(maxFactor-minFactor) > compressionFactor) {
        @autoreleasepool {
            midFactor = minFactor + (maxFactor - minFactor)/2;
            tempImageData = UIImageJPEGRepresentation(self, midFactor);
            
            if ([tempImageData length] > fileSize) {
                maxFactor = midFactor;
            } else {
                minFactor = midFactor;
                targetImageData = tempImageData;
            }
        }
    }
    
    return targetImageData;
}

- (NSData *)ch_resetImageDataWithImageWidth:(CGFloat)width maxFileSize:(uint64_t)maxFileSize {
    UIImage *image = [self ch_imageByResizeToWidth:width];
    return [image ch_compressToJPEGFormatDataWithFactor:1e-10 maxFileSize:maxFileSize];
}

- (NSData *)ch_resetImageDataWithImageSize:(CGSize)size maxFileSize:(uint64_t)maxFileSize {
    UIImage *image = [self ch_imageByResizeToSize:size];
    return [image ch_compressToJPEGFormatDataWithFactor:1e-10 maxFileSize:maxFileSize];
}

@end
