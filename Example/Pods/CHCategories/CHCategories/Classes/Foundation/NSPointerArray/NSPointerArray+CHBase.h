//
//  NSPointerArray+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2018/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSPointerArray (CHBase)

#pragma mark - Base
/**
 获取特定元素的索引, 无返回NSNotFound

 @param pointer 特定元素
 @return 特定元素的索引, 无返回NSNotFound
 */
- (NSUInteger)ch_indexOfPointer:(nullable void *)pointer;

/**
 弱引用数组是否包含特定元素

 @param pointer 特定元素
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsPointer:(nullable void *)pointer;

@end

NS_ASSUME_NONNULL_END
