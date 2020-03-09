//
//  UIImage+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/10.
//
//

#import "UIImage+CHBase.h"
#import <CoreText/CoreText.h>
#import "CHCoreGraphicHelper.h"
#import "NSString+CHEmoji.h"

@implementation UIImage (CHBase)

#pragma mark - Base
- (CGSize)ch_sizeInPixel {
    return CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
}

- (UIColor *)ch_averageColor {
    /*
     http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage
     */
    unsigned char buffer[4] = {}; // red, green, blue, alpha
    CGFloat red, green, blue, alpha, alphaDelta;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    alphaDelta = buffer[3] ? buffer[3] : 255.f;
    red = buffer[0] / alphaDelta;
    green = buffer[1] / alphaDelta;
    blue = buffer[2]  / alphaDelta;
    alpha = buffer[3] / alphaDelta;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIImage *)ch_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock {
    return [self ch_imageWithSize:size opaque:NO scale:0 drawBlock:drawBlock];
}

+ (UIImage *)ch_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale drawBlock:(void (^)(CGContextRef context))drawBlock {
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Check
typedef union {
    uint32_t raw;
    unsigned char bytes[4];
    struct {
        char red;
        char green;
        char blue;
        char alpha;
    } __attribute__ ((packed)) pixels;
} CHComparePixel;

- (BOOL)_ch_compareWithImage:(UIImage *)image tolerance:(CGFloat)tolerance {
    /*
     https://github.com/facebook/ios-snapshot-test-case/blob/master/FBSnapshotTestCase/Categories/UIImage%2BCompare.m
     */
    if (!CGSizeEqualToSize(self.size, image.size)) return NO;
    
    CGSize referenceImageSize = CGSizeMake(CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
    CGSize imageSize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
    
    // The images have the equal size, so we could use the smallest amount of bytes because of byte padding
    size_t minBytesPerRow = MIN(CGImageGetBytesPerRow(self.CGImage), CGImageGetBytesPerRow(image.CGImage));
    size_t referenceImageSizeBytes = referenceImageSize.height * minBytesPerRow;
    void *referenceImagePixels = calloc(1, referenceImageSizeBytes);
    void *imagePixels = calloc(1, referenceImageSizeBytes);
    
    if (!referenceImagePixels || !imagePixels) {
        free(referenceImagePixels);
        free(imagePixels);
        return NO;
    }
    
    CGContextRef referenceImageContext = CGBitmapContextCreate(referenceImagePixels,
                                                               referenceImageSize.width,
                                                               referenceImageSize.height,
                                                               CGImageGetBitsPerComponent(self.CGImage),
                                                               minBytesPerRow,
                                                               CGImageGetColorSpace(self.CGImage),
                                                               (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                                               );
    CGContextRef imageContext = CGBitmapContextCreate(imagePixels,
                                                      imageSize.width,
                                                      imageSize.height,
                                                      CGImageGetBitsPerComponent(image.CGImage),
                                                      minBytesPerRow,
                                                      CGImageGetColorSpace(image.CGImage),
                                                      (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                                      );
    
    if (!referenceImageContext || !imageContext) {
        CGContextRelease(referenceImageContext);
        CGContextRelease(imageContext);
        free(referenceImagePixels);
        free(imagePixels);
        return NO;
    }
    
    CGContextDrawImage(referenceImageContext, CGRectMake(0, 0, referenceImageSize.width, referenceImageSize.height), self.CGImage);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, imageSize.width, imageSize.height), image.CGImage);
    
    CGContextRelease(referenceImageContext);
    CGContextRelease(imageContext);
    
    BOOL imageEqual = YES;
    
    // Do a fast compare if we can
    if (tolerance == 0) {
        imageEqual = (memcmp(referenceImagePixels, imagePixels, referenceImageSizeBytes) == 0);
    } else {
        // Go through each pixel in turn and see if it is different
        const NSInteger pixelCount = referenceImageSize.width * referenceImageSize.height;
        
        CHComparePixel *p1 = referenceImagePixels;
        CHComparePixel *p2 = imagePixels;
        
        NSInteger numDiffPixels = 0;
        for (int n = 0; n < pixelCount; ++n) {
            // If this pixel is different, increment the pixel diff count and see
            // if we have hit our limit.
            if (p1->raw != p2->raw) {
                numDiffPixels ++;
                
                CGFloat percent = (CGFloat)numDiffPixels / pixelCount;
                if (percent > tolerance) {
                    imageEqual = NO;
                    break;
                }
            }
            
            p1++;
            p2++;
        }
    }
    
    free(referenceImagePixels);
    free(imagePixels);
    
    return imageEqual;
}

- (BOOL)ch_isEqualToImage:(UIImage *)other {
    if (!other) return NO;
    if (![other isKindOfClass:[UIImage class]]) return NO;
    if (self == other) return YES;
    
    return [self _ch_compareWithImage:other tolerance:0];
}

- (BOOL)ch_hasAlphaChannel {
    if (self.CGImage == NULL) return NO;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage) & kCGBitmapAlphaInfoMask;
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

#pragma mark - Modify
- (void)ch_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips {
    CGRect drawRect = CHCGRectFitWithContentMode(rect, self.size, contentMode);
    if (drawRect.size.width == 0 || drawRect.size.height == 0) return;
    if (clips) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context) {
            CGContextSaveGState(context);
            CGContextAddRect(context, rect);
            CGContextClip(context);
            [self drawInRect:drawRect];
            CGContextRestoreGState(context);
        }
    } else {
        [self drawInRect:drawRect];
    }
}

