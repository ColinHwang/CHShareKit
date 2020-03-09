//
//  NSArray+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2020/1/3.
//  Base

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (CHBase)

#pragma mark - Base
/**
 获取数组的范围
 */
@property (nonatomic, readonly) NSRange ch_rangeOfAll;

/**
 获取数组的索引集
 */
@property (nonatomic, readonly) NSIndexSet *ch_indexesOfAll;

/**
 通过索引, 获取数组内的一个元素(索引越界, 返回nil)

 @param index 索引
 @return 数组内一个元素(索引越界, 返回nil)
 */
- (nullable ObjectType)ch_objectOrNilAtIndex:(NSUInteger)index;

/**
 随机获取数组内的一个元素(数组为空则为nil)

 @return 数组内一个元素(数组为空则为nil)
 */
- (nullable ObjectType)ch_randomObject;

/**
 随机获取数组内的指定个数的元素(元素或为重复, 指定个数大于数组个数则为空数组)

 @param count 指定个数
 @return 包含随机元素的新数组(指定个数大于数组个数则为空数组)
 */
- (NSArray<ObjectType> *)ch_randomObjectsInCount:(NSUInteger)count;

#pragma mark - Enumerate
/**
 遍历数组(类似`enumerateObjectsUsingBlock:`, 多维数组则递归遍历子节点)

 @param block 遍历处理回调(obj:元素, indexPath:绝对索引[元素在维度完整数组中的索引, 例:0-2-1], idx:相对索引[元素在当前维度数组的索引, 例:1], *stop:是否停止遍历)
 */
- (void)ch_enumerateObjectsUsingBlock:(void (^)(id obj, NSIndexPath *indexPath, NSUInteger idx, BOOL *stop))block;

/**
 根据遍历方式及是否递归遍历子节点, 遍历数组

 @param opts 遍历方式
 @param recursive  是否递归遍历子节点
 @param block 遍历处理回调(obj:元素, indexPath:绝对索引[元素在完整维度数组中的索引, 例:0-2-1], idx:相对索引[元素在当前维度数组的索引, 例:1], *stop:是否停止遍历)
 */
- (void)ch_enumerateObjectsWithOptions:(NSEnumerationOptions)opts
                             recursive:(BOOL)recursive
                            usingBlock:(void (^)(id obj, NSIndexPath *indexPath, NSUInteger idx, BOOL *stop))block;

#pragma mark - Contain
/**
 根据指定范围、遍历方式及是否递归遍历子节点, 遍历数组

 @param indexes 范围
 @param opts 遍历方式
 @param recursive 是否递归遍历子节点
 @param block 遍历处理回调(obj:元素, indexPath:绝对索引[元素在完整维度数组中的索引, 例:0-2-1], idx:相对索引[元素在当前维度数组的索引, 例:1], *stop:是否停止遍历)
 */
- (void)ch_enumerateObjectsAtIndexes:(NSIndexSet *)indexes
                             options:(NSEnumerationOptions)opts
                           recursive:(BOOL)recursive
                          usingBlock:(void (^)(id obj, NSIndexPath *indexPath, NSUInteger idx, BOOL *stop))block;

