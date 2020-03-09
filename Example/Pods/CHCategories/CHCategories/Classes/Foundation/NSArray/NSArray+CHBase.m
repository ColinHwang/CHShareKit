//
//  NSArray+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2020/1/3.
//

#import "NSArray+CHBase.h"
#import "NSData+CHBase.h"
#import "NSValue+CHBase.h"

@implementation NSArray (CHBase)

#pragma mark - Base
- (NSRange)ch_rangeOfAll {
    return NSMakeRange(0, self.count);
}

- (NSIndexSet *)ch_indexesOfAll {
    return [NSIndexSet indexSetWithIndexesInRange:self.ch_rangeOfAll];
}

- (id)ch_objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

- (id)ch_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (NSArray<id> *)ch_randomObjectsInCount:(NSUInteger)count {
    NSMutableArray<id> *array = @[].mutableCopy;
    if (!count) return array.copy;
    if (!self.count) return array.copy;
    if (count > self.count) return array.copy;
    
    for (NSUInteger i = 0; i < count; i++) {
        [array ch_addObject:[self ch_randomObject]];
    }
    return [array copy];
}

#pragma mark - Enumerate
- (void)ch_enumerateObjectsUsingBlock:(void (^)(id obj, NSIndexPath *indexPath, NSUInteger idx, BOOL *stop))block {
    [self ch_enumerateObjectsWithOptions:kNilOptions recursive:YES usingBlock:block];
}

- (void)ch_enumerateObjectsWithOptions:(NSEnumerationOptions)opts recursive:(BOOL)recursive usingBlock:(void (^)(id obj, NSIndexPath *indexPath, NSUInteger idx, BOOL *stop))block {
    [self ch_enumerateObjectsAtIndexes:self.ch_indexesOfAll options:opts recursive:recursive usingBlock:block];
}

- (void)ch_enumerateObjectsAtIndexes:(NSIndexSet *)indexes options:(NSEnumerationOptions)opts recursive:(BOOL)recursive usingBlock:(void (^)(id obj, NSIndexPath *indexPath, NSUInteger idx, BOOL *stop))block {
    [self _ch_enumerateObjectsAtIndexes:indexes options:opts recursive:recursive indexPath:nil usingBlock:block];
}

- (BOOL)_ch_enumerateObjectsAtIndexes:(NSIndexSet *)indexes options:(NSEnumerationOptions)opts recursive:(BOOL)recursive indexPath:(NSIndexPath *)indexPath usingBlock:(void (^)(id obj, NSIndexPath *indexPath, NSUInteger idx, BOOL *stop))block {
    __block BOOL allStop = NO;
    
    [self enumerateObjectsAtIndexes:indexes options:opts usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *buffer = nil;
        if (indexPath == nil) {
            buffer = [NSIndexPath indexPathWithIndex:idx];
        } else {
            buffer = [indexPath indexPathByAddingIndex:idx];
        }
        
        if ([obj isKindOfClass:[NSArray class]] && recursive) {
            NSIndexSet *anIndexSet = [(NSArray<id> *)obj ch_indexesOfAll];
            allStop = [obj _ch_enumerateObjectsAtIndexes:anIndexSet options:opts recursive:recursive indexPath:buffer usingBlock:block];
            if (allStop) {
                *stop = YES;
            }
        } else {
            if (block) {
                block(obj, buffer, idx, stop);
            }
            allStop = *stop;
        }
    }];
    return allStop;
}

#pragma mark - Contain
- (BOOL)ch_containsIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    if (!count) return NO;
    return index >= 0 && index < count;
}

- (BOOL)ch_containsIndexes:(NSIndexSet *)indexes {
    if(!indexes.count) return NO;
    
    return [self.ch_indexesOfAll containsIndexes:indexes];
}

- (BOOL)ch_containsString:(NSString *)string {
    if (!string) return NO;
    if ([string isKindOfClass:[NSString class]]) return NO;
    
    return [self ch_containsObjectUsingBlock:^BOOL(NSString *obj, NSUInteger idx) {
        return [obj isEqualToString:string];
    }];
}