- (UIImage *)ch_imageByAddingImage:(UIImage *)image toPoint:(CGPoint)point {
    return [UIImage ch_imageWithSize:self.size opaque:![self ch_hasAlphaChannel] scale:self.scale drawBlock:^(CGContextRef  _Nonnull context) {
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        [image drawAtPoint:point];
    }];
}

#pragma mark - Resize
- (UIImage *)ch_imageByResizeToWidth:(CGFloat)width {
    return [self ch_imageByResizeToWidth:width scale:self.scale];
}

- (UIImage *)ch_imageByResizeToWidth:(CGFloat)width scale:(CGFloat)scale {
    if (self.size.width <= 0 || self.size.height <= 0) return nil;
    CGFloat height = width * self.size.height / self.size.width;
    return [self ch_imageByResizeToSize:CGSizeMake(width, height) scale:scale];
}

- (UIImage *)ch_imageByResizeToSize:(CGSize)size {
    return [self ch_imageByResizeToSize:size scale:self.scale];
}

- (UIImage *)ch_imageByResizeToSize:(CGSize)size scale:(CGFloat)scale {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)ch_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self ch_drawInRect:CGRectMake(0, 0, size.width, size.height) withContentMode:contentMode clipsToBounds:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Orientation Fixed
- (UIImage *)ch_imageByFixToOrientationUp {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef context = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                                 CGImageGetBitsPerComponent(self.CGImage), 0,
                                                 CGImageGetColorSpace(self.CGImage),
                                                 CGImageGetBitmapInfo(self.CGImage));
    if (!context) return nil;
    
    CGContextConcatCTM(context, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(context, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(context, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

#pragma mark - Emoji Image
+ (UIImage *)ch_imageWithEmoji:(NSString *)emoji size:(CGFloat)size {
    if (emoji.length == 0 || ![emoji ch_isEmoji]) return nil;
    if (size < 1) return nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CTFontRef font = CTFontCreateWithName(CFSTR("AppleColorEmoji"), size * scale, NULL);
    if (!font) return nil;
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:emoji attributes:@{ (__bridge id)kCTFontAttributeName:(__bridge id)font, (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor whiteColor].CGColor }];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, size * scale, size * scale, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)str);
    CGRect bounds = CTLineGetBoundsWithOptions(line, kCTLineBoundsUseGlyphPathBounds);
    CGContextSetTextPosition(ctx, 0, -bounds.origin.y);
    CTLineDraw(line, ctx);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    
    CFRelease(font);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(ctx);
    if (line)CFRelease(line);
    if (imageRef) CFRelease(imageRef);
    
    return image;
}

@end
