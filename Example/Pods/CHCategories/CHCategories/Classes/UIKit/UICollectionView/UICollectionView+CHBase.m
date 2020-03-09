//
//  UICollectionView+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UICollectionView+CHBase.h"
#import "NSArray+CHBase.h"
#import "NSIndexPath+CHBase.h"

@implementation UICollectionView (CHBase)

#pragma mark - Base
- (NSInteger)ch_firstSection {
    return self.numberOfSections == 0 ? -1 : 0;
}

- (NSInteger)ch_lastSection {
    return self.numberOfSections == 0 ? -1 : self.numberOfSections - 1;
}

- (NSInteger)ch_firstItemInSection:(NSUInteger)section {
    return [self numberOfItemsInSection:section] == 0 ? -1 : 0;
}

- (NSInteger)ch_lastItemInSection:(NSUInteger)section {
    NSInteger items = [self numberOfItemsInSection:section];
    return items == 0 ? -1 : items - 1;
}

- (NSIndexPath *)ch_firstIndexPath {
    NSInteger sections = [self numberOfSections];
    if (!sections) return nil;
    
    for (NSInteger i = 0; i < sections; i++) {
        NSIndexPath *indexPath = [self ch_firstIndexPathInSection:i];
        if (indexPath) return indexPath;
    }
    return nil;
}

- (NSIndexPath *)ch_lastIndexPath {
    NSInteger sections = [self numberOfSections];
    if (!sections) return nil;
    
    for (NSInteger i = sections - 1; i >= 0; i--) {
        NSIndexPath *indexPath = [self ch_lastIndexPathInSection:i];
        if (indexPath) return indexPath;
    }
    return nil;
}

- (NSIndexPath *)ch_firstIndexPathInSection:(NSUInteger)section {
    if (![self ch_containsSection:section]) return nil;
    
    NSInteger item = [self ch_firstItemInSection:section];
    if (item >= 0) return [NSIndexPath indexPathForItem:item inSection:section];
    
    return nil;
}

- (NSIndexPath *)ch_lastIndexPathInSection:(NSUInteger)section {
    if (![self ch_containsSection:section]) return nil;
    
    NSInteger item = [self ch_lastItemInSection:section];
    if (item >= 0) return [NSIndexPath indexPathForItem:item inSection:section];
    
    return nil;
}

- (NSInteger)ch_numberOfItemsInSections {
    NSInteger sections = [self numberOfSections];
    if (!sections) return 0;
    
    NSInteger items = 0;
    for (NSInteger i = 0; i < sections; i++) {
        items += [self numberOfItemsInSection:i];
    }
    return items;
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForItems {
    return [self ch_indexPathsForItemsFromIndexPath:nil toIndexPath:nil];
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForItemsInSection:(NSUInteger)section {
    NSMutableArray *indexPaths = @[].mutableCopy;
    if (![self ch_containsSection:section]) return indexPaths.copy;
    
    NSInteger items = [self numberOfItemsInSection:section];
    if (!items) return indexPaths.copy;
    
    NSIndexPath *fromIndexPath = [self ch_firstIndexPathInSection:section];
    if (!fromIndexPath) return indexPaths.copy;
    
    NSIndexPath *toIndexPath = [self ch_lastIndexPathInSection:section];
    if (!toIndexPath) return indexPaths.copy;
    
    return [self ch_indexPathsForItemsFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForItemsFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *indexPaths = @[].mutableCopy;
    NSIndexPath *aFromIndexPath = fromIndexPath ? fromIndexPath : self.ch_firstIndexPath;
    NSIndexPath *aToIndexPath = toIndexPath ? toIndexPath : self.ch_lastIndexPath;
    if (![self ch_containsIndexPath:aFromIndexPath]) return indexPaths.copy;
    if (![self ch_containsIndexPath:aToIndexPath]) return indexPaths.copy;
    
    NSComparisonResult result = [aFromIndexPath compare:aToIndexPath];
    switch (result) {
        case NSOrderedAscending:
        {
            for (NSInteger i = aFromIndexPath.section; i <= aToIndexPath.section; i++) {
                NSInteger items = [self numberOfItemsInSection:i];
                NSInteger from = 0;
                NSInteger to = items;
                if (i == aFromIndexPath.section) {
                    from = aFromIndexPath.item;
                } else if (i == aToIndexPath.section) {
                    to = aToIndexPath.item + 1;
                }
                for (NSInteger j = from; j < to; j++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                    [indexPaths ch_addObject:indexPath];
                }
            }
        }
            break;
        case NSOrderedSame:
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:aFromIndexPath.item inSection:aFromIndexPath.section];
            [indexPaths ch_addObject:indexPath];
        }
            break;
        case NSOrderedDescending:
            break;
    }
    return indexPaths.copy;
}

- (NSInteger)_ch_numberOfSectionsAfterReload {
    NSInteger sections = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sections = [self.dataSource numberOfSectionsInCollectionView:self];
    }
    return sections;
}

