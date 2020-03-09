//
//  NSNumber+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/3.
//

#import "NSNumber+CHBase.h"

@implementation NSNumber (CHBase)

#pragma mark - Base
- (CGFloat)ch_CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return self.doubleValue;
#else
    return self.floatValue;
#endif
}

- (NSString *)ch_stringNumber {
    return [NSString stringWithFormat:@"%@", self];
}

- (NSNumber *)initWithCGFloat:(CGFloat)value {
#if CGFLOAT_IS_DOUBLE
    return [self initWithDouble:value];
#else
    return [self initWithFloat:value];
#endif
}

+ (NSNumber *)ch_numberWithCGFloat:(CGFloat)value {
#if CGFLOAT_IS_DOUBLE
    return [self numberWithDouble:value];
#else
    return [self numberWithFloat:value];
#endif
}

+ (NSNumber *)ch_numberWithString:(NSString *)string {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *str = [string stringByTrimmingCharactersInSet:set];
    if (!str || !str.length) return nil;

    // 特殊处理
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    
    id num = dic[str];
    if (num) {
        if (num == [NSNull null]) return nil;
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str]; // 扫描字符
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num]; // str -> scan -> 16进制num
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

@end