- (BOOL)ch_containsObjectUsingBlock:(BOOL (^)(id obj, NSUInteger idx))block {
    return [self ch_containsObjectWithOptions:kNilOptions usingBlock:block];
}

- (BOOL)ch_containsObjectWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(id obj, NSUInteger idx))block {
    return [self ch_containsObjectAtIndexes:self.ch_indexesOfAll options:opts usingBlock:block];
}

- (BOOL)ch_containsObjectAtIndexes:(NSIndexSet *)indexes
                           options:(NSEnumerationOptions)opts
                        usingBlock:(BOOL (^)(id obj, NSUInteger idx))block {
    __block BOOL contains = NO;
    [self enumerateObjectsAtIndexes:indexes options:opts usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block) {
            contains = block(obj, idx);
        }
        
        if (contains) {
            *stop = YES;
        }
    }];
    return contains;
}

- (BOOL)ch_containsObjectAtIndexes:(NSIndexSet *)indexes
                           options:(NSEnumerationOptions)opts
                         recursive:(BOOL)recursive
                        usingBlock:(BOOL (^)(id obj, NSIndexPath *indexPath, NSUInteger idx))block {
    __block BOOL contains = NO;
    [self ch_enumerateObjectsAtIndexes:indexes options:opts recursive:recursive usingBlock:^(id  _Nonnull obj, NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block) {
            contains = block(obj, indexPath, idx);
        }
        
        if (contains) {
            *stop = YES;
        }
    }];
    return contains;
}

- (BOOL)ch_containsObjects:(NSArray<id> *)otherObjects {
    if (!otherObjects.count) return NO;
    if (!self.count) return NO;
    if ([otherObjects isEqualToArray:self]) return YES;
    
    for (id otherObject in otherObjects) {
        if (![self containsObject:otherObject]) return NO;
    }
    return YES;
}

- (BOOL)ch_containsObjects:(NSArray<id> *)otherObjects
                usingBlock:(BOOL (^)(id obj, NSUInteger idx, id otherObj, NSUInteger otherIdx))block {
    return [self ch_containsObjectsWithOptions:kNilOptions otherObjects:otherObjects usingBlock:block];
}

- (BOOL)ch_containsObjectsWithOptions:(NSEnumerationOptions)opts
                         otherObjects:(NSArray<id> *)otherObjects
                           usingBlock:(BOOL (^)(id obj, NSUInteger idx, id otherObj, NSUInteger otherIdx))block {
    return [self ch_containsObjectsAtIndexes:self.ch_indexesOfAll options:opts otherObjects:otherObjects usingBlock:block];
}

- (BOOL)ch_containsObjectsAtIndexes:(NSIndexSet *)indexes
                            options:(NSEnumerationOptions)opts
                       otherObjects:(NSArray<id> *)otherObjects
                         usingBlock:(BOOL (^)(id obj, NSUInteger idx, id otherObj, NSUInteger otherIdx))block {
    if (!otherObjects.count) return NO;
    if (!self.count) return NO;
    if ([otherObjects isEqualToArray:self]) return YES;
    
    __block BOOL allContains = YES;
    NSIndexSet *otherIndexes = otherObjects.ch_indexesOfAll;
    [otherObjects enumerateObjectsAtIndexes:otherIndexes options:opts usingBlock:^(id  _Nonnull otherObj, NSUInteger otherIdx, BOOL * _Nonnull stop) {
        allContains &= [self ch_containsObjectAtIndexes:indexes options:opts usingBlock:^BOOL(id  _Nonnull obj, NSUInteger idx) {
            BOOL contains = NO;
            if (block) {
                contains = block(obj, idx, otherObj, otherIdx);
            } else {
                contains = [obj isEqual:otherObj];
            }
            return contains;
        }];
        
        if (!allContains) {
            *stop = YES;
        }
    }];
    return allContains;
}