- (NSInteger)_ch_numberOfItemsInSectionAfterReload:(NSInteger)section {
    NSInteger items = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        items = [self.dataSource collectionView:self numberOfItemsInSection:section];
    }
    return items;
}

- (NSArray<NSIndexPath *> *)_ch_indexPathsForItemsAfterReload {
    NSMutableArray *indexPaths = @[].mutableCopy;
    NSInteger sections = [self _ch_numberOfSectionsAfterReload];
    if (!sections) return indexPaths.copy;
    
    for (NSInteger i = 0; i < sections; i++) {
        NSInteger items = [self _ch_numberOfItemsInSectionAfterReload:i];
        if (!items) continue;
        
        for (NSInteger j = 0; j < items; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [indexPaths ch_addObject:indexPath];
        }
    }
    return indexPaths.copy;
}

- (BOOL)ch_containsSection:(NSUInteger)section {
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    return [self ch_containsSections:set];
}

- (BOOL)ch_containsSections:(NSIndexSet *)sections {
    if (!sections.count) return NO;
    
    NSInteger aSections = [self numberOfSections];
    if (!aSections) return NO;
    
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, aSections)];
    return [set containsIndexes:sections];
}

- (BOOL)ch_containsItem:(NSUInteger)item inSection:(NSUInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
    return [self ch_containsIndexPath:indexPath];
}

- (BOOL)ch_containsIndexPath:(NSIndexPath *)indexPath {
    NSArray *buffer = indexPath ? @[indexPath] : nil;
    return [self ch_containsIndexPaths:buffer];
}

- (BOOL)ch_containsIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!indexPaths.count) return NO;
    
    NSInteger sections = [self numberOfSections];
    if (!sections) return NO;
    
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.section >= sections || indexPath.section < 0) return NO;
        
        NSInteger items = [self numberOfItemsInSection:indexPath.section];
        if (indexPath.item >= items || indexPath.item < 0) return NO;
    }
    return YES;
}

- (BOOL)_ch_containsSectionsAfterReload:(NSIndexSet *)sections {
    if (!sections.count) return NO;
    
    NSInteger aSections = [self _ch_numberOfSectionsAfterReload];
    if (!aSections) return NO;
    
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, aSections)];
    return [set containsIndexes:sections];
}

- (BOOL)_ch_containsIndexPathAfterReload:(NSIndexPath *)indexPath {
    NSArray *buffer = indexPath ? @[indexPath] : nil;
    return [self _ch_containsIndexPathsAfterReload:buffer];
}

- (BOOL)_ch_containsIndexPathsAfterReload:(NSArray<NSIndexPath *> *)indexPaths {
    if (!indexPaths.count) return NO;
    
    NSInteger sections = [self _ch_numberOfSectionsAfterReload];
    if (!sections) return NO;
    
    BOOL contains = YES;
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.section >= sections || indexPath.section < 0) {
            contains = NO;
            break;
        }
        
        NSInteger items = [self _ch_numberOfItemsInSectionAfterReload:indexPath.section];
        if (indexPath.item >= items || indexPath.item < 0) {
            contains = NO;
            break;
        }
    }
    return contains;
}

- (void)_ch_logForInvalidSections:(NSIndexSet *)sections {
    NSLog(@"UICollectionView error, invalid sections to scroll/insert/delete/reload: \n%@,", sections);
}

- (void)_ch_logForInvalidIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSLog(@"UICollectionView error, invalid indexPathes to scroll/insert/delete/reload: \n%@,", indexPaths);
}

- (void)ch_setupDataSourceDelegate:(id)dataSourceDelegate {
    self.dataSource = dataSourceDelegate;
    self.delegate = dataSourceDelegate;
}

