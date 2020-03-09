//
//  UIImage+CHImageEffect.m
//  CHCategories
//
//  Created by CHwang on 2019/2/3.
//

#import "UIImage+CHImageEffect.h"
#import <Accelerate/Accelerate.h>
#import "CHCoreGraphicHelper.h"
#import "UIImage+CHBase.h"

#ifndef CH_IMAGE_SWAP_VALUES
#define CH_IMAGE_SWAP_VALUES(_A_, _B_)  do { __typeof__(_A_) _tmp_ = (_A_); (_A_) = (_B_); (_B_) = _tmp_; } while (0)
#endif

const CGPoint CHUIImageGradientPointTop        = {0.5, 0};
const CGPoint CHUIImageGradientPointBottom     = {0.5, 1};
const CGPoint CHUIImageGradientPointLeft       = {0, 0.5};
const CGPoint CHUIImageGradientPointRight      = {1, 0.5};
const CGPoint CHUIImageGradientPointCenter     = {0.5, 0.5};
const CGPoint CHUIImageGradientPointUpperLeft  = {0, 0};
const CGPoint CHUIImageGradientPointLowerLeft  = {0, 1};
const CGPoint CHUIImageGradientPointUpperRight = {1, 0};
const CGPoint CHUIImageGradientPointLowerRight = {1, 1};

@implementation UIImage (CHImageEffect)

#pragma mark - Blurred Image
- (UIImage *)ch_imageByGrayscale {
    return [self ch_imageByBlurRadius:0 tintColor:nil tintMode:0 saturation:0 maskImage:nil];
}

