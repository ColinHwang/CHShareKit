//
//  UIScreen+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/9.
//  
//

#import "UIScreen+CHBase.h"
#import "UIDevice+CHBase.h"

const CGSize CHUIScreenSizeInPoint320X480 = {320, 480};
const CGSize CHUIScreenSizeInPoint320X568 = {320, 568};
const CGSize CHUIScreenSizeInPoint375X667 = {375, 667};
const CGSize CHUIScreenSizeInPoint375X812 = {375, 812};
const CGSize CHUIScreenSizeInPoint414X736 = {414, 736};
const CGSize CHUIScreenSizeInPoint414X896 = {414, 896};

@implementation UIScreen (CHBase)

#pragma mark - Base
+ (CGFloat)ch_screenScale {
    static CGFloat screenScale = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ 
        if ([NSThread isMainThread]) {
            screenScale = [[UIScreen mainScreen] scale];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                screenScale = [[UIScreen mainScreen] scale];
            });
        }
    });
    return screenScale;
}

- (CGFloat)ch_currentWidth {
    return [self ch_currentBounds].size.width;
}

- (CGFloat)ch_currentHeight {
    return [self ch_currentBounds].size.height;
}

- (CGSize)ch_currentSize {
    return [self ch_currentBounds].size;
}

- (CGRect)ch_currentBounds {
    return [self ch_boundsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (CGRect)ch_boundsForOrientation:(UIInterfaceOrientation)orientation {
    CGRect bounds = [self bounds];
    // 横屏
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat buffer = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = buffer;
    }
    return bounds;
}

- (CGSize)ch_sizeInPoint {
    CGSize size = CGSizeZero;
    
    CGFloat scale = [UIScreen ch_screenScale];
    
    if ([self respondsToSelector:@selector(nativeBounds)]) {
        size = CGSizeMake(self.nativeBounds.size.width / scale, self.nativeBounds.size.height / scale);
    } else {
        size = self.bounds.size;
        size.width /= scale;
        size.height /= scale;
    }
    
    if (size.height < size.width) {
        CGFloat tmp = size.height;
        size.height = size.width;
        size.width = tmp;
    }
    
    return size;
}

- (CGSize)ch_sizeInPixel {
    /*
     https://www.theiphonewiki.com
     */
    CGSize size = CGSizeZero;
    
    if ([[UIScreen mainScreen] isEqual:self]) {
        NSString *model = [UIDevice currentDevice].ch_machineModel;
        
        if ([model hasPrefix:@"iPhone"]) {
            if ([model isEqualToString:@"iPhone7,1"]) size = CGSizeMake(1080, 1920);
            else if ([model isEqualToString:@"iPhone8,2"]) size = CGSizeMake(1080, 1920);
            else if ([model isEqualToString:@"iPhone9,2"]) size = CGSizeMake(1080, 1920);
            else if ([model isEqualToString:@"iPhone9,4"]) size = CGSizeMake(1080, 1920);
            else if ([model isEqualToString:@"iPhone10,2"]) size = CGSizeMake(1080, 1920);
            else if ([model isEqualToString:@"iPhone10,3"]) size = CGSizeMake(1125, 2436);
            else if ([model isEqualToString:@"iPhone10,5"]) size = CGSizeMake(1080, 1920);
            else if ([model isEqualToString:@"iPhone10,6"]) size = CGSizeMake(1125, 2436);
            else if ([model isEqualToString:@"iPhone11,2"]) size = CGSizeMake(1125, 2436);
            else if ([model isEqualToString:@"iPhone11,4"]) size = CGSizeMake(1242, 2688);
            else if ([model isEqualToString:@"iPhone11,6"]) size = CGSizeMake(1242, 2688);
            else if ([model isEqualToString:@"iPhone11,8"]) size = CGSizeMake(828, 1792);
        } else if ([model hasPrefix:@"iPad"]) {
            if ([model isEqualToString:@"iPad6,7"]) size = CGSizeMake(2048, 2732);
            else if ([model isEqualToString:@"iPad6,8"]) size = CGSizeMake(2048, 2732);
            else if ([model isEqualToString:@"iPad7,1"]) size = CGSizeMake(2048, 2732);
            else if ([model isEqualToString:@"iPad7,2"]) size = CGSizeMake(2048, 2732);
            else if ([model isEqualToString:@"iPad7,3"]) size = CGSizeMake(1668, 2224);
            else if ([model isEqualToString:@"iPad7,4"]) size = CGSizeMake(1668, 2224);
            else if ([model isEqualToString:@"iPad7,5"]) size = CGSizeMake(1536, 2048);
            else if ([model isEqualToString:@"iPad7,6"]) size = CGSizeMake(1536, 2048);
            else if ([model isEqualToString:@"iPad8,1"]) size = CGSizeMake(1668, 2388);
            else if ([model isEqualToString:@"iPad8,2"]) size = CGSizeMake(1668, 2388);
            else if ([model isEqualToString:@"iPad8,3"]) size = CGSizeMake(1668, 2388);
            else if ([model isEqualToString:@"iPad8,4"]) size = CGSizeMake(1668, 2388);
            else if ([model isEqualToString:@"iPad8,5"]) size = CGSizeMake(2048, 2732);
            else if ([model isEqualToString:@"iPad8,6"]) size = CGSizeMake(2048, 2732);
            else if ([model isEqualToString:@"iPad8,7"]) size = CGSizeMake(2048, 2732);
            else if ([model isEqualToString:@"iPad8,8"]) size = CGSizeMake(2048, 2732);
        }
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        if ([self respondsToSelector:@selector(nativeBounds)]) {
            size = self.nativeBounds.size;
        } else {
            size = self.bounds.size;
            size.width *= self.scale;
            size.height *= self.scale;
        }
        
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    }
    return size;
}

- (CGFloat)ch_pixelsPerInch {
    /*
     https://www.theiphonewiki.com
     */
    if (![[UIScreen mainScreen] isEqual:self]) return 326;
    
    static CGFloat ppi = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary<NSString*, NSNumber *> *dict = @{
                                                      @"Watch1,1" : @290, // @"Apple Watch 38mm",
                                                      @"Watch1,2" : @302, // @"Apple Watch 42mm",
                                                      @"Watch2,3" : @290, // @"Apple Watch Series 2 38mm",
                                                      @"Watch2,4" : @302, // @"Apple Watch Series 2 42mm",
                                                      @"Watch2,6" : @290, // @"Apple Watch Series 1 38mm",
                                                      @"Watch2,7" : @302, // @"Apple Watch Series 1 42mm",
                                                      @"Watch3,1" : @290, // @"Apple Watch Series 3 38mm (Cellular)",
                                                      @"Watch3,2" : @302, // @"Apple Watch Series 3 42mm (Cellular)",
                                                      @"Watch3,3" : @290, // @"Apple Watch Series 3 38mm",
                                                      @"Watch3,4" : @302, // @"Apple Watch Series 3 42mm",
                                                      @"Watch4,1" : @326, // @"Apple Watch Series 4 40mm",
                                                      @"Watch4,2" : @326, // @"Apple Watch Series 4 44mm",
                                                      @"Watch4,3" : @326, // @"Apple Watch Series 4 40mm (Cellular)",
                                                      @"Watch4,4" : @326, // @"Apple Watch Series 4 44mm (Cellular)",
                                                      
                                                      @"iPod1,1" : @163, // @"iPod touch 1",
                                                      @"iPod2,1" : @163, // @"iPod touch 2",
                                                      @"iPod3,1" : @163, // @"iPod touch 3",
                                                      @"iPod4,1" : @326, // @"iPod touch 4",
                                                      @"iPod5,1" : @326, // @"iPod touch 5",
                                                      @"iPod7,1" : @326, // @"iPod touch 6",
                                                      
                                                      @"iPhone1,1" : @163, // @"iPhone 1G",
                                                      @"iPhone1,2" : @163, // @"iPhone 3G",
                                                      @"iPhone2,1" : @163, // @"iPhone 3GS",
                                                      @"iPhone3,1" : @326, // @"iPhone 4 (GSM)",
                                                      @"iPhone3,2" : @326, // @"iPhone 4",
                                                      @"iPhone3,3" : @326, // @"iPhone 4 (CDMA)",
                                                      @"iPhone4,1" : @326, // @"iPhone 4S",
                                                      @"iPhone5,1" : @326, // @"iPhone 5 (GSM)",
                                                      @"iPhone5,2" : @326, // @"iPhone 5 (CDMA)",
                                                      @"iPhone5,3" : @326, // @"iPhone 5c (GSM)",
                                                      @"iPhone5,4" : @326, // @"iPhone 5c (Global)",
                                                      @"iPhone6,1" : @326, // @"iPhone 5s (GSM)",
                                                      @"iPhone6,2" : @326, // @"iPhone 5s (Global)",
                                                      @"iPhone7,1" : @401, // @"iPhone 6 Plus",
                                                      @"iPhone7,2" : @326, // @"iPhone 6",
                                                      @"iPhone8,1" : @326, // @"iPhone 6s",
                                                      @"iPhone8,2" : @401, // @"iPhone 6s Plus",
                                                      @"iPhone8,4" : @326, // @"iPhone SE",
                                                      @"iPhone9,1" : @326, // @"iPhone 7",
                                                      @"iPhone9,2" : @401, // @"iPhone 7 Plus",
                                                      @"iPhone9,3" : @326, // @"iPhone 7",
                                                      @"iPhone9,4" : @401, // @"iPhone 7 Plus",
                                                      @"iPhone10,1" : @326, // @"iPhone 8",
                                                      @"iPhone10,2" : @401, // @"iPhone 8 Plus",
                                                      @"iPhone10,3" : @458, // @"iPhone X",
                                                      @"iPhone10,4" : @326, // @"iPhone 8",
                                                      @"iPhone10,5" : @401, // @"iPhone 8 Plus",
                                                      @"iPhone10,6" : @458, // @"iPhone X",
                                                      @"iPhone11,2" : @458, // @"iPhone XS",
                                                      @"iPhone11,4" : @458, // @"iPhone XS Max",
                                                      @"iPhone11,6" : @458, // @"iPhone XS Max",
                                                      @"iPhone11,8" : @326, // @"iPhone XR",
                                                      
                                                      @"iPad1,1" : @132, // @"iPad 1",
                                                      @"iPad2,1" : @132, // @"iPad 2 (WiFi)",
                                                      @"iPad2,2" : @132, // @"iPad 2 (GSM)",
                                                      @"iPad2,3" : @132, // @"iPad 2 (CDMA)",
                                                      @"iPad2,4" : @132, // @"iPad 2 (32nm)",
                                                      @"iPad2,5" : @264, // @"iPad mini 1 (WiFi)",
                                                      @"iPad2,6" : @264, // @"iPad mini 1 (GSM)",
                                                      @"iPad2,7" : @264, // @"iPad mini 1 (CDMA)",
                                                      @"iPad3,1" : @324, // @"iPad 3 (WiFi)",
                                                      @"iPad3,2" : @324, // @"iPad 3 (CDMA)",
                                                      @"iPad3,3" : @324, // @"iPad 3 (GSM)",
                                                      @"iPad3,4" : @324, // @"iPad 4 (WiFi)",
                                                      @"iPad3,5" : @324, // @"iPad 4 (GSM)",
                                                      @"iPad3,6" : @324, // @"iPad 4 (CDMA)",
                                                      @"iPad4,1" : @324, // @"iPad Air (WiFi)",
                                                      @"iPad4,2" : @324, // @"iPad Air (Cellular)",
                                                      @"iPad4,3" : @324, // @"iPad Air (China)",
                                                      @"iPad4,4" : @264, // @"iPad mini 2 (WiFi)",
                                                      @"iPad4,5" : @264, // @"iPad mini 2 (Cellular)",
                                                      @"iPad4,6" : @264, // @"iPad mini 2 (China)",
                                                      @"iPad4,7" : @264, // @"iPad mini 3 (WiFi)",
                                                      @"iPad4,8" : @264, // @"iPad mini 3 (Cellular)",
                                                      @"iPad4,9" : @264, // @"iPad mini 3 (China)",
                                                      @"iPad5,1" : @264, // @"iPad mini 4",
                                                      @"iPad5,2" : @264, // @"iPad mini 4",
                                                      @"iPad5,3" : @324, // @"iPad Air 2 (WiFi)",
                                                      @"iPad5,4" : @324, // @"iPad Air 2 (Cellular)",
                                                      @"iPad6,3" : @324, // @"iPad Pro 9.7 inch (WiFi)",
                                                      @"iPad6,4" : @324, // @"iPad Pro 9.7 inch (Cellular)",
                                                      @"iPad6,7" : @264, // @"iPad Pro 12.9 inch (WiFi)",
                                                      @"iPad6,8" : @264, // @"iPad Pro 12.9 inch (Cellular)",
                                                      @"iPad6,11" : @264, // @"iPad 5 (WiFi)",
                                                      @"iPad6,12" : @264, // @"iPad 5 (Cellular)",
                                                      @"iPad7,1" : @264, // @"iPad Pro 12.9 inch 2 (WiFi)",
                                                      @"iPad7,2" : @264, // @"iPad Pro 12.9 inch 2 (Cellular)",
                                                      @"iPad7,3" : @264, // @"iPad Pro 10.5 inch (WiFi)",
                                                      @"iPad7,4" : @264, // @"iPad Pro 10.5 inch (Cellular)",
                                                      @"iPad7,5" : @264, // @"iPad 6 (WiFi)",
                                                      @"iPad7,6" : @264, // @"iPad 6 (Cellular)",
                                                      @"iPad8,1" : @264, // @"iPad Pro 11 inch (WiFi)",
                                                      @"iPad8,2" : @264, // @"iPad Pro 11 inch (WiFi)",
                                                      @"iPad8,3" : @264, // @"iPad Pro 11 inch (Cellular)",
                                                      @"iPad8,4" : @264, // @"iPad Pro 11 inch (Cellular)",
                                                      @"iPad8,5" : @264, // @"iPad Pro 12.9 inch 3 (WiFi)",
                                                      @"iPad8,6" : @264, // @"iPad Pro 12.9 inch 3 (WiFi)",
                                                      @"iPad8,7" : @264, // @"iPad Pro 12.9 inch 3 (Cellular)",
                                                      @"iPad8,8" : @264, // @"iPad Pro 12.9 inch 3 (Cellular)",
                                                      };
        NSString *model = [UIDevice currentDevice].ch_machineModel;
        if (model) {
            ppi = [dict[model] doubleValue];
        }
        if (ppi == 0) ppi = 326;
    });
    return ppi;
}

@end