- (void)ch_removeDataSourceDelegate {
    self.dataSource = nil;
    self.delegate = nil;
}

- (UICollectionViewCell *)_ch_cellForView:(UIView *)view {
    if (!view.superview) return nil;
    if ([view.superview isKindOfClass:[UICollectionViewCell class]]) return (UICollectionViewCell *)view.superview;
    
    return [self _ch_cellForView:view.superview];
}

- (NSIndexPath *)ch_indexPathForViewInItem:(UIView *)view {
    if (!view) return nil;
    if (![view isKindOfClass:[UIView class]]) return nil;
    
    UICollectionViewCell *cell = [self _ch_cellForView:view];
    if (cell) return [self indexPathForCell:cell];
    
    return nil;
}

#pragma mark - Visible
- (BOOL)ch_isVisibleItemForIndexPath:(NSIndexPath *)indexPath {
    if (![self ch_containsIndexPath:indexPath]) return NO;
    
    NSArray *visibleItemIndexPaths = self.indexPathsForVisibleItems;
    for (NSIndexPath *visibleIndexPath in visibleItemIndexPaths) {
        if ([indexPath ch_isEqualToIndexPath:visibleIndexPath]) return YES;
    }
    return NO;
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForVisibleItems {
    NSArray<NSIndexPath *> *visibleItems = [self indexPathsForVisibleItems];
    if (!visibleItems.count) return visibleItems;
    
    return [visibleItems ch_sortedArrayInAscendingWithKeys:@[
                                                             @"section",
                                                             @"item"
                                                             ]];
}

- (NSIndexPath *)ch_indexPathForFirstVisibleItem {
    return [self.ch_indexPathsForVisibleItems ch_objectOrNilAtIndex:0];
}

- (NSIndexPath *)ch_indexPathForLastVisibleItem {
    return [self.ch_indexPathsForVisibleItems lastObject];
}

#pragma mark - Register
- (void)ch_registerNib:(UINib *)nib forHeaderViewWithReuseIdentifier:(NSString *)identifier {
    [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)ch_registerNib:(UINib *)nib forFooterViewWithReuseIdentifier:(NSString *)identifier {
    [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

- (void)ch_registerClass:(Class)viewClass forHeaderViewWithReuseIdentifier:(NSString *)identifier {
    [self registerClass:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)ch_registerClass:(Class)viewClass forFooterViewWithReuseIdentifier:(NSString *)identifier {
    [self registerClass:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

- (__kindof UICollectionReusableView *)ch_dequeueReusableHeaderViewWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)ch_dequeueReusableFooterViewWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark - Scroll
- (void)ch_scrollToSection:(NSUInteger)section atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [self ch_scrollToItem:0 inSection:section atScrollPosition:scrollPosition animated:animated];
}

- (void)ch_scrollToItem:(NSUInteger)item inSection:(NSUInteger)section {
    [self ch_scrollToItem:item inSection:section atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)ch_scrollToItem:(NSUInteger)item inSection:(NSUInteger)section animated:(BOOL)animated {
    [self ch_scrollToItem:item inSection:section atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
}

- (void)ch_scrollToItem:(NSUInteger)item inSection:(NSUInteger)section atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self ch_scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)ch_scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (![self _ch_containsIndexPathAfterReload:indexPath]) {
        [self _ch_logForInvalidIndexPaths:@[indexPath]];
        return;
    }
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

#pragma mark - Insert
/*
 - (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;
 
 - (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;
 */

- (NSIndexSet *)_ch_sectionsByInsertingSections:(NSIndexSet *)sections {
    NSInteger reloadSections = [self _ch_numberOfSectionsAfterReload];
    if (!reloadSections) return nil;
    if (![self _ch_containsSectionsAfterReload:sections]) return nil;
    
    NSInteger currentSections = [self numberOfSections];
    NSInteger offset = currentSections + sections.count;
    if (offset != reloadSections) return nil;
    
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, reloadSections)];
}

- (NSArray<NSIndexPath *> *)_ch_indexPathsForItemsByInsertingItems:(NSArray<NSIndexPath *> *)indexPaths {
    NSArray<NSIndexPath *> *reloadedItems = [self _ch_indexPathsForItemsAfterReload];
    if (!reloadedItems.count) return nil;
    if (![self _ch_containsIndexPathsAfterReload:indexPaths]) return nil;
    
    return reloadedItems;
}

- (BOOL)_ch_shouldInsertSections:(NSIndexSet *)sections {
    NSInteger count = sections.count;
    if (!count) return NO;
    
    NSIndexSet *targetSections = [self _ch_sectionsByInsertingSections:sections];
    if (!targetSections) return NO;
    
    return YES;
}

- (BOOL)_ch_shouldInsertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!indexPaths.count) return NO;
    
    NSArray<NSIndexPath *> *targetIndexPaths = [self _ch_indexPathsForItemsByInsertingItems:indexPaths];
    if (!targetIndexPaths) return NO;
    
    return YES;
}

- (void)ch_insertItem:(NSUInteger)item inSection:(NSUInteger)section {
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self ch_insertItemAtIndexPath:toIndexPath];
}

- (void)ch_insertItemAtIndexPath:(NSIndexPath *)indexPath {
    [self ch_insertItemsAtIndexPaths:@[indexPath]];
}

- (void)ch_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (![self _ch_shouldInsertItemsAtIndexPaths:indexPaths]) {
        [self _ch_logForInvalidIndexPaths:indexPaths];
        return;
    }
    [self insertItemsAtIndexPaths:indexPaths];
}

