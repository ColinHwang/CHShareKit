//
//  NSObject+CHKeyValueCoding.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//  KVC

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CHKeyValueCoding)

- (void)ch_setBoolValue:(BOOL)value forKey:(NSString *)key;
- (BOOL)ch_boolValueForKey:(NSString *)key;
- (void)ch_setBoolValue:(BOOL)value forKeyPath:(NSString *)keyPath;
- (BOOL)ch_boolValueForKeyPath:(NSString *)keyPath;

- (void)ch_setCharValue:(char)value forKey:(NSString *)key;
- (char)ch_charValueForKey:(NSString *)key;
- (void)ch_setCharValue:(char)value forKeyPath:(NSString *)keyPath;
- (char)ch_charValueForKeyPath:(NSString *)keyPath;

- (void)ch_setUnsignedCharValue:(unsigned char)value forKey:(NSString *)key;
- (unsigned char)ch_unsignedCharValueForKey:(NSString *)key;
- (void)ch_setUnsignedCharValue:(unsigned char)value forKeyPath:(NSString *)keyPath;
- (unsigned char)ch_unsignedCharValueForKeyPath:(NSString *)keyPath;

- (void)ch_setShortValue:(short)value forKey:(NSString *)key;
- (short)ch_shortValueForKey:(NSString *)key;
- (void)ch_setShortValue:(short)value forKeyPath:(NSString *)keyPath;
- (short)ch_shortValueForKeyPath:(NSString *)keyPath;

- (void)ch_setUnsignedShortValue:(unsigned short)value forKey:(NSString *)key;
- (unsigned short)ch_unsignedShortValueForKey:(NSString *)key;
- (void)ch_setUnsignedShortValue:(unsigned short)value forKeyPath:(NSString *)keyPath;
- (unsigned short)ch_unsignedShortValueForKeyPath:(NSString *)keyPath;

- (void)ch_setIntValue:(int)value forKey:(NSString *)key;
- (int)ch_intValueForKey:(NSString *)key;
- (void)ch_setIntValue:(int)value forKeyPath:(NSString *)keyPath;
- (int)ch_intValueForKeyPath:(NSString *)keyPath;

- (void)ch_setUnsignedIntValue:(unsigned int)value forKey:(NSString *)key;
- (unsigned int)ch_unsignedIntValueForKey:(NSString *)key;
- (void)ch_setUnsignedIntValue:(unsigned int)value forKeyPath:(NSString *)keyPath;
- (unsigned int)ch_unsignedIntValueForKeyPath:(NSString *)keyPath;

- (void)ch_setLongValue:(long)value forKey:(NSString *)key;
- (long)ch_longValueForKey:(NSString *)key;
- (void)ch_setLongValue:(long)value forKeyPath:(NSString *)keyPath;
- (long)ch_longValueForKeyPath:(NSString *)keyPath;

- (void)ch_setUnsignedLongValue:(unsigned long)value forKey:(NSString *)key;
- (unsigned long)ch_unsignedLongValueForKey:(NSString *)key;
- (void)ch_setUnsignedLongValue:(unsigned long)value forKeyPath:(NSString *)keyPath;
- (unsigned long)ch_unsignedLongValueForKeyPath:(NSString *)keyPath;

- (void)ch_setLongLongValue:(long long)value forKey:(NSString *)key;
- (long long)ch_longLongValueForKey:(NSString *)key;
- (void)ch_setLongLongValue:(long long)value forKeyPath:(NSString *)keyPath;
- (long long)ch_longLongValueForKeyPath:(NSString *)keyPath;

- (void)ch_setUnsignedLongLongValue:(unsigned long long)value forKey:(NSString *)key;
- (unsigned long long)ch_unsignedLongLongValueForKey:(NSString *)key;
- (void)ch_setUnsignedLongLongValue:(unsigned long long)value forKeyPath:(NSString *)keyPath;
- (unsigned long long)ch_unsignedLongLongValueForKeyPath:(NSString *)keyPath;

- (void)ch_setFloatValue:(float)value forKey:(NSString *)key;
- (float)ch_floatValueForKey:(NSString *)key;
- (void)ch_setFloatValue:(float)value forKeyPath:(NSString *)keyPath;
- (float)ch_floatValueForKeyPath:(NSString *)keyPath;

- (void)ch_setDoubleValue:(double)value forKey:(NSString *)key;
- (double)ch_doubleValueForKey:(NSString *)key;
- (void)ch_setDoubleValue:(double)value forKeyPath:(NSString *)keyPath;
- (double)ch_doubleValueForKeyPath:(NSString *)keyPath;

- (void)ch_setIntegerValue:(NSInteger)value forKey:(NSString *)key;
- (NSInteger)ch_integerValueForKey:(NSString *)key;
- (void)ch_setIntegerValue:(NSInteger)value forKeyPath:(NSString *)keyPath;
- (NSInteger)ch_integerValueForKeyPath:(NSString *)keyPath;

- (void)ch_setUnsignedIntegerValue:(NSUInteger)value forKey:(NSString *)key;
- (NSUInteger)ch_unsignedIntegerValueForKey:(NSString *)key;
- (void)ch_setUnsignedIntegerValue:(NSUInteger)value forKeyPath:(NSString *)keyPath;
- (NSUInteger)ch_unsignedIntegerValueForKeyPath:(NSString *)keyPath;

- (void)ch_setCGFloatValue:(CGFloat)value forKey:(NSString *)key;
- (CGFloat)ch_CGFloatValueForKey:(NSString *)key;
- (void)ch_setCGFloatValue:(CGFloat)value forKeyPath:(NSString *)keyPath;
- (CGFloat)ch_CGFloatValueForKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
