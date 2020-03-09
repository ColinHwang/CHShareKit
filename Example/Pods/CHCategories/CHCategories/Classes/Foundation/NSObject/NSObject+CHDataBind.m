//
//  NSObject+CHDataBind.m
//  CHCategories
//
//  Created by CHwang on 2019/2/12.
//

#import "NSObject+CHDataBind.h"
#import "NSNumber+CHBase.h"
#import "NSObject+CHBase.h"

/**
 弱引用对象容器, 通过OBJC_ASSOCIATION_ASSIGN关联的对象, 如果对象稍后被释放, 通过objc_getAssociatedObject获取时, 会出现野指针问题, 此时将对象包装进容器类内, 并改为通过强引用方式绑定, 可安全获取原始对象
 */
@interface CHNSObjectWeakObjectContainer : NSObject

@property (nonatomic, weak) id object;

- (instancetype)initWithObject:(id)object;

@end

@implementation CHNSObjectWeakObjectContainer

- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

@end


static const int CH_NS_OBJECT_ALL_BINDING_OBJECTS_KEY;

@implementation NSObject (CHDataBind)

- (NSMutableDictionary<id, id> *)_ch_allBindingObjects {
    NSMutableDictionary *buffer = [self ch_getAssociatedValueForKey:&CH_NS_OBJECT_ALL_BINDING_OBJECTS_KEY];
    if (!buffer) {
        buffer = @{}.mutableCopy;
        [self ch_setAssociatedValue:buffer withKey:&CH_NS_OBJECT_ALL_BINDING_OBJECTS_KEY];
    }
    return buffer;
}

- (NSArray<NSString *> *)ch_allBindingKeys {
    return [[self _ch_allBindingObjects] allKeys];
}

- (BOOL)ch_containsBindingKey:(NSString *)key {
    return [[self ch_allBindingKeys] containsObject:key];
}

- (void)ch_removeAllBindingObjects {
    [[self _ch_allBindingObjects] removeAllObjects];
}

- (void)ch_revomeBindingObjectForKey:(NSString *)key {
    [self ch_setBindingObject:nil forKey:key];
}

- (void)ch_setBindingObject:(id)object forKey:(NSString *)key {
    if (!key.length) return;
    
    if (object) {
        [[self _ch_allBindingObjects] setObject:object forKey:key];
    } else {
        [[self _ch_allBindingObjects] removeObjectForKey:key];
    }
}

- (void)ch_setBindingWeakObject:(id)object forKey:(NSString *)key {
    if (!key.length) return;
    
    if (object) {
        CHNSObjectWeakObjectContainer *container = [[CHNSObjectWeakObjectContainer alloc] initWithObject:object];
        [self ch_setBindingObject:container forKey:key];
    } else {
        [[self _ch_allBindingObjects] removeObjectForKey:key];
    }
}

- (id)ch_bindingObjectForKey:(NSString *)key {
    if (!key.length) return nil;
    
    id storedObj = [[self _ch_allBindingObjects] objectForKey:key];
    if ([storedObj isKindOfClass:[CHNSObjectWeakObjectContainer class]]) {
        storedObj = [(CHNSObjectWeakObjectContainer *)storedObj object];
    }
    return storedObj;
}

- (void)ch_setBindingBoolValue:(BOOL)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (BOOL)ch_bindingBoolValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] boolValue];
}

- (void)ch_setBindingCharValue:(char)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (char)ch_bindingCharValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] charValue];
}

- (void)ch_setBindingUnsignedCharValue:(unsigned char)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (unsigned char)ch_bindingUnsignedCharValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] unsignedCharValue];
}

- (void)ch_setBindingShortValue:(short)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (short)ch_bindingShortValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] shortValue];
}

- (void)ch_setBindingUnsignedShortValue:(unsigned short)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (unsigned short)ch_bindingUnsignedShortValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] unsignedShortValue];
}

- (void)ch_setBindingIntValue:(int)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (int)ch_bindingIntValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] intValue];
}

- (void)ch_setBindingUnsignedIntValue:(unsigned int)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (unsigned int)ch_bindingUnsignedIntValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] unsignedIntValue];
}

- (void)ch_setBindingLongValue:(long)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (long)ch_bindingLongValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] longValue];
}

- (void)ch_setBindingUnsignedLongValue:(unsigned long)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (unsigned long)ch_bindingUnsignedLongValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] unsignedLongValue];
}

- (void)ch_setBindingLongLongValue:(long long)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (long long)ch_bindingLongLongValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] longLongValue];
}

- (void)ch_setBindingUnsignedLongLongValue:(unsigned long long)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (unsigned long long)ch_bindingUnsignedLongLongValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] unsignedLongLongValue];
}

- (void)ch_setBindingFloatValue:(float)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (float)ch_bindingFloatValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] floatValue];
}

- (void)ch_setBindingDoubleValue:(double)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (double)ch_bindingDoubleValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] doubleValue];
}

- (void)ch_setBindingIntegerValue:(NSInteger)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (NSInteger)ch_bindingIntegerValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] integerValue];
}

- (void)ch_setBindingUnsignedIntegerValue:(NSUInteger)value forKey:(NSString *)key {
    [self ch_setBindingObject:@(value) forKey:key];
}

- (NSUInteger)ch_bindingUnsignedIntegerValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] unsignedIntegerValue];
}

- (void)ch_setBindingCGFloatValue:(CGFloat)value forKey:(NSString *)key {
    [self ch_setBindingObject:[NSNumber ch_numberWithCGFloat:value] forKey:key];
}

- (CGFloat)ch_bindingCGFloatValueForKey:(NSString *)key {
    return [[self ch_bindingObjectForKey:key] ch_CGFloatValue];
}

@end
