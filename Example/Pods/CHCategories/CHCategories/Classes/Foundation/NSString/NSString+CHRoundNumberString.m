//
//  NSString+CHRoundNumberString.m
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//

#import "NSString+CHRoundNumberString.h"
#import "NSDecimalNumber+CHBase.h"

@implementation NSString (CHRoundNumberString)

+ (NSString *)ch_stringFromFloat:(float)value fractionDigits:(NSUInteger)fractionDigits {
    NSNumber *number = [[NSNumber alloc] initWithFloat:value];
    return [NSString ch_stringFromNumber:number fractionDigits:fractionDigits];
}

+ (NSString *)ch_stringFromDouble:(double)value fractionDigits:(NSUInteger)fractionDigits {
    NSNumber *number = [[NSNumber alloc] initWithDouble:value];
    return [NSString ch_stringFromNumber:number fractionDigits:fractionDigits];
}

+ (NSString *)ch_stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setMinimumIntegerDigits:1];
    [numberFormatter setMaximumFractionDigits:fractionDigits];
    [numberFormatter setMinimumFractionDigits:fractionDigits];
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)ch_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber ch_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    return [NSString ch_stringFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)ch_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber ch_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    if (!isPadded) return [NSString stringWithFormat:@"%@", decimalNumber];
    
    return [NSString ch_stringFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)ch_stringFromFloat:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded {
    return [NSString ch_stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:isPadded];
}

+ (NSString *)ch_stringFromFloat:(float)value roundingScale:(short)scale {
    return [NSString ch_stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:NO];
}

+ (NSString *)ch_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber ch_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    return [NSString ch_stringFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)ch_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber ch_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    if (!isPadded) return [NSString stringWithFormat:@"%@", decimalNumber];
    
    return [NSString ch_stringFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)ch_stringFromDouble:(double)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded {
    return [NSString ch_stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:isPadded];
}

+ (NSString *)ch_stringFromDouble:(double)value roundingScale:(short)scale {
    return [NSString ch_stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:NO];
}

@end