- (BOOL)ch_containsObjectsAtIndexes:(NSIndexSet *)indexes
                            options:(NSEnumerationOptions)opts
                          recursive:(BOOL)recursive
                       otherObjects:(NSArray<id> *)otherObjects
                         usingBlock:(BOOL (^)(id obj, NSIndexPath *indexPath, NSUInteger idx, id otherObj, NSIndexPath *otherIndexPath, NSUInteger otherIdx))block {
    if (!otherObjects.count) return NO;
    if (!self.count) return NO;
    if ([otherObjects isEqualToArray:self]) return YES;
    
    __block BOOL allContains = YES;
    NSIndexSet *otherIndexes = otherObjects.ch_indexesOfAll;
    [otherObjects ch_enumerateObjectsAtIndexes:otherIndexes options:opts recursive:recursive usingBlock:^(id  _Nonnull otherObj, NSIndexPath * _Nonnull otherIndexPath, NSUInteger otherIdx, BOOL * _Nonnull stop) {
        allContains &= [self ch_containsObjectAtIndexes:indexes options:opts recursive:recursive usingBlock:^BOOL(id  _Nonnull obj, NSIndexPath * _Nonnull indexPath, NSUInteger idx) {
            BOOL contains = NO;
            if (block) {
                contains = block(obj, indexPath, idx, otherObj, otherIndexPath, otherIdx);
            } else {
                contains = [obj isEqual:otherObj];
            }
            return contains;
        }];
        
        if (!allContains) {
            *stop = YES;
        }
    }];
    return allContains;
}

#pragma mark - Deduplicate
- (NSArray<id> *)ch_deduplicatedArray {
    NSMutableArray<id> *buffer = [NSMutableArray arrayWithArray:self];
    [buffer ch_deduplicate];
    return buffer.copy;
}

#pragma mark - Filter
- (NSArray<id> *)ch_filteredArray:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block {
    return [self ch_filteredArrayWithOptions:kNilOptions usingBlock:block];
}

- (NSArray<id> *)ch_filteredArrayWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block {
    NSMutableArray<id> *buffer = [NSMutableArray arrayWithArray:self];
    [buffer ch_filterWithOptions:opts usingBlock:block];
    return buffer.copy;
}

#pragma mark - Map
- (NSArray<id> *)ch_mappedArray:(id (^)(id obj, NSUInteger idx, BOOL *stop))block {
    return [self ch_mappedArrayWithOptions:kNilOptions usingBlock:block];
}

- (NSArray<id> *)ch_mappedArrayWithOptions:(NSEnumerationOptions)opts usingBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))block {
    __block NSMutableArray<id> *buffer = [NSMutableArray new];
    [self enumerateObjectsWithOptions:opts usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id anObj = block(obj, idx, stop);
        if (anObj) {
            [buffer addObject:anObj];
        }
    }];
    return buffer.copy;
}

#pragma mark - Sort
- (NSArray<id> *)ch_sortedArrayAtRandomInCount:(NSUInteger)count {
    if (count > self.count) return @[];
    
    NSArray<id> *array = [self ch_sortedArrayAtRandom];
    return [array subarrayWithRange:self.ch_rangeOfAll];
}

- (NSArray<id> *)ch_sortedArrayAtRandom {
    NSMutableArray<id> *array = [NSMutableArray arrayWithArray:self];
    [array ch_shuffle];
    return [array copy];
}

- (NSArray<id> *)ch_sortedArrayByReversed {
    NSMutableArray<id> *array = [NSMutableArray arrayWithArray:self];
    [array ch_reverse];
    return [array copy];
}

- (NSArray<id> *)ch_sortedArrayInAscending {
    NSMutableArray<id> *array = [NSMutableArray arrayWithArray:self];
    [array ch_sortInAscending];
    return [array copy];
}

- (NSArray<id> *)ch_sortedArrayInDescending {
    NSMutableArray<id> *array = [NSMutableArray arrayWithArray:self];
    [array ch_sortInDescending];
    return [array copy];
}

- (NSArray<id> *)ch_sortedArrayInAscendingWithKeys:(NSArray<NSString *> *)keys {
    NSMutableArray<id> *array = [NSMutableArray arrayWithArray:self];
    [array ch_sortInAscendingWithKeys:keys];
    return [array copy];
}