/**
 判断数组是否包含指定的索引

 @param index 指定的索引
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsIndex:(NSUInteger)index;

/**
 判断数组是否包含指定的索引集

 @param indexes 指定的索引集
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsIndexes:(NSIndexSet *)indexes;

/**
 判断数组内是否包含等于指定字符的字符元素

 @param string 指定字符
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsString:(NSString *)string;

/**
 判断数组内是否包含指定元素
 
 @param block 判断处理回调(返回YES, 判断包含, 停止遍历, obj:元素, idx:索引)
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjectUsingBlock:(BOOL (^)(ObjectType obj, NSUInteger idx))block;

/**
 根据遍历方式, 判断数组内是否包含指定元素
 
 @param opts 遍历方式
 @param block 判断处理回调(返回YES, 判断包含, 否则停止遍历, obj:元素, idx:索引)
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjectWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(ObjectType obj, NSUInteger idx))block;

/**
 根据指定范围和遍历方式, 判断数组内是否包含指定元素

 @param indexes 范围
 @param opts 遍历方式
 @param block 判断处理回调(返回YES, 判断包含, 否则停止遍历, obj:元素, idx:索引)
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjectAtIndexes:(NSIndexSet *)indexes
                           options:(NSEnumerationOptions)opts
                        usingBlock:(BOOL (^)(ObjectType obj, NSUInteger idx))block;

/**
 根据指定范围、遍历方式及是否递归遍历子节点, 判断数组内是否包含指定元素
 
 @param indexes 范围
 @param opts 遍历方式
 @param recursive 是否递归遍历子节点
 @param block 判断处理回调(返回YES, 判断包含, 否则停止遍历, obj:元素, indexPath:绝对索引[元素在完整维度数组中的索引, 例:0-2-1], idx:相对索引[元素在当前维度数组的索引, 例:1])
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjectAtIndexes:(NSIndexSet *)indexes
                           options:(NSEnumerationOptions)opts
                         recursive:(BOOL)recursive
                        usingBlock:(BOOL (^)(id obj, NSIndexPath *indexPath, NSUInteger idx))block;

/**
 判断数组内是否包含指定元素集

 @param otherObjects 指定元素集
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjects:(NSArray<ObjectType> *)otherObjects;

/**
 判断数组内是否包含指定元素集

 @param otherObjects 指定元素集
 @param block 判断处理回调(返回YES, 判断包含, 否则停止遍历, obj:元素, idx:索引, otherObj:指定元素, otherIdx:指定元素索引)
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjects:(NSArray<ObjectType> *)otherObjects
                usingBlock:(BOOL (^)(ObjectType obj, NSUInteger idx, ObjectType otherObj, NSUInteger otherIdx))block;

/**
 根据遍历方式, 判断数组内是否包含指定元素集

 @param opts 遍历方式
 @param otherObjects 指定元素集
 @param block 判断处理回调(返回YES, 判断包含, 否则停止遍历, obj:元素, idx:索引, otherObj:指定元素, otherIdx:指定元素索引)
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjectsWithOptions:(NSEnumerationOptions)opts
                         otherObjects:(NSArray<ObjectType> *)otherObjects
                           usingBlock:(BOOL (^)(ObjectType obj, NSUInteger idx, ObjectType otherObj, NSUInteger otherIdx))block;

/**
 根据指定范围和遍历方式, 判断数组内是否包含指定元素集

 @param indexes 范围
 @param opts 遍历方式
 @param otherObjects 指定元素集
 @param block 判断处理回调(返回YES, 判断包含, 否则停止遍历, obj:元素, idx:索引, otherObj:指定元素, otherIdx:指定元素索引)
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjectsAtIndexes:(NSIndexSet *)indexes
                            options:(NSEnumerationOptions)opts
                       otherObjects:(NSArray<ObjectType> *)otherObjects
                         usingBlock:(BOOL (^)(ObjectType obj, NSUInteger idx, ObjectType otherObj, NSUInteger otherIdx))block;

/**
 根据指定范围、遍历方式及是否递归遍历子节点, 判断数组内是否包含指定元素集

 @param indexes 范围
 @param opts 遍历方式
 @param recursive 是否递归遍历子节点
 @param otherObjects 指定元素集
 @param block 判断处理回调(返回YES, 判断包含, 否则停止遍历, obj:元素, indexPath:绝对索引[元素在完整维度数组中的索引, 例:0-2-1], idx:相对索引[元素在当前维度数组的索引, 例:1], otherObj:指定元素, otherIndexPath:指定元素绝对索引, otherIdx:指定元素相对索引)
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsObjectsAtIndexes:(NSIndexSet *)indexes
                            options:(NSEnumerationOptions)opts
                          recursive:(BOOL)recursive
                       otherObjects:(NSArray<ObjectType> *)otherObjects
                         usingBlock:(BOOL (^)(ObjectType obj, NSIndexPath *indexPath, NSUInteger idx, ObjectType otherObj, NSIndexPath *otherIndexPath, NSUInteger otherIdx))block;

#pragma mark - Deduplicate
/**
 获取去重后的数组

 @return 去重后的数组
 */
- (NSArray<ObjectType> *)ch_deduplicatedArray;

#pragma mark - Filter
/**
 获取过滤处理的数组

 @param block 过滤回调处理(返回YES, 元素保留, 否则移除出数组, obj:元素, idx:索引, *stop:是否停止过滤)
 @return 过滤处理的新数组
 */
- (NSArray<ObjectType> *)ch_filteredArray:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

/**
 根据遍历方式, 获取过滤处理的数组

 @param opts 遍历方式
 @param block block 过滤回调处理(返回YES, 元素保留, 否则移除出数组, obj:元素, idx:索引, *stop:是否停止过滤)
 @return 过滤处理的新数组
 */
