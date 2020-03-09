//
//  NSObject+CHDataBind.h
//  CHCategories
//
//  Created by CHwang on 2019/2/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 绑定对象, 可作为临时对象供后续使用
 
 [A ch_setBindingObject:obj forKey:@"key"]
 id object = [A ch_bindingObjectForKey:@"key"]
 */
@interface NSObject (CHDataBind)

@property (readonly, copy) NSArray<NSString *> *ch_allBindingKeys; ///< 获取所有绑定对象的Key集合

/**
 判断是否包含绑定对象的Key

 @param key Key
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsBindingKey:(NSString *)key;

/**
 移除所有绑定对象
 */
- (void)ch_removeAllBindingObjects;

/**
 移除Key对应的绑定对象

 @param key Key
 */
- (void)ch_revomeBindingObjectForKey:(NSString *)key;

/**
 根据Key, 绑定对象(nil则移除)

 @param object 对象
 @param key Key
 */
- (void)ch_setBindingObject:(nullable id)object forKey:(NSString *)key;

/**
 根据Key, 绑定弱引用对象(nil则移除)

 @param object 对象
 @param key Key
 */
- (void)ch_setBindingWeakObject:(nullable id)object forKey:(NSString *)key;

/**
 获取Key对应的绑定对象

 @param key Key
 @return 对象
 */
- (nullable id)ch_bindingObjectForKey:(NSString *)key;

- (void)ch_setBindingBoolValue:(BOOL)value forKey:(NSString *)key;
- (BOOL)ch_bindingBoolValueForKey:(NSString *)key;

- (void)ch_setBindingCharValue:(char)value forKey:(NSString *)key;
- (char)ch_bindingCharValueForKey:(NSString *)key;

- (void)ch_setBindingUnsignedCharValue:(unsigned char)value forKey:(NSString *)key;
- (unsigned char)ch_bindingUnsignedCharValueForKey:(NSString *)key;

- (void)ch_setBindingShortValue:(short)value forKey:(NSString *)key;
- (short)ch_bindingShortValueForKey:(NSString *)key;

- (void)ch_setBindingUnsignedShortValue:(unsigned short)value forKey:(NSString *)key;
- (unsigned short)ch_bindingUnsignedShortValueForKey:(NSString *)key;

- (void)ch_setBindingIntValue:(int)value forKey:(NSString *)key;
- (int)ch_bindingIntValueForKey:(NSString *)key;

- (void)ch_setBindingUnsignedIntValue:(unsigned int)value forKey:(NSString *)key;
- (unsigned int)ch_bindingUnsignedIntValueForKey:(NSString *)key;

- (void)ch_setBindingLongValue:(long)value forKey:(NSString *)key;
- (long)ch_bindingLongValueForKey:(NSString *)key;

- (void)ch_setBindingUnsignedLongValue:(unsigned long)value forKey:(NSString *)key;
- (unsigned long)ch_bindingUnsignedLongValueForKey:(NSString *)key;

- (void)ch_setBindingLongLongValue:(long long)value forKey:(NSString *)key;
- (long long)ch_bindingLongLongValueForKey:(NSString *)key;

- (void)ch_setBindingUnsignedLongLongValue:(unsigned long long)value forKey:(NSString *)key;
- (unsigned long long)ch_bindingUnsignedLongLongValueForKey:(NSString *)key;

- (void)ch_setBindingFloatValue:(float)value forKey:(NSString *)key;
- (float)ch_bindingFloatValueForKey:(NSString *)key;

- (void)ch_setBindingDoubleValue:(double)value forKey:(NSString *)key;
- (double)ch_bindingDoubleValueForKey:(NSString *)key;

- (void)ch_setBindingIntegerValue:(NSInteger)value forKey:(NSString *)key;
- (NSInteger)ch_bindingIntegerValueForKey:(NSString *)key;

- (void)ch_setBindingUnsignedIntegerValue:(NSUInteger)value forKey:(NSString *)key;
- (NSUInteger)ch_bindingUnsignedIntegerValueForKey:(NSString *)key;

- (void)ch_setBindingCGFloatValue:(CGFloat)value forKey:(NSString *)key;
- (CGFloat)ch_bindingCGFloatValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