- (NSArray<id> *)ch_sortedArrayInDescendingWithKeys:(NSArray<NSString *> *)keys {
    NSMutableArray<id> *array = [NSMutableArray arrayWithArray:self];
    [array ch_sortInDescendingWithKeys:keys];
    return [array copy];
}

#pragma mark - JSON Array
- (NSString *)ch_JSONStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        if (!error) return JSONString;
    }
    return nil;
}

- (NSString *)ch_JSONPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        if (!error) return JSONString;
    }
    return nil;
}

#pragma mark - Property List
+ (NSArray<id> *)ch_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray<id> *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

+ (NSArray<id> *)ch_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self ch_arrayWithPlistData:data];
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


@implementation NSMutableArray (CHBase)

#pragma mark - Base
+ (instancetype)ch_mutableArrayWithArray:(NSArray<id> *)array {
    if (!array.count) return @[].mutableCopy;
    
    __block NSMutableArray<id> *buffer = array.mutableCopy;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray<id> *item = [self ch_mutableArrayWithArray:obj];
            [buffer ch_replaceObjectAtIndex:idx withObject:item];
        }
    }];
    return buffer;
}

- (void)ch_addObject:(id)anObject {
    if (!anObject) return;
    [self addObject:anObject];
}

- (void)ch_addObjectsFromArray:(NSArray<id> *)objects {
    if (!objects || !objects.count) return;
    [self addObjectsFromArray:objects];
}

- (void)ch_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) return;
    if (index > self.count) return;
    [self insertObject:anObject atIndex:index];
}

- (void)ch_insertObjects:(NSArray<id> *)objects atIndex:(NSUInteger)index {
    if (!objects || !objects.count) return;
    if (index > self.count) return;
    
    NSUInteger i = index;
    for (id obj in objects) {
        [self ch_insertObject:obj atIndex:i++];
    }
}

- (void)ch_insertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes {
    if (!objects || !objects.count) return;
    if (!indexes.count) return;
    
    NSRange insertRange = NSMakeRange(0, self.count + 1);
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:insertRange];
    if (![set containsIndexes:indexes]) return;
    
    [self insertObjects:objects atIndexes:indexes];
}

- (void)ch_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (![self ch_containsIndex:idx1]) return;
    if (![self ch_containsIndex:idx2]) return;
    [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)ch_removeObject:(id)anObject {
    if (!anObject) return;
    [self removeObject:anObject];
}

- (void)ch_removeFirstObject {
    [self ch_removeObjectAtIndex:0];
}

- (void)ch_removeLastObject {
    if (self.count) {
        [self ch_removeObjectAtIndex:self.count - 1];
    }
}

- (void)ch_removeObjectAtIndex:(NSUInteger)index {
    if (![self ch_containsIndex:index]) return;
    [self removeObjectAtIndex:index];
}

- (void)ch_removeObject:(id)anObject inRange:(NSRange)range {
    if (!anObject) return;
    if (!CHNSRangeInRange(self.ch_rangeOfAll, range)) return;
    [self removeObject:anObject inRange:range];
}

- (void)ch_removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    if (!anObject) return;
    if (!CHNSRangeInRange(self.ch_rangeOfAll, range)) return;
    [self removeObjectIdenticalTo:anObject inRange:range];
}

- (void)ch_removeObjectIdenticalTo:(id)anObject {
    if (!anObject) return;
    [self removeObjectIdenticalTo:anObject];
}

- (void)ch_removeObjectsInArray:(NSArray<id> *)otherArray {
    if (!otherArray.count) return;
    [self removeObjectsInArray:otherArray];
}

- (void)ch_removeObjectsInRange:(NSRange)range {
    if (!CHNSRangeInRange(self.ch_rangeOfAll, range)) return;
    [self removeObjectsInRange:range];
}

- (void)ch_removeObjectsAtIndexes:(NSIndexSet *)indexes {
    if (![self ch_containsIndexes:indexes]) return;
    [self removeObjectsAtIndexes:indexes];
}