- (NSArray<ObjectType> *)ch_filteredArrayWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

#pragma mark - Map
/**
 获取Map处理的数组

 @param block Map回调处理(返回处理后的元素, 返回nil则不添加进新数组, obj:元素, idx:索引, *stop:是否停止)
 @return Map处理的新数组
 */
- (NSArray<id> *)ch_mappedArray:(ObjectType (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

/**
 根据遍历方式, 获取Map处理的数组

 @param opts 遍历方式
 @param block Map回调处理(返回处理后的元素, 返回nil则不添加进新数组, obj:元素, idx:索引, *stop:是否停止)
 @return Map处理的新数组
 */
- (NSArray<id> *)ch_mappedArrayWithOptions:(NSEnumerationOptions)opts usingBlock:(ObjectType (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

#pragma mark - Sort
/**
 指定元素个数，获取随机排序的新数组(保持元素单一性, 指定个数大于数组个数则为空数组)
 
 @param count 指定个数
 @return 元素随机排序的新数组
 */
- (NSArray<ObjectType> *)ch_sortedArrayAtRandomInCount:(NSUInteger)count;

/**
 获取随机排序的新数组
 
 @return 元素随机排序的新数组
 */
- (NSArray<ObjectType> *)ch_sortedArrayAtRandom;

/**
 获取反转排序后的新数组
 
 @return 元素反转排序后的新数组
 */
- (NSArray<ObjectType> *)ch_sortedArrayByReversed;

/**
 获取升序排序的新数组(基本元素数组<int, NSString*, NSIndexPath...>, 元素保持一致性)
 
 @return 元素升序排序的新数组
 */
- (NSArray<ObjectType> *)ch_sortedArrayInAscending;

/**
 获取降序排序的新数组(基本元素数组<int, NSString*, NSIndexPath...>, 元素保持一致性)
 
 @return 元素降序排序的新数组
 */
- (NSArray<ObjectType> *)ch_sortedArrayInDescending;

/**
 根据Keys数组, 获取升序排序的新数组(排序优先级与Keys一致, Keys指向的Values须为基本元素<int, NSString, NSIndexPath...>, 元素保持一致性)
 
 @param keys Keys数组, 指向的Values须为基本元素<int, NSString, NSIndexPath...>
 @return 元素升序排序的新数组
 */
- (NSArray<ObjectType> *)ch_sortedArrayInAscendingWithKeys:(NSArray<NSString *> *)keys;

/**
 根据Keys数组, 获取降序排序的新数组(排序优先级与Keys一致, Keys指向的Values须为基本元素<int, NSString, NSIndexPath...>, 元素保持一致性)
 
 @param keys Keys数组, 指向的Values须为基本元素<int, NSString, NSIndexPath...>
 @return 元素降序排序的新数组
 */
- (NSArray<ObjectType> *)ch_sortedArrayInDescendingWithKeys:(NSArray<NSString *> *)keys;

#pragma mark - JSON Array
/**
 将数组元素编码为JSON可用string(NSString/NSNumber/NSDictionary/NSArray)
 
 @return Json string
 */
- (nullable NSString *)ch_JSONStringEncoded;

/**
 将数组元素格式化编码为JSON可用string(带空格)
 
 @return Json string
 */
- (nullable NSString *)ch_JSONPrettyStringEncoded;

#pragma mark - Property List
/**
 根据属性列表data(Property List), 创建数组
 
 @param plist root元素为Array的属性列表data(Property List)
 @return 包含属性列表元素的数组
 */
+ (nullable NSArray<id> *)ch_arrayWithPlistData:(NSData *)plist;

/**
 根据属性列表XML字符(XML Property List), 创建数组
 
 @param plist root元素为Array的属性列表XML字符(XML Property List)
 @return 包含属性列表元素的数组
 */
+ (nullable NSArray<id> *)ch_arrayWithPlistString:(NSString *)plist;

/**
 将数组序列化为属性列表data(Property List)
 
 @return 属性列表data
 */
- (nullable NSData *)ch_plistData;

/**
 将数组序列化为属性列表XML字符(XML Property List)
 
 @return 属性列表XML字符
 */
- (nullable NSString *)ch_plistString;

@end


@interface NSMutableArray<ObjectType> (CHBase)

#pragma mark - Base
/**
 根据指定数组, 创建可变数组(类似‘arrayWithArray:’, 多维数组则递归遍历子节点, 子节点也转为可变数组)

 @param array 指定数组
 @return 可变数组
 */
+ (instancetype)ch_mutableArrayWithArray:(NSArray<ObjectType> *)array;

/**
 将元素加入数组(类似`addObject:`, 元素为空则不执行)

 @param anObject 元素
 */
- (void)ch_addObject:(ObjectType)anObject;

/**
 将元素集加入数组(类似`addObjectsFromArray:`, 元素集为空则不执行)

 @param objects 元素集
 */
- (void)ch_addObjectsFromArray:(NSArray<ObjectType> *)objects;

/**
 将元素插入索引对应的位置(类似`insertObject:atIndex:`, 元素集为空或索引越界则不执行)

 @param anObject 元素
 @param index 索引
 */
- (void)ch_insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

/**
 将元素集插入当前数组索引指定的位置(元素集为空或索引越界则不执行)
 
 @param objects 元素集
 @param index 索引
 */
- (void)ch_insertObjects:(NSArray<ObjectType> *)objects atIndex:(NSUInteger)index;

/**
 将元素集插入当前数组索引集指定的位置(类似`insertObjects:atIndexes:`, 元素集为空或索引越界则不执行)

 @param objects 元素集
 @param indexes 索引集
 */
- (void)ch_insertObjects:(NSArray<ObjectType> *)objects atIndexes:(NSIndexSet *)indexes;

/**
 交换两个索引对应的元素的位置(类似`exchangeObjectAtIndex:withObjectAtIndex:`, 索引越界则不执行)

 @param idx1 索引1
 @param idx2 索引2
 */
- (void)ch_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

/**
 移除数组内的元素(类似`removeObject:`, 元素为空则不执行)

 @param anObject 元素
 */
- (void)ch_removeObject:(ObjectType)anObject;

/**
 移除数组内首元素, 数组为空不执行
 */
- (void)ch_removeFirstObject;

/**
 移除数组内末元素, 数组为空不执行
 */
- (void)ch_removeLastObject;

/**
 根据索引, 移除数组内指定元素(类似`removeObjectAtIndex:`, 索引越界则不执行)

 @param index 索引
 */
- (void)ch_removeObjectAtIndex:(NSUInteger)index;

/**
 根据范围, 移除数组内指定元素(类似`removeObject:inRange:`, 元素为空或索引越界则不执行)

 @param anObject 元素
 @param range 范围
 */
- (void)ch_removeObject:(ObjectType)anObject inRange:(NSRange)range;

/**
 根据元素的内存地址及范围, 移除数组内指定元素(类似`removeObjectIdenticalTo:inRange:`, 元素为空或索引越界则不执行)

 @param anObject 元素
 @param range 范围
 */
- (void)ch_removeObjectIdenticalTo:(ObjectType)anObject inRange:(NSRange)range;

/**
 根据元素的内存地址, 移除数组内指定元素(类似`removeObjectIdenticalTo:`, 元素为空则不执行)

 @param anObject 指定元素
 */
- (void)ch_removeObjectIdenticalTo:(ObjectType)anObject;

/**
 根据元素集, 移除数组内指定元素集(类似`removeObjectsInArray`, 元素为空则不执行)

 @param otherArray 元素集
 */
- (void)ch_removeObjectsInArray:(NSArray<ObjectType> *)otherArray;

/**
 根据范围, 移除数组内指定元素集(类似`removeObjectsInRange:`, 索引越界则不执行)

 @param range 范围
 */
- (void)ch_removeObjectsInRange:(NSRange)range;

/**
 根据索引集, 移除数组内指定元素集(类似`removeObjectsAtIndexes:`, 索引越界则不执行)

 @param indexes 索引集
 */
- (void)ch_removeObjectsAtIndexes:(NSIndexSet *)indexes;

/**
 根据元素, 替换索引对应的元素(类似`replaceObjectAtIndex:withObject:`, 元素为空或索引越界则不执行)

 @param index 索引
 @param anObject 元素
 */
- (void)ch_replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;

/**
 根据范围, 其他数组及其他数组范围, 替换指定范围内的元素(类似`replaceObjectsInRange:withObjectsFromArray:range:`, 范围及其他数组范围可不一致, 索引越界则不执行)

 @param range 范围
 @param otherArray 其他数组
 @param otherRange 其他数组范围
 */
- (void)ch_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<ObjectType> *)otherArray range:(NSRange)otherRange;

/**
 根据范围及其他数组, 替换指定范围内的元素(类似`replaceObjectsInRange:withObjectsFromArray:`, 范围及其他数组范围可不一致, 索引越界则不执行)

 @param range 范围
 @param otherArray 其他数组
 */
- (void)ch_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<ObjectType> *)otherArray;

/**
 根据索引集及元素集, 替换指定的元素(类似`replaceObjectsAtIndexes:withObjects:`, 索引集、元素集为空或索引越界则不执行)

 @param indexes 索引集
 @param objects 元素集
 */
- (void)ch_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<ObjectType> *)objects;

/**
 返回数组内首元素, 同时将其移除出数组(数组为空返回nil)
 
 @return 数组内首元素(数组为空返回nil)
 */
- (nullable ObjectType)ch_popFirstObject;

/**
 返回数组内末元素, 同时将其移除出数组(数组为空返回nil)
 
 @return 数组内末元素(数组为空返回nil)
 */
- (nullable ObjectType)ch_popLastObject;

/**
 将单个元素拼接插入到数组末尾(元素为nil则不执行)
 
 @param anObject 单个元素
 */
- (void)ch_appendObject:(ObjectType)anObject;

/**
 将单个元素拼接插入到数组首部(元素为nil则不执行)
 
 @param anObject 单个元素
 */
- (void)ch_prependObject:(ObjectType)anObject;

/**
 将一组元素拼接插入到数组末尾(元素组为空不执行)
 
 @param objects 一组元素
 */
- (void)ch_appendObjects:(NSArray<ObjectType> *)objects;

/**
 将一组元素拼接插入到数组首部(元素组为空不执行)
 
 @param objects 一组元素
 */
- (void)ch_prependObjects:(NSArray<ObjectType> *)objects;

#pragma mark - Deduplicate
/**
 移除数组中的重复元素
 */
- (void)ch_deduplicate;

#pragma mark - Filter
/**
 过滤数组元素

 @param block 过滤回调处理(返回YES, 元素保留, 否则移除出数组, obj:元素, idx:索引, *stop:是否停止过滤)
 */
- (void)ch_filter:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

/**
 根据遍历方式, 过滤数组元素

 @param opts 遍历方式
 @param block 过滤回调处理(返回NO, 元素移除出数组, 否则不移除, obj:元素, idx:索引, *stop:是否停止过滤)
 */
- (void)ch_filterWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

#pragma mark - Sort
/**
 反转数组内元素(@[ @1, @2, @3 ] -> @[ @3, @2, @1 ])
 */
- (void)ch_reverse;

/**
 随机排列数组内元素(@[ @1, @2, @3 ] -> @[ @2, @3, @1 ])
 */
- (void)ch_shuffle;

/**
 数组元素升序排序(基本元素数组<int, NSString, NSIndexPath...>, 元素保持一致性)
 */
- (void)ch_sortInAscending;

/**
 数组元素降序排序(基本元素数组<int, NSString, NSIndexPath...>, 元素保持一致性)
 */
- (void)ch_sortInDescending;

/**
 根据Keys数组, 数组元素升序排序(排序优先级与Keys一致, Keys指向的Values须为基本元素<int, NSString, NSIndexPath...>, 元素保持一致性)
 
 @param keys Keys数组, 指向的Values须为基本元素<int, NSString, NSIndexPath...>
 */
- (void)ch_sortInAscendingWithKeys:(NSArray<NSString *> *)keys;

/**
 根据Keys数组, 数组元素降序排序(排序优先级与Keys一致, Keys指向的Values须为基本元素<int, NSString, NSIndexPath...>, 元素保持一致性)
 
 @param keys Keys数组, 指向的Values须为基本元素<int, NSString, NSIndexPath...>
 */
- (void)ch_sortInDescendingWithKeys:(NSArray<NSString *> *)keys;

#pragma mark - Property List
/**
 根据属性列表data(Property List), 创建可变数组
 
 @param plist root元素为Array的属性列表data(Property List)
 @return 包含属性列表元素的可变数组
 */
+ (NSMutableArray<id> *)ch_arrayWithPlistData:(NSData *)plist;

/**
 根据属性列表XML字符(XML Property List), 创建可变数组
 
 @param plist root元素为Array的属性列表XML字符(XML Property List)
 @return  包含属性列表元素的可变数组
 */
+ (NSMutableArray<id> *)ch_arrayWithPlistString:(NSString *)plist;

@end

NS_ASSUME_NONNULL_END
