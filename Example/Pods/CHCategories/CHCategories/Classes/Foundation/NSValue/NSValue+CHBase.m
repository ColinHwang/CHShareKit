//
//  NSValue+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2020/3/4.
//

#import "NSValue+CHBase.h"
#import <CoreGraphics/CoreGraphics.h>

const NSRange CHNSRangeZero = {0, 0};

@implementation NSValue (CHBase)

#pragma mark - Base
+ (NSValue *)ch_valueWithCGColor:(CGColorRef)color {
    return [NSValue valueWithBytes:&color objCType:@encode(CGColorRef)];
}

- (CGColorRef)ch_CGColorValue {
    CGColorRef color;
    [self getValue:&color];
    return color;
}

+ (NSValue *)ch_valueWithSelector:(SEL)selector {
    return [NSValue valueWithPointer:selector];
}

- (SEL)ch_selectorValue {
    return self.pointerValue;
}

@end