- (void)ch_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (!anObject) return;
    if (![self ch_containsIndex:index]) return;
    [self replaceObjectAtIndex:index withObject:anObject];
}

- (void)ch_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray range:(NSRange)otherRange {
    if (!CHNSRangeInRange(self.ch_rangeOfAll, range)) return;
    if (!CHNSRangeInRange(otherArray.ch_rangeOfAll, otherRange)) return;
    [self replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)ch_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray {
    if (!CHNSRangeInRange(self.ch_rangeOfAll, range)) return;
    [self replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)ch_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<id> *)objects {
    if (![self ch_containsIndexes:indexes]) return;
    if (!objects.count) return;
    if (indexes.count != objects.count) return;
    [self replaceObjectsAtIndexes:indexes withObjects:objects];
}

- (id)ch_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self ch_removeFirstObject];
    }
    return obj;
}

- (id)ch_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self ch_removeLastObject];
    }
    return obj;
}

- (void)ch_appendObject:(id)anObject {
    [self ch_addObject:anObject];
}

- (void)ch_prependObject:(id)anObject {
    [self ch_insertObject:anObject atIndex:0];
}

- (void)ch_appendObjects:(NSArray<id> *)objects {
    if (!objects || !objects.count) return;
    [self ch_addObjectsFromArray:objects];
}

- (void)ch_prependObjects:(NSArray<id> *)objects {
    if (!objects || !objects.count) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self ch_insertObject:obj atIndex:i++];
    }
}

#pragma mark - Deduplicate
- (void)ch_deduplicate {
    NSOrderedSet *set = [[NSOrderedSet alloc] initWithArray:self];
    if (!set.array.count) return;
    [self removeAllObjects];
    [self ch_addObjectsFromArray:set.array];
}

#pragma mark - Filter
- (void)ch_filter:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block {
    [self ch_filterWithOptions:kNilOptions usingBlock:block];
}

- (void)ch_filterWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block {
    if (!block) return;
    
    __block NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [self enumerateObjectsWithOptions:opts usingBlock:^(id  _Nonnull object, NSUInteger index, BOOL * _Nonnull aStop) {
        if (!block(object, index, aStop)) {
            [indexSet addIndex:index];
        }
    }];
    if (!indexSet.count) return;
    
    [self removeObjectsAtIndexes:indexSet];
}

#pragma mark - Sort
- (void)ch_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0); // 向下取整中间值 9.99 -> 9, -3.14 -> -4
    for (NSUInteger i = 0; i < mid; i++) {
        [self ch_exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))]; // 互相交换两个元素位置 i + (count - (i + 1)) = count - 1
    }
}

- (void)ch_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self ch_exchangeObjectAtIndex:(i - 1)
                     withObjectAtIndex:arc4random_uniform((u_int32_t)i)]; // 机会递减: (A B C) -> B (A C) -> B C (A)
    }
}

- (void)ch_sortInAscending {
    if (self.count <= 1) return;
    
    [self sortUsingSelector:@selector(compare:)];
}

- (void)ch_sortInDescending {
    if (self.count <= 1) return;
    
    [self sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return - [obj1 compare:obj2];
    }];
}

- (void)ch_sortInAscendingWithKeys:(NSArray<NSString *> *)keys {
    if (!keys.count || !keys) return;
    if (self.count <= 1) return;
    
    NSMutableArray<id> *descriptors = @[].mutableCopy;
    for (NSString *key in keys) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
        [descriptors ch_addObject:descriptor];
    }
    [self sortUsingDescriptors:descriptors];
}

- (void)ch_sortInDescendingWithKeys:(NSArray<NSString *> *)keys {
    if (!keys.count || !keys) return;
    if (self.count <= 1) return;
    
    NSMutableArray<id> *descriptors = @[].mutableCopy;
    for (NSString *key in keys) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:NO];
        [descriptors ch_addObject:descriptor];
    }
    [self sortUsingDescriptors:descriptors];
}

#pragma mark - Property List
+ (NSMutableArray<id> *)ch_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray<id> *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (NSMutableArray<id> *)ch_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self ch_arrayWithPlistData:data];
}

@end
