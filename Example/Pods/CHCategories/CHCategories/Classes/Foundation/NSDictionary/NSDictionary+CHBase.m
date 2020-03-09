//
//  NSDictionary+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/3.
//

#import "NSDictionary+CHBase.h"
#import "NSData+CHBase.h"
#import "NSNumber+CHBase.h"

@implementation NSDictionary (CHBase)

#pragma mark - Base
- (NSArray *)ch_allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]; // caseInsensitiveCompare:比较两个字符串大小, 忽略大小写
}

- (NSArray *)ch_allValuesSortedByKeys {
    NSArray *sortedKeys = [self ch_allKeysSorted];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [array addObject:self[key]];
    }
    return [array copy];
}

- (NSDictionary *)ch_entriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) dictionary[key] = value;
    }
    return [dictionary copy];
}

#pragma mark - Check
- (BOOL)ch_containsKey:(id)key {
    if (!key) return NO;
    return [[self allKeys] containsObject:key];
}

- (BOOL)ch_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

#pragma mark - Store
NSNumber *CHNumberFromID(id value) {
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)]; // dot字集
    });
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *lower = ((NSString *)value).lowercaseString;
        if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) return @(YES);
        if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) return @(NO);
        if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"]) return nil;
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            return @(((NSString *)value).doubleValue);
        } else {
            return @(((NSString *)value).longLongValue); // No dot
        }
    }
    return nil;
}

// ARC下, 不允许基本数据类型(bool, int...)转为id类型
#define CHRETURN_VALUE(_type_)                                                   \
if (!key) return defaultValue;                                                   \
id value = self[key];                                                            \
if (!value || value == [NSNull null]) return defaultValue;                       \
if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value)._type_;   \
if ([value isKindOfClass:[NSString class]]) return CHNumberFromID(value)._type_; \
return defaultValue;

- (BOOL)ch_boolValueForKey:(id)key default:(BOOL)defaultValue {
    CHRETURN_VALUE(boolValue);
}

- (char)ch_charValueForKey:(id)key default:(char)defaultValue {
    CHRETURN_VALUE(charValue);
}

- (unsigned char)ch_unsignedCharValueForKey:(id)key default:(unsigned char)defaultValue {
    CHRETURN_VALUE(unsignedCharValue);
}

- (short)ch_shortValueForKey:(id)key default:(short)defaultValue {
    CHRETURN_VALUE(shortValue);
}

- (unsigned short)ch_unsignedShortValueForKey:(id)key default:(unsigned short)defaultValue {
    CHRETURN_VALUE(unsignedShortValue);
}

- (int)ch_intValueForKey:(id)key default:(int)defaultValue {
    CHRETURN_VALUE(intValue);
}

- (unsigned int)ch_unsignedIntValueForKey:(id)key default:(unsigned int)defaultValue {
    CHRETURN_VALUE(unsignedIntValue);
}

- (long)ch_longValueForKey:(id)key default:(long)defaultValue {
    CHRETURN_VALUE(longValue);
}

- (unsigned long)ch_unsignedLongValueForKey:(id)key default:(unsigned long)defaultValue {
    CHRETURN_VALUE(unsignedLongValue);
}

- (long long)ch_longLongValueForKey:(id)key default:(long long)defaultValue {
    CHRETURN_VALUE(longLongValue);
}

- (unsigned long long)ch_unsignedLongLongValueForKey:(id)key default:(unsigned long long)defaultValue {
    CHRETURN_VALUE(unsignedLongLongValue);
}

- (float)ch_floatValueForKey:(id)key default:(float)defaultValue {
    CHRETURN_VALUE(floatValue);
}

- (double)ch_doubleValueForKey:(id)key default:(double)defaultValue {
    CHRETURN_VALUE(doubleValue);
}

- (NSInteger)ch_integerValueForKey:(id)key default:(NSInteger)defaultValue {
    CHRETURN_VALUE(integerValue);
}

- (NSUInteger)ch_unsignedIntegerValueForKey:(id)key default:(NSUInteger)defaultValue {
    CHRETURN_VALUE(unsignedIntegerValue);
}

- (CGFloat)ch_CGFloatValueForKey:(id)key default:(CGFloat)defaultValue {
    CHRETURN_VALUE(ch_CGFloatValue);
}

- (NSNumber *)ch_numberValueForKey:(id)key default:(NSNumber *)defaultValue {
    if (!key) return defaultValue;
    id value = self[key];
    if (!value || value == [NSNull null]) return defaultValue;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return CHNumberFromID(value);
    return defaultValue;
}

- (NSString *)ch_stringValueForKey:(id)key default:(NSString *)defaultValue {
    if (!key) return defaultValue;
    id value = self[key];
    if (!value || value == [NSNull null]) return defaultValue;
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value).description;
    return defaultValue;
}

#pragma mark - JSON Dictionary
- (NSString *)ch_JSONStringEncode {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        if (!error) return JSONString;
    }
    return nil;
}

- (NSString *)ch_JSONPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        if (!error) return JSONString;
    }
    return nil;
}

#pragma mark - Property List
+ (NSDictionary *)ch_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) return dictionary;
    return nil;
}

+ (NSDictionary *)ch_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self ch_dictionaryWithPlistData:data];
}

- (NSData *)ch_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)ch_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.ch_utf8String;
    return nil;
}

@end


@implementation NSMutableDictionary (CHBase)

#pragma mark - Base
- (void)ch_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil || aKey == nil) return;
    
    [self setObject:anObject forKey:aKey];
}

- (id)ch_popObjectForKey:(id)aKey {
    if (!aKey) return nil;
    id value = self[aKey];
    [self removeObjectForKey:aKey];
    return value;
}

- (NSDictionary<id, id> *)ch_popEntriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) {
            [self removeObjectForKey:key];
            dictionary[key] = value;
        }
    }
    return [dictionary copy];
}

#pragma mark - Property List
+ (NSMutableDictionary *)ch_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSMutableDictionary class]]) return dictionary;
    return nil;
}

+ (NSMutableDictionary *)ch_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self ch_dictionaryWithPlistData:data];
}

@end