- (void)ch_insertSection:(NSUInteger)section {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self ch_insertSections:sections];
}

- (void)ch_insertSections:(NSIndexSet *)sections {
    if (![self _ch_shouldInsertSections:sections]) {
        [self _ch_logForInvalidSections:sections];
        return;
    }
    [self insertSections:sections];
}

#pragma mark - Delete
- (NSIndexSet *)_ch_sectionsByDeletingSections:(NSIndexSet *)sections {
    NSInteger currentSections = [self numberOfSections];
    if (!currentSections) return nil;
    if (![self ch_containsSections:sections]) return nil;
    
    NSInteger offset = currentSections - sections.count;
    if (offset < 0) return nil;
    
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, offset)];
}

- (NSArray<NSIndexPath *> *)_ch_indexPathsForItemsByDeletingItems:(NSArray<NSIndexPath *> *)indexPaths {
    NSArray<NSIndexPath *> *currentItems = self.ch_indexPathsForItems;
    if (!currentItems.count) return nil;
    if (![self ch_containsIndexPaths:indexPaths]) return nil;
    
    __block NSMutableArray *buffer = @[].mutableCopy;
    if ([currentItems isEqualToArray:indexPaths]) return buffer.copy;
    
    NSIndexPath *aFromIndexPath = self.ch_firstIndexPath;
    NSIndexPath *aToIndexPath = self.ch_lastIndexPath;
    NSMutableDictionary<NSNumber *, NSNumber *> *offsets = @{}.mutableCopy;
    for (NSIndexPath *indexPath in indexPaths) {
        NSNumber *key = @(indexPath.section);
        NSNumber *itemsValue = [offsets objectForKey:key];
        if (!itemsValue) {
            [offsets setObject:@1 forKey:key];
            continue;
        }
        
        NSInteger items = itemsValue.integerValue + 1;
        [offsets setObject:@(items) forKey:key];
    }
    
    for (NSInteger i = aFromIndexPath.section; i <= aToIndexPath.section; i++) {
        NSInteger items = [self numberOfItemsInSection:i];
        NSInteger itemsOffset = [offsets objectForKey:@(i)].integerValue;
        NSInteger from = 0;
        NSInteger to = items;
        if (i == aFromIndexPath.section) {
            from = aFromIndexPath.item;
        } else if (i == aToIndexPath.section) {
            to = aToIndexPath.item + 1;
        }
        to -= itemsOffset;
        for (NSInteger j = from; j < to; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [buffer ch_addObject:indexPath];
        }
    }
    return buffer.copy;
}

- (BOOL)_ch_shouldDeleteSections:(NSIndexSet *)sections {
    NSInteger count = sections.count;
    if (!count) return NO;
    
    NSIndexSet *targetSections = [self _ch_sectionsByDeletingSections:sections];
    if (!targetSections) return NO;
    
    NSInteger reloadSections = [self _ch_numberOfSectionsAfterReload];
    if (reloadSections != targetSections.count) return NO;
    
    return YES;
}

