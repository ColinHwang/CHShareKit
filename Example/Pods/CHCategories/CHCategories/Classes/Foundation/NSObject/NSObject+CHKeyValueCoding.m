//
//  NSObject+CHKeyValueCoding.m
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//

#import "NSObject+CHKeyValueCoding.h"
#import "NSNumber+CHBase.h"

@implementation NSObject (CHKeyValueCoding)

- (void)ch_setBoolValue:(BOOL)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithBool:value] forKey:key];  // @() may be undefine value
}

- (BOOL)ch_boolValueForKey:(NSString *)key {
    return [[self valueForKey:key] boolValue];
}

- (void)ch_setBoolValue:(BOOL)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithBool:value] forKeyPath:keyPath];
}

- (BOOL)ch_boolValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] boolValue];
}

- (void)ch_setCharValue:(char)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithChar:value] forKey:key];
}

- (char)ch_charValueForKey:(NSString *)key {
    return [[self valueForKey:key] charValue];
}

- (void)ch_setCharValue:(char)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithChar:value] forKeyPath:keyPath];
}

- (char)ch_charValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] charValue];
}

- (void)ch_setUnsignedCharValue:(unsigned char)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithUnsignedChar:value] forKey:key];
}

- (unsigned char)ch_unsignedCharValueForKey:(NSString *)key {
    return [[self valueForKey:key] unsignedCharValue];
}

- (void)ch_setUnsignedCharValue:(unsigned char)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithUnsignedChar:value] forKeyPath:keyPath];
}

- (unsigned char)ch_unsignedCharValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] unsignedCharValue];
}

- (void)ch_setShortValue:(short)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithShort:value] forKey:key];
}

- (short)ch_shortValueForKey:(NSString *)key {
    return [[self valueForKey:key] shortValue];
}

- (void)ch_setShortValue:(short)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithShort:value] forKeyPath:keyPath];
}

- (short)ch_shortValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] shortValue];
}

- (void)ch_setUnsignedShortValue:(unsigned short)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithUnsignedShort:value] forKey:key];
}

- (unsigned short)ch_unsignedShortValueForKey:(NSString *)key {
    return [[self valueForKey:key] unsignedShortValue];
}

- (void)ch_setUnsignedShortValue:(unsigned short)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithUnsignedShort:value] forKeyPath:keyPath];
}

- (unsigned short)ch_unsignedShortValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] unsignedShortValue];
}

- (void)ch_setIntValue:(int)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithInt:value] forKey:key];
}

- (int)ch_intValueForKey:(NSString *)key {
    return [[self valueForKey:key] intValue];
}

- (void)ch_setIntValue:(int)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithInt:value] forKeyPath:keyPath];
}

- (int)ch_intValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] intValue];
}

- (void)ch_setUnsignedIntValue:(unsigned int)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithUnsignedInt:value] forKey:key];
}

- (unsigned int)ch_unsignedIntValueForKey:(NSString *)key {
    return [[self valueForKey:key] unsignedIntValue];
}

- (void)ch_setUnsignedIntValue:(unsigned int)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithUnsignedInt:value] forKeyPath:keyPath];
}

- (unsigned int)ch_unsignedIntValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] unsignedIntValue];
}

- (void)ch_setLongValue:(long)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithLong:value] forKey:key];
}

- (long)ch_longValueForKey:(NSString *)key {
    return [[self valueForKey:key] longValue];
}

- (void)ch_setLongValue:(long)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithLong:value] forKeyPath:keyPath];
}

- (long)ch_longValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] longValue];
}

- (void)ch_setUnsignedLongValue:(unsigned long)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithUnsignedLong:value] forKey:key];
}

- (unsigned long)ch_unsignedLongValueForKey:(NSString *)key {
    return [[self valueForKey:key] unsignedLongValue];
}

- (void)ch_setUnsignedLongValue:(unsigned long)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithUnsignedLong:value] forKeyPath:keyPath];
}

- (unsigned long)ch_unsignedLongValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] unsignedLongValue];
}

- (void)ch_setLongLongValue:(long long)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithLongLong:value] forKey:key];
}

- (long long)ch_longLongValueForKey:(NSString *)key {
    return [[self valueForKey:key] longLongValue];
}

- (void)ch_setLongLongValue:(long long)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithLongLong:value] forKeyPath:keyPath];
}

- (long long)ch_longLongValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] longLongValue];
}

- (void)ch_setUnsignedLongLongValue:(unsigned long long)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithUnsignedLongLong:value] forKey:key];
}

- (unsigned long long)ch_unsignedLongLongValueForKey:(NSString *)key {
    return [[self valueForKey:key] unsignedLongLongValue];
}

- (void)ch_setUnsignedLongLongValue:(unsigned long long)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithUnsignedLongLong:value] forKeyPath:keyPath];
}

- (unsigned long long)ch_unsignedLongLongValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] unsignedLongLongValue];
}

- (void)ch_setFloatValue:(float)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithFloat:value] forKey:key];
}

- (float)ch_floatValueForKey:(NSString *)key {
    return [[self valueForKey:key] floatValue];
}

- (void)ch_setFloatValue:(float)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithFloat:value] forKeyPath:keyPath];
}

- (float)ch_floatValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] floatValue];
}

- (void)ch_setDoubleValue:(double)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithDouble:value] forKey:key];
}

- (double)ch_doubleValueForKey:(NSString *)key {
    return [[self valueForKey:key] doubleValue];
}

- (void)ch_setDoubleValue:(double)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithDouble:value] forKeyPath:keyPath];
}

- (double)ch_doubleValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] doubleValue];
}

- (void)ch_setIntegerValue:(NSInteger)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithInteger:value] forKey:key];
}

- (NSInteger)ch_integerValueForKey:(NSString *)key {
    return [[self valueForKey:key] integerValue];
}

- (void)ch_setIntegerValue:(NSInteger)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithInteger:value] forKeyPath:keyPath];
}

- (NSInteger)ch_integerValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] integerValue];
}

- (void)ch_setUnsignedIntegerValue:(NSUInteger)value forKey:(NSString *)key {
    [self setValue:[NSNumber numberWithUnsignedInteger:value] forKey:key];
}

- (NSUInteger)ch_unsignedIntegerValueForKey:(NSString *)key {
    return [[self valueForKey:key] unsignedIntegerValue];
}

- (void)ch_setUnsignedIntegerValue:(NSUInteger)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber numberWithUnsignedInteger:value] forKeyPath:keyPath];
}

- (NSUInteger)ch_unsignedIntegerValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] unsignedIntegerValue];
}

- (void)ch_setCGFloatValue:(CGFloat)value forKey:(NSString *)key {
    [self setValue:[NSNumber ch_numberWithCGFloat:value] forKey:key];
}

- (CGFloat)ch_CGFloatValueForKey:(NSString *)key {
    return [[self valueForKey:key] ch_CGFloatValue];
}

- (void)ch_setCGFloatValue:(CGFloat)value forKeyPath:(NSString *)keyPath {
    [self setValue:[NSNumber ch_numberWithCGFloat:value] forKeyPath:keyPath];
}

- (CGFloat)ch_CGFloatValueForKeyPath:(NSString *)keyPath {
    return [[self valueForKeyPath:keyPath] ch_CGFloatValue];
}

@end