- (UIImage *)ch_imageByBlurSoft {
    return [self ch_imageByBlurRadius:60 tintColor:[UIColor colorWithWhite:0.84 alpha:0.36] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)ch_imageByBlurLight {
    return [self ch_imageByBlurRadius:60 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)ch_imageByBlurExtraLight {
    return [self ch_imageByBlurRadius:40 tintColor:[UIColor colorWithWhite:0.97 alpha:0.82] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)ch_imageByBlurDark {
    return [self ch_imageByBlurRadius:40 tintColor:[UIColor colorWithWhite:0.11 alpha:0.73] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)ch_imageByBlurWithTint:(UIColor *)tintColor {
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self ch_imageByBlurRadius:20 tintColor:effectColor tintMode:kCGBlendModeNormal saturation:-1.0 maskImage:nil];
}

- (UIImage *)ch_imageByBlurRadius:(CGFloat)blurRadius tintColor:(nullable UIColor *)tintColor tintMode:(CGBlendMode)tintBlendMode saturation:(CGFloat)saturation maskImage:(nullable UIImage *)maskImage {
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog(@"UIImage error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog(@"UIImage error: inputImage must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog(@"UIImage error: effectMaskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    // iOS7 and above can use new func.
    BOOL hasNewFunc = (long)vImageBuffer_InitWithCGImage != 0 && (long)vImageCreateCGImageFromBuffer != 0;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturation = fabs(saturation - 1.0) > __FLT_EPSILON__;
    
    CGSize size = self.size;
    CGRect rect = { CGPointZero, size };
    CGFloat scale = self.scale;
    CGImageRef imageRef = self.CGImage;
    BOOL opaque = NO;
    
    if (!hasBlur && !hasSaturation) {
        return [self _ch_mergeImageRef:imageRef tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
    }
    
    vImage_Buffer effect = { 0 }, scratch = { 0 };
    vImage_Buffer *input = NULL, *output = NULL;
    
    vImage_CGImageFormat format = {
        .bitsPerComponent = 8,
        .bitsPerPixel = 32,
        .colorSpace = NULL,
        .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little, //requests a BGRA buffer.
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    
    if (hasNewFunc) {
        vImage_Error err;
        err = vImageBuffer_InitWithCGImage(&effect, &format, NULL, imageRef, kvImagePrintDiagnosticsToConsole);
        if (err != kvImageNoError) {
            NSLog(@"UIImage error: vImageBuffer_InitWithCGImage returned error code %zi for inputImage: %@", err, self);
            return nil;
        }
        err = vImageBuffer_Init(&scratch, effect.height, effect.width, format.bitsPerPixel, kvImageNoFlags);
        if (err != kvImageNoError) {
            NSLog(@"UIImage error: vImageBuffer_Init returned error code %zi for inputImage: %@", err, self);
            return nil;
        }
    } else {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef effectCtx = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectCtx, 1.0, -1.0);
        CGContextTranslateCTM(effectCtx, 0, -size.height);
        CGContextDrawImage(effectCtx, rect, imageRef);
        effect.data     = CGBitmapContextGetData(effectCtx);
        effect.width    = CGBitmapContextGetWidth(effectCtx);
        effect.height   = CGBitmapContextGetHeight(effectCtx);
        effect.rowBytes = CGBitmapContextGetBytesPerRow(effectCtx);
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef scratchCtx = UIGraphicsGetCurrentContext();
        scratch.data     = CGBitmapContextGetData(scratchCtx);
        scratch.width    = CGBitmapContextGetWidth(scratchCtx);
        scratch.height   = CGBitmapContextGetHeight(scratchCtx);
        scratch.rowBytes = CGBitmapContextGetBytesPerRow(scratchCtx);
    }
    
    input = &effect;
    output = &scratch;
    
    if (hasBlur) {
        // A description of how to compute the box kernel width from the Gaussian
        // radius (aka standard deviation) appears in the SVG spec:
        // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
        //
        // For larger values of 's' (s >= 2.0), an approximation can be used: Three
        // successive box-blurs build a piece-wise quadratic convolution kernel, which
        // approximates the Gaussian kernel to within roughly 3%.
        //
        // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
        //
        // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
        //
        CGFloat inputRadius = blurRadius * scale;
        if (inputRadius - 2.0 < __FLT_EPSILON__) inputRadius = 2.0;
        uint32_t radius = floor((inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5) / 2);
        radius |= 1; // force radius to be odd so that the three box-blur methodology works.
        int iterations;
        if (blurRadius * scale < 0.5) iterations = 1;
        else if (blurRadius * scale < 1.5) iterations = 2;
        else iterations = 3;
        NSInteger tempSize = vImageBoxConvolve_ARGB8888(input, output, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
        void *temp = malloc(tempSize);
        for (int i = 0; i < iterations; i++) {
            vImageBoxConvolve_ARGB8888(input, output, temp, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            CH_IMAGE_SWAP_VALUES(input, output);
        }
        free(temp);
    }
    
    if (hasSaturation) {
        // These values appear in the W3C Filter Effects spec:
        // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/Publish.html#grayscaleEquivalent
        CGFloat s = saturation;
        CGFloat matrixFloat[] = {
            0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
            0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
            0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
            0,                    0,                    0,                    1,
        };
        const int32_t divisor = 256;
        NSUInteger matrixSize = sizeof(matrixFloat) / sizeof(matrixFloat[0]);
        int16_t matrix[matrixSize];
        for (NSUInteger i = 0; i < matrixSize; ++i) {
            matrix[i] = (int16_t)roundf(matrixFloat[i] * divisor);
        }
        vImageMatrixMultiply_ARGB8888(input, output, matrix, divisor, NULL, NULL, kvImageNoFlags);
        CH_IMAGE_SWAP_VALUES(input, output);
    }
    
    UIImage *outputImage = nil;
    if (hasNewFunc) {
        CGImageRef effectCGImage = NULL;
        effectCGImage = vImageCreateCGImageFromBuffer(input, &format, &CHCleanupBuffer, NULL, kvImageNoAllocate, NULL);
        if (effectCGImage == NULL) {
            effectCGImage = vImageCreateCGImageFromBuffer(input, &format, NULL, NULL, kvImageNoFlags, NULL);
            free(input->data);
        }
        free(output->data);
        outputImage = [self _ch_mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
        CGImageRelease(effectCGImage);
    } else {
        CGImageRef effectCGImage;
        UIImage *effectImage;
        if (input != &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (input == &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        effectCGImage = effectImage.CGImage;
        outputImage = [self _ch_mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
    }
    return outputImage;
}

// Helper function to handle deferred cleanup of a buffer.
static void CHCleanupBuffer(void *userData, void *buf_data) {
    free(buf_data);
}

// Helper function to add tint and mask.
- (UIImage *)_ch_mergeImageRef:(CGImageRef)effectCGImage tintColor:(UIColor *)tintColor tintBlendMode:(CGBlendMode)tintBlendMode maskImage:(UIImage *)maskImage opaque:(BOOL)opaque {
    BOOL hasTint = tintColor != nil && CGColorGetAlpha(tintColor.CGColor) > __FLT_EPSILON__;
    BOOL hasMask = maskImage != nil;
    CGSize size = self.size;
    CGRect rect = { CGPointZero, size };
    CGFloat scale = self.scale;
    
    if (!hasTint && !hasMask) {
        return [UIImage imageWithCGImage:effectCGImage];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -size.height);
    if (hasMask) {
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextSaveGState(context);
        CGContextClipToMask(context, rect, maskImage.CGImage);
    }
    CGContextDrawImage(context, rect, effectCGImage);
    if (hasTint) {
        CGContextSaveGState(context);
        CGContextSetBlendMode(context, tintBlendMode);
        CGContextSetFillColorWithColor(context, tintColor.CGColor);
        CGContextFillRect(context, rect);
        CGContextRestoreGState(context);
    }
    if (hasMask) {
        CGContextRestoreGState(context);
    }
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

#pragma mark - Colored Image
+ (UIImage *)ch_imageWithColor:(UIColor *)color {
    return [self ch_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)ch_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)ch_imageByTintColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [color set];
    UIRectFill(rect);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeDestinationIn alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)ch_imageByChangeAlpha:(CGFloat)alphaDelta {
    return [UIImage ch_imageWithSize:self.size opaque:NO scale:self.scale drawBlock:^(CGContextRef  _Nonnull context) {
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:alphaDelta];
    }];
}

#pragma mark - Gradient Image
+ (UIImage *)ch_gradientColorImageWithSize:(CGSize)size
                                startPoint:(CGPoint)startPoint
                                  endPoint:(CGPoint)endPoint
                                    colors:(NSArray<UIColor *> *)colors
                                 locations:(NSArray<NSNumber *> *)locations {
    NSMutableArray *colorsBuffer = @[].mutableCopy;
    for (UIColor *color in colors) {
        [colorsBuffer addObject:(__bridge id)color.CGColor];
    }
    
    CGFloat *locationsBuffer = NULL;
    if (locations) {
        NSUInteger length = locations.count;
        locationsBuffer = (CGFloat *)calloc(length, length * sizeof(CGFloat));
        for (int i = 0; i < locations.count; i++) {
            NSNumber *location = locations[i];
#if CGFLOAT_IS_DOUBLE
            locationsBuffer[i] = [location doubleValue];
#else
            locationsBuffer[i] = [location floatValue];
#endif
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorsBuffer, locationsBuffer);
    
    CGPoint start = CGPointMake(size.width * startPoint.x, size.height * startPoint.y);
    CGPoint end = CGPointMake(size.width * endPoint.x, size.height * endPoint.y);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    free(locationsBuffer);
    locationsBuffer = 0;
    return image;
}

#pragma mark - Image Border
- (UIImage *)ch_imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color {
    /*
     self.size = (100, 100)
     insets = (10, 10, 10, 10)
     size.width -= insets.left + insets.right; -> 80
     size.height -= insets.top + insets.bottom; -> 80
     
     CGRect rect = CGRectMake(-insets.left, -insets.top, self.size.width, self.size.height); -> rect = (-10, -10, 100, 100)
     
     CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height)); -> (0, 0, 80, 80)
     CGPathAddRect(path, NULL, rect); -> (-10, -10, 100, 100)
     */
    CGSize size = self.size;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    if (size.width <= 0 || size.height <= 0) return nil;
    
    CGRect rect = CGRectMake(-insets.left, -insets.top, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (color) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Image Cropped
- (UIImage *)ch_imageByCropToSquare {
    if (self.size.width <= 0 || self.size.height <= 0) return nil;
    
    return [self ch_imageByCropStyle:CHUIImageCropStyleCenter];
}

- (UIImage *)ch_imageByCropStyle:(CHUIImageCropStyle)style {
    CGFloat cropX = 0, cropY = 0, cropWidth = self.size.width, cropHeight = self.size.height;
    
    if (style == CHUIImageCropStyleLeft) {
        cropWidth /= 2;
    } else if (style == CHUIImageCropStyleRight) {
        cropWidth /= 2;
        cropX = cropWidth;
    } else if (style == CHUIImageCropStyleCenter) {
        if (cropWidth > cropHeight) {
            cropX = (cropWidth - cropHeight)/2;
            cropWidth = cropHeight;
        } else if (cropWidth < cropHeight) {
            cropY = (cropHeight - cropWidth)/2;
            cropHeight = cropWidth;
        }
    } else if (style == CHUIImageCropStyleTop) {
        cropHeight /= 2;
    } else if (style == CHUIImageCropStyleBottom) {
        cropHeight /= 2;
        cropY = cropHeight;
    }
    
    return [self ch_imageByCropToRect:CGRectMake(cropX, cropY, cropWidth, cropHeight)];
}

- (UIImage *)ch_imageByCropToRect:(CGRect)rect {
    return [self ch_imageByCropToRect:rect scale:self.scale];
}

- (UIImage *)ch_imageByCropToRect:(CGRect)rect scale:(CGFloat)scale {
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

#pragma mark - Image Rotation
- (UIImage *)ch_imageByDegrees:(CGFloat)degrees fitSize:(BOOL)fitSize {
    return [self ch_imageByRotate:CHDegreesToRadians(degrees) fitSize:fitSize];
}

- (UIImage *)ch_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize {
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ? CGAffineTransformMakeRotation(radians) : CGAffineTransformIdentity);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, radians);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

- (UIImage *)ch_imageByRotateLeft90 {
    return [self ch_imageByRotate:CHDegreesToRadians(90) fitSize:YES];
}

- (UIImage *)ch_imageByRotateRight90 {
    return [self ch_imageByRotate:CHDegreesToRadians(-90) fitSize:YES];
}

- (UIImage *)ch_imageByRotate180 {
    return [self _ch_flipImageInHorizontal:YES vertical:YES];
}

- (UIImage *)ch_imageByFlipVertical {
    return [self _ch_flipImageInHorizontal:NO vertical:YES];
}

- (UIImage *)ch_imageByFlipHorizontal {
    return [self _ch_flipImageInHorizontal:YES vertical:NO];
}

- (UIImage *)_ch_flipImageInHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage) return nil;
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    size_t bytesPerRow = width * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return img;
}

#pragma mark - Rounded Image
- (UIImage *)ch_imageByCropToRound {
    if (self.size.width <= 0 || self.size.height <= 0) return nil;
    
    CGRect rect = CHCGRectGetCenterSquareRect(CGRectMake(0, 0, self.size.width, self.size.height));
    if (CGRectEqualToRect(rect, CGRectZero)) return nil;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.size.height-rect.origin.y);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path closePath];
    
    CGContextSaveGState(context);
    [path addClip];
    CGContextDrawImage(context, rect, self.CGImage);
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)ch_imageByRoundCornerRadius:(CGFloat)radius {
    return [self ch_imageByRoundCornerRadius:radius borderWidth:0 borderColor:nil];
}

- (UIImage *)ch_imageByRoundCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [self ch_imageByRoundCornerRadius:radius corners:UIRectCornerAllCorners borderWidth:borderWidth borderColor:borderColor borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)ch_imageByRoundCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin {
    return [self ch_imageByRoundCornerRadius:radius corners:corners borderWidth:borderWidth borderColor:borderColor borderLineJoin:borderLineJoin borderDashPattern:NULL];
}

- (UIImage *)ch_imageByRoundCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin borderDashPattern:(const CGFloat *)borderDashPattern {
    /*   CGLineJoin
     kCGLineJoinMiter 接合点为尖角
     kCGLineJoinBevel 接合点为斜角
     kCGLineJoinRound 接合点为圆角
     */
    UIRectCorner aCorners = 0;
    if (corners != UIRectCornerAllCorners) {
        if (corners & UIRectCornerTopLeft) aCorners |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) aCorners |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) aCorners |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) aCorners |= UIRectCornerTopRight;
    } else {
        aCorners = UIRectCornerAllCorners;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:aCorners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:aCorners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        if (borderDashPattern) {
            [path setLineDash:borderDashPattern count:2 phase:0];
        }
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Image Border
- (UIImage *)ch_imageByBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderStyle:(CHUIImageBorderStyle)borderStyle {
    return [self ch_imageByBorderWidth:borderWidth borderColor:borderColor borderLineJoin:kCGLineJoinMiter borderStyle:borderStyle borderDashPattern:NULL];
}

- (UIImage *)ch_imageByBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin borderStyle:(CHUIImageBorderStyle)borderStyle borderDashPattern:(const CGFloat *)borderDashPattern {
    if (borderStyle == CHUIImageBorderStyleAll || borderStyle == (CHUIImageBorderStyleTop | CHUIImageBorderStyleLeft | CHUIImageBorderStyleBottom | CHUIImageBorderStyleRight)) return [self ch_imageByRoundCornerRadius:0 corners:UIRectCornerAllCorners borderWidth:borderWidth borderColor:borderColor borderLineJoin:kCGLineJoinMiter borderDashPattern:borderDashPattern];
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth > minSize) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (borderStyle & CHUIImageBorderStyleTop) {
        [path moveToPoint:CGPointMake(0, borderWidth / 2)];
        [path addLineToPoint:CGPointMake(self.size.width, borderWidth / 2)];
    }
    
    if (borderStyle & CHUIImageBorderStyleLeft) {
        [path moveToPoint:CGPointMake(borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(borderWidth / 2, self.size.height)];
    }
    
    if (borderStyle & CHUIImageBorderStyleBottom) {
        [path moveToPoint:CGPointMake(0, self.size.height - borderWidth / 2)];
        [path addLineToPoint:CGPointMake(self.size.width, self.size.height - borderWidth / 2)];
    }
    
    if (borderStyle & CHUIImageBorderStyleRight) {
        [path moveToPoint:CGPointMake(self.size.width - borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(self.size.width - borderWidth / 2, self.size.height)];
    }
    
    [path closePath];
    path.lineWidth = borderWidth;
    path.lineJoinStyle = borderLineJoin;
    if (borderDashPattern) {
        [path setLineDash:borderDashPattern count:2 phase:0];
    }
    
    [self drawInRect:CHCGRectMakeWithSize(self.size)];
    if (borderColor) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    }
    [path stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