- (BOOL)_ch_shouldDeleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!indexPaths.count) return NO;
    
    NSArray<NSIndexPath *> *perviousIndexPaths = [self ch_indexPathsForItems];
    if (![perviousIndexPaths ch_containsObjects:indexPaths]) return NO;
    
    NSArray<NSIndexPath *> *targetIndexPaths = [self _ch_indexPathsForItemsByDeletingItems:indexPaths];
    if (!targetIndexPaths) return NO;
    
    NSArray<NSIndexPath *> *reloadIndexPaths = [self _ch_indexPathsForItemsAfterReload];
    if (![reloadIndexPaths isEqualToArray:targetIndexPaths]) return NO;
    
    return YES;
}

- (void)ch_deleteItem:(NSUInteger)item inSection:(NSUInteger)section {
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self ch_deleteItemAtIndexPath:toIndexPath];
}

- (void)ch_deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    [self ch_deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)ch_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths deleteOrder:(CHUICollectionViewDeleteOrder)deleteOrder {
    if (!indexPaths.count) return;
    
    NSMutableArray *deletedIndexPaths = [NSMutableArray arrayWithArray:indexPaths];
    if (indexPaths.count > 1 && deleteOrder != CHUICollectionViewDeleteOrderNone) {
        if (deleteOrder == CHUICollectionViewDeleteOrderAscending) {
            [deletedIndexPaths ch_sortedArrayInAscending];
        }
        else if (deleteOrder == CHUICollectionViewDeleteOrderDecending) {
            [deletedIndexPaths ch_sortedArrayInDescending];
        }
    }
    [self ch_deleteItemsAtIndexPaths:deletedIndexPaths];
}

- (void)ch_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (![self _ch_shouldDeleteItemsAtIndexPaths:indexPaths]) {
        [self _ch_logForInvalidIndexPaths:indexPaths];
        return;
    }
    [self deleteItemsAtIndexPaths:indexPaths];
}

- (void)ch_deleteSection:(NSUInteger)section {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self ch_deleteSections:sections];
}

- (void)ch_deleteSections:(NSIndexSet *)sections {
    if (![self _ch_shouldDeleteSections:sections]) {
        [self _ch_logForInvalidSections:sections];
        return;
    }
    [self deleteSections:sections];
}

#pragma mark - Reload
- (void)ch_reloadItem:(NSUInteger)item inSection:(NSUInteger)section {
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self ch_reloadItemAtIndexPath:toIndexPath];
}

- (void)ch_reloadItemAtIndexPath:(NSIndexPath *)indexPath {
    [self ch_reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)ch_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (![self _ch_containsIndexPathsAfterReload:indexPaths]) {
        [self _ch_logForInvalidIndexPaths:indexPaths];
        return;
    }
    [self reloadItemsAtIndexPaths:indexPaths];
}

- (void)ch_reloadSection:(NSUInteger)section {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self ch_reloadSections:sections];
}

- (void)ch_reloadSections:(NSIndexSet *)sections {
    if (![self _ch_containsSectionsAfterReload:sections]) {
        [self _ch_logForInvalidSections:sections];
        return;
    }
    [self reloadSections:sections];
}

- (void)ch_reloadDataByKeepingSelection {
    NSArray *indexs = [self indexPathsForSelectedItems];
    [self reloadData];
    __weak typeof(self) weakSelf = self;
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [weakSelf selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }];
}

#pragma mark - Select
- (void)ch_clearSelectedItems:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedItems];
    __weak typeof(self) weakSelf = self;
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [weakSelf deselectItemAtIndexPath:indexPath animated:animated];
    }];
}

@end


@implementation NSIndexPath (CHUICollectionView)

- (BOOL)ch_isEqualToItem:(NSIndexPath *)indexPath {
    if (!indexPath) return NO;
    if (![indexPath isKindOfClass:[NSIndexPath class]]) return NO;
    if (self == indexPath) return YES;
    
    return self.item == indexPath.item;
}

- (NSIndexPath *)ch_indexPathByAddingItem:(NSInteger)item {
    return [self ch_indexPathByAddingItem:item section:0];
}

- (NSIndexPath *)ch_indexPathByAddingItem:(NSInteger)item section:(NSInteger)section {
    return [NSIndexPath indexPathForItem:self.item + item inSection:self.section + section];
}


@end
