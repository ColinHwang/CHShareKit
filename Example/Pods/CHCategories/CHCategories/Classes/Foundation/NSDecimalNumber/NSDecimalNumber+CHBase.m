//
//  NSDecimalNumber+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/3.
//

#import "NSDecimalNumber+CHBase.h"

@implementation NSDecimalNumber (CHBase)

#pragma maek - Base

#pragma mark - Round
+ (NSDecimalNumber *)ch_decimalNumberWithFloat:(float)value roundingScale:(short)scale {
    return [[[NSDecimalNumber alloc] initWithFloat:value] ch_roundToScale:scale];
}

+ (NSDecimalNumber *)ch_decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode {
    return [[[NSDecimalNumber alloc] initWithFloat:value] ch_roundToScale:scale mode:mode];
}

+ (NSDecimalNumber *)ch_decimalNumberWithDouble:(double)value roundingScale:(short)scale {
    return [[[NSDecimalNumber alloc] initWithDouble:value] ch_roundToScale:scale];
}

+ (NSDecimalNumber *)ch_decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode {
    return [[[NSDecimalNumber alloc] initWithDouble:value] ch_roundToScale:scale mode:mode];
}

- (NSDecimalNumber *)ch_roundToScale:(short)scale {
    return [self ch_roundToScale:scale mode:NSRoundPlain];
}

- (NSDecimalNumber *)ch_roundToScale:(short)scale mode:(NSRoundingMode)roundingMode {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    return [self decimalNumberByRoundingAccordingToBehavior:handler];
}

@end
