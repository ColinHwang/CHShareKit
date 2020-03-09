//
//  UITableView+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UITableView+CHBase.h"
#import "CHCoreGraphicHelper.h"
#import "NSArray+CHBase.h"
#import "NSIndexPath+CHBase.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"
#import "UIScrollView+CHBase.h"
#import "UIView+CHBase.h"

static const int CH_UI_TABLE_VIEW_HEADERS_FOR_SECTIONS_KEY;
static const int CH_UI_TABLE_VIEW_FOOTERS_FOR_SECTIONS_KEY;

@interface UITableView ()

@property (nonatomic, strong) NSMapTable<NSNumber *, UIView *> *_ch_headersForSections;
@property (nonatomic, strong) NSMapTable<NSNumber *, UIView *> *_ch_footersForSections;

@end

@implementation UITableView (CHBase)

#pragma mark - Base
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selectors = @[
            [NSValue ch_valueWithSelector:@selector(setDelegate:)],
        ];
        CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix(self, selectors, @"_ch_ui_table_view_");
    });
}

- (CGSize)_ch_adjustedContentSize {
    if (!self.dataSource || !self.delegate) return CGSizeZero;
    
    CGSize contentSize = self.contentSize;
    CGFloat footerViewMaxY = CGRectGetMaxY(self.tableFooterView.frame);
    CGSize adjustedContentSize = CGSizeMake(contentSize.width, footerViewMaxY);
    
    if (!self.ch_lastSection) return adjustedContentSize;
    
    CGRect lastSectionRect = [self rectForSection:self.ch_lastSection];
    adjustedContentSize.height = fmax(adjustedContentSize.height, CGRectGetMaxY(lastSectionRect));
    return adjustedContentSize;
}

- (BOOL)ch_canScroll {
    return [self ch_canScroll:CHUIScrollViewScrollDirectionVertical];
}

- (BOOL)ch_canScroll:(CHUIScrollViewScrollDirection)direction {
    if (CGRectGetHeight(self.bounds) <= 0) return NO;
    
    if ([self.tableHeaderView isKindOfClass:[UISearchBar class]]) {
        BOOL canScroll = self._ch_adjustedContentSize.height + CHUIEdgeInsetsGetValuesInVertical(self.ch_contentInset) > CGRectGetHeight(self.bounds);
        return canScroll;
    }
    return [super ch_canScroll:CHUIScrollViewScrollDirectionVertical];
}

- (NSMapTable<NSNumber *,UIView *> *)_ch_headersForSections {
    NSMapTable *buffer = [self ch_getAssociatedValueForKey:&CH_UI_TABLE_VIEW_HEADERS_FOR_SECTIONS_KEY];
    if (!buffer) {
        buffer = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
        [self ch_setAssociatedValue:buffer withKey:&CH_UI_TABLE_VIEW_HEADERS_FOR_SECTIONS_KEY];
    }
    return buffer;
}

- (NSMapTable<NSNumber *,UIView *> *)_ch_footersForSections {
    NSMapTable *buffer = [self ch_getAssociatedValueForKey:&CH_UI_TABLE_VIEW_FOOTERS_FOR_SECTIONS_KEY];
    if (!buffer) {
        buffer = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
        [self ch_setAssociatedValue:buffer withKey:&CH_UI_TABLE_VIEW_FOOTERS_FOR_SECTIONS_KEY];
    }
    return buffer;
}

- (NSInteger)ch_firstSection {
    return self.numberOfSections == 0 ? -1 : 0;
}

- (NSInteger)ch_lastSection {
    return self.numberOfSections == 0 ? -1 : self.numberOfSections - 1;
}

- (NSInteger)ch_firstRowInSection:(NSUInteger)section {
    return [self numberOfRowsInSection:section] == 0 ? -1 : 0;
}

- (NSInteger)ch_lastRowInSection:(NSUInteger)section {
    NSInteger rows = [self numberOfRowsInSection:section];
    return rows == 0 ? -1 : rows - 1;
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

    NSInteger row = [self ch_firstRowInSection:section];
    if (row >= 0) return [NSIndexPath indexPathForRow:row inSection:section];
    
    return nil;
}

- (NSIndexPath *)ch_lastIndexPathInSection:(NSUInteger)section {
    if (![self ch_containsSection:section]) return nil;
    
    NSInteger row = [self ch_lastRowInSection:section];
    if (row >= 0) return [NSIndexPath indexPathForRow:row inSection:section];
    
    return nil;
}

- (NSInteger)ch_numberOfRowsInSections {
    NSInteger sections = [self numberOfSections];
    if (!sections) return 0;
    
    NSInteger rows = 0;
    for (NSInteger i = 0; i < sections; i++) {
        rows += [self numberOfRowsInSection:i];
    }
    return rows;
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForRows {
    return [self ch_indexPathsForRowsFromIndexPath:nil toIndexPath:nil];
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForRowsInSection:(NSUInteger)section {
    NSMutableArray *indexPaths = @[].mutableCopy;
    if (![self ch_containsSection:section]) return indexPaths.copy;
    
    NSInteger rows = [self numberOfRowsInSection:section];
    if (!rows) return indexPaths.copy;
    
    NSIndexPath *fromIndexPath = [self ch_firstIndexPathInSection:section];
    if (!fromIndexPath) return indexPaths.copy;
    
    NSIndexPath *toIndexPath = [self ch_lastIndexPathInSection:section];
    if (!toIndexPath) return indexPaths.copy;
    
    return [self ch_indexPathsForRowsFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForRowsFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
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
                NSInteger rows = [self numberOfRowsInSection:i];
                NSInteger from = 0;
                NSInteger to = rows;
                if (i == aFromIndexPath.section) {
                    from = aFromIndexPath.row;
                } else if (i == aToIndexPath.section) {
                    to = aToIndexPath.row + 1;
                }
                for (NSInteger j = from; j < to; j++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    [indexPaths ch_addObject:indexPath];
                }
            }
        }
            break;
        case NSOrderedSame:
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:aFromIndexPath.row inSection:aFromIndexPath.section];
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
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [self.dataSource numberOfSectionsInTableView:self];
    }
    return sections;
}

- (NSInteger)_ch_numberOfRowsInSectionAfterReload:(NSInteger)section {
    NSInteger rows = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        rows = [self.dataSource tableView:self numberOfRowsInSection:section];
    }
    return rows;
}

- (NSArray<NSIndexPath *> *)_ch_indexPathsForRowsAfterReload {
    NSMutableArray *indexPaths = @[].mutableCopy;
    NSInteger sections = [self _ch_numberOfSectionsAfterReload];
    if (!sections) return indexPaths.copy;
    
    for (NSInteger i = 0; i < sections; i++) {
        NSInteger rows = [self _ch_numberOfRowsInSectionAfterReload:i];
        if (!rows) continue;
        
        for (NSInteger j = 0; j < rows; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
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

- (BOOL)ch_containsRow:(NSUInteger)row inSection:(NSUInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
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
        
        NSInteger rows = [self numberOfRowsInSection:indexPath.section];
        if (indexPath.row >= rows || indexPath.row < 0) return NO;
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
        
        NSInteger rows = [self _ch_numberOfRowsInSectionAfterReload:indexPath.section];
        if (indexPath.row >= rows || indexPath.row < 0) {
            contains = NO;
            break;
        }
    }
    return contains;
}

- (void)_ch_logForInvalidSections:(NSIndexSet *)sections {
    NSLog(@"UITableView error, invalid sections to scroll/insert/delete/reload: \n%@,", sections);
}

- (void)_ch_logForInvalidIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSLog(@"UITableView error, invalid indexPathes to scroll/insert/delete/reload: \n%@,", indexPaths);
}

- (void)ch_setupDataSourceDelegate:(id)dataSourceDelegate {
    self.dataSource = dataSourceDelegate;
    self.delegate = dataSourceDelegate;
}

- (void)ch_removeDataSourceDelegate {
    self.dataSource = nil;
    self.delegate = nil;
}

- (void)ch_updateWithBlock:(void(^)(UITableView *tableView))block {
    __weak typeof(self) weakSelf = self;
    [self beginUpdates];
    block(weakSelf);
    [self endUpdates];
}

- (CGRect)ch_rectForRowsInSection:(NSInteger)section {
    CGRect rectForSection = [self rectForSection:section];
    if (CGRectGetHeight(rectForSection) <= 0) return rectForSection;
    
    CGFloat y, height;
    CGRect rectForHeader = [self rectForHeaderInSection:section];
    CGRect rectForFooter = [self rectForFooterInSection:section];
    y = CGRectGetMaxY(rectForHeader);
    height = CGRectGetHeight(rectForSection) - CGRectGetHeight(rectForHeader) - CGRectGetHeight(rectForFooter);
    return CGRectMake(rectForSection.origin.x, y, rectForSection.size.width, height);
}

- (CGRect)_ch_rectForHeaderInSection:(NSUInteger)section {
    CGRect rect = [self rectForHeaderInSection:section];
    if (CGRectGetHeight(rect) <= 0) return CGRectNull;
    
    if (self.style == UITableViewStylePlain) {
        rect = [self rectForSection:section];
    }
    return rect;
}

- (CGRect)_ch_rectForFooterInSection:(NSUInteger)section {
    CGRect rect = [self rectForFooterInSection:section];
    if (CGRectGetHeight(rect) <= 0) return CGRectNull;
    
    if (self.style == UITableViewStylePlain) {
        rect = [self rectForSection:section];
    }
    return rect;
}

- (NSInteger)ch_sectionForHeaderAtPoint:(CGPoint)point {
    NSInteger count = [self numberOfSections];
    if (!count) return -1;
    
    for (NSInteger i = 0; i < count; i++) {
        CGRect rectForHeader = [self _ch_rectForHeaderInSection:i];
        if (CGRectGetMinY(rectForHeader) > point.y) return -1;
        if(CGRectContainsPoint(rectForHeader, point)) return i;
    }
    return -1;
}

- (NSInteger)ch_sectionForFooterAtPoint:(CGPoint)point {
    NSInteger count = [self numberOfSections];
    if (!count) return -1;
    
    for (NSInteger i = 0; i < count; i++) {
        CGRect rectForFooter = [self _ch_rectForFooterInSection:i];
        if (CGRectGetMinY(rectForFooter) > point.y) return -1;
        if(CGRectContainsPoint(rectForFooter, point)) return i;
    }
    return -1;
}

- (NSInteger)ch_sectionForHeaderView:(UIView *)headerView {
    if (!headerView) return -1;
    if (![headerView isKindOfClass:[UIView class]]) return -1;
    
    NSInteger count = [self numberOfSections];
    if (!count) return -1;
    
    for (NSInteger i = 0; i < count; i++) {
        UIView *buffer = [self ch_headerViewForSection:i];
        if ([buffer isEqual:headerView]) return i;
    }
    return -1;
}

- (NSInteger)ch_sectionForFooterView:(UIView *)footerView {
    if (!footerView) return -1;
    if (![footerView isKindOfClass:[UIView class]]) return -1;
    
    NSInteger count = [self numberOfSections];
    if (!count) return -1;
    
    for (NSInteger i = 0; i < count; i++) {
        UIView *buffer = [self ch_footerViewForSection:i];
        if ([buffer isEqual:footerView]) return i;
    }
    return -1;
}

- (NSArray<NSNumber *> *)ch_sectionsForHeadersInRect:(CGRect)rect {
    NSMutableArray *sections = @[].mutableCopy;
    NSInteger count = [self numberOfSections];
    if (!count) return sections.copy;
    if (CGRectEqualToRect(rect, CGRectZero)) return sections.copy;
    
    for (NSInteger i = 0; i < count; i++) {
        CGRect rectForHeader = [self _ch_rectForHeaderInSection:i];
        if (CGRectGetMinY(rectForHeader) > CGRectGetMaxY(rect)) return sections.copy;
        
        if(CGRectIntersectsRect(rect, rectForHeader)) {
            [sections ch_addObject:@(i)];
        }
    }
    return sections.copy;
}

- (NSArray<NSNumber *> *)ch_sectionsForFootersInRect:(CGRect)rect {
    NSMutableArray *sections = @[].mutableCopy;
    NSInteger count = [self numberOfSections];
    if (!count) return sections.copy;
    if (CGRectEqualToRect(rect, CGRectZero)) return sections.copy;
    
    for (NSInteger i = 0; i < count; i++) {
        CGRect rectForFooter = [self _ch_rectForFooterInSection:i];
        if (CGRectGetMinY(rectForFooter) > CGRectGetMaxY(rect)) return sections.copy;
        
        if(CGRectIntersectsRect(rect, rectForFooter)) {
            [sections ch_addObject:@(i)];
        }
    }
    return sections.copy;
}

- (UITableViewCell *)_ch_cellForView:(UIView *)view {
    if (!view.superview) return nil;
    if ([view.superview isKindOfClass:[UITableViewCell class]]) return (UITableViewCell *)view.superview;
    
    return [self _ch_cellForView:view.superview];
}

- (NSIndexPath *)ch_indexPathForViewInRow:(UIView *)view {
    if (!view) return nil;
    if (![view isKindOfClass:[UIView class]]) return nil;
    
    UITableViewCell *cell = [self _ch_cellForView:view];
    if (cell) return [self indexPathForCell:cell];
    
    return nil;
}

- (NSInteger)ch_sectionForViewInHeader:(UIView *)view {
    if (!view) return -1;
    if (![view isKindOfClass:[UIView class]]) return -1;
    if (!view.superview) return -1;
    
    NSInteger count = [self numberOfSections];
    if (!count) return -1;
    
    CGRect rect = [self ch_convertRect:view.frame fromViewOrWindow:view.superview];
    for (NSInteger i = 0; i < count; i++) {
        CGRect rectForHeader = [self _ch_rectForHeaderInSection:i];
        if (CGRectGetMinY(rectForHeader) > CGRectGetMaxY(rect)) return -1;
        
        if(CGRectContainsPoint(rectForHeader, rect.origin)) {
            UIView *headerView = [self ch_headerViewForSection:i];
            if (!headerView) return -1;
            if ([headerView ch_containsSubview:view]) return i;
            
            return -1;
        }
    }
    return -1;
}

- (NSInteger)ch_sectionForViewInFooter:(UIView *)view {
    if (!view) return -1;
    if (![view isKindOfClass:[UIView class]]) return -1;
    if (!view.superview) return -1;
    
    NSInteger count = [self numberOfSections];
    if (!count) return -1;
    
    CGRect rect = [self ch_convertRect:view.frame fromViewOrWindow:view.superview];
    for (NSInteger i = 0; i < count; i++) {
        CGRect rectForFooter = [self _ch_rectForFooterInSection:i];
        if (CGRectGetMinY(rectForFooter) > CGRectGetMaxY(rect)) return -1;
        
        if(CGRectContainsPoint(rectForFooter, rect.origin)) {
            UIView *footerView = [self ch_footerViewForSection:i];
            if (!footerView) return -1;
            if ([footerView ch_containsSubview:view]) return i;
            
            return -1;
        }
    }
    return -1;
}

- (UIView *)ch_headerViewForSection:(NSUInteger)section {
    if (![self ch_containsSection:section]) return nil;
    
    UIView *headerView = [self headerViewForSection:section];
    if (headerView) return headerView;
    
    headerView = [self._ch_headersForSections objectForKey:@(section)];
    if (headerView) return headerView;
    
    return nil;
}

- (UIView *)ch_footerViewForSection:(NSUInteger)section {
    if (![self ch_containsSection:section]) return nil;
    
    UIView *footerView = [self footerViewForSection:section];
    if (footerView) return footerView;
    
    footerView = [self._ch_footersForSections objectForKey:@(section)];
    if (footerView) return footerView;
    
    return nil;
}

#pragma mark - Estimated Height
//- (void)setCh_estimatedRowHeightEnabled:(BOOL)ch_estimatedRowHeightEnabled {
//    CGFloat dimension = ch_estimatedRowHeightEnabled ? UITableViewAutomaticDimension : 0;
//    if (ch_estimatedRowHeightEnabled) {
//        self.rowHeight = UITableViewAutomaticDimension;
//        
////        self.estimatedRowHeight = ;
//    } else {
//        self.estimatedRowHeight = 0;
//    }
//}
//
//- (BOOL)ch_estimatedRowHeightEnabled {
//    return self.estimatedRowHeight != 0;
//}
//
//- (void)setCh_estimatedSectionHeaderHeightEnabled:(BOOL)ch_estimatedSectionHeaderHeightEnabled {
//    CGFloat dimension = ch_estimatedSectionHeaderHeightEnabled ? UITableViewAutomaticDimension : 0;
//    self.estimatedSectionHeaderHeight = dimension;
//}
//
//- (BOOL)ch_estimatedSectionHeaderHeightEnabled {
//    return self.estimatedSectionHeaderHeight != 0;
//}
//
//- (void)setCh_estimatedSectionFooterHeightEnabled:(BOOL)ch_estimatedSectionFooterHeightEnabled {
//    CGFloat dimension = ch_estimatedSectionFooterHeightEnabled ? UITableViewAutomaticDimension : 0;
//    self.estimatedSectionFooterHeight = dimension;
//}
//
//- (BOOL)isCh_estimatedSectionFooterHeightEnabled {
//    return self.estimatedSectionFooterHeight != 0;
//}

#pragma mark - Stick
- (BOOL)ch_isStickyHeaderForSection:(NSUInteger)section {
    if (self.style != UITableViewStylePlain) return NO;
    if (![self ch_containsSection:section]) return NO;
    
    CGRect rectForHeader = [self rectForHeaderInSection:section];
    if (CGRectGetHeight(rectForHeader) <= 0) return NO;
    
    CGRect rectForSection = [self rectForSection:section];
    CGRect rectForFooter = [self rectForHeaderInSection:section];
    CGFloat offsetHeight = CGRectGetHeight(rectForSection) - CGRectGetHeight(rectForHeader) - CGRectGetHeight(rectForFooter);
    CGRect rectForOffset = CGRectMake(rectForSection.origin.x, rectForSection.origin.y, rectForSection.size.width, offsetHeight);
    CGPoint point = self._ch_visibleContentRect.origin;
    return CHCGRectContainsPoint(rectForOffset, point);
}

- (BOOL)ch_isStickyFooterForSection:(NSUInteger)section {
    if (self.style != UITableViewStylePlain) return NO;
    if (![self ch_containsSection:section]) return NO;
    
    CGRect rectForFooter = [self rectForFooterInSection:section];
    if (CGRectGetHeight(rectForFooter) <= 0) return NO;
    
    CGRect rectForSection = [self rectForSection:section];
    CGRect rectForHeader = [self rectForHeaderInSection:section];
    CGFloat offsetHeight = CGRectGetHeight(rectForSection) - CGRectGetHeight(rectForHeader) - CGRectGetHeight(rectForFooter);
    CGRect rectForOffset = CGRectMake(rectForSection.origin.x, rectForSection.origin.y + CGRectGetHeight(rectForHeader) + CGRectGetHeight(rectForFooter), rectForSection.size.width, offsetHeight);
    
    CGPoint point = CGPointMake(self._ch_visibleContentRect.origin.x, CGRectGetMaxY(self._ch_visibleContentRect));
    return CHCGRectContainsPoint(rectForOffset, point);
}

- (NSInteger)ch_sectionForStickyHeader {
    if (self.style != UITableViewStylePlain) return -1;
    
    NSInteger section = self.ch_sectionForFirstVisibleHeader;
    if (section < 0) return -1;
    if ([self ch_isStickyHeaderForSection:section]) return section;
    
    return -1;
}

- (NSInteger)ch_sectionForStickyFooter {
    if (self.style != UITableViewStylePlain) return -1;
    
    NSInteger section = self.ch_sectionForLastVisibleFooter;
    if (section < 0) return -1;
    if ([self ch_isStickyFooterForSection:section]) return section;
    
    return -1;
}

#pragma mark - Visible
- (CGRect)_ch_visibleContentRect {
    CGFloat x, y, width, height;
    x = self.contentOffset.x + self.ch_contentInset.left - self.ch_contentInset.right;
    y = self.contentOffset.y + self.ch_contentInset.top - self.ch_contentInset.bottom;
    width = self.bounds.size.width - self.ch_contentInset.left + self.ch_contentInset.right;
    height = self.bounds.size.height - self.ch_contentInset.top + self.ch_contentInset.bottom;
    return CGRectMake(x, y, width, height);
}

- (BOOL)ch_isVisibleRowForIndexPath:(NSIndexPath *)indexPath {
    if (![self ch_containsIndexPath:indexPath]) return NO;
    
    NSArray *visibleRowIndexPaths = self.indexPathsForVisibleRows;
    for (NSIndexPath *visibleIndexPath in visibleRowIndexPaths) {
        if ([indexPath ch_isEqualToIndexPath:visibleIndexPath]) return YES;
    }
    return NO;
}

- (BOOL)ch_isVisibleHeaderInSection:(NSUInteger)section {
    if (![self ch_containsSection:section]) return NO;
    
    CGRect rectForHeader = [self _ch_rectForHeaderInSection:section];
    if (CGRectGetHeight(rectForHeader) <= 0) return NO;
    
    return CGRectIntersectsRect(self._ch_visibleContentRect, rectForHeader);
}

- (BOOL)ch_isVisibleFooterInSection:(NSUInteger)section {
    if (![self ch_containsSection:section]) return NO;
    
    CGRect rectForFooter = [self _ch_rectForFooterInSection:section];
    if (CGRectGetHeight(rectForFooter) <= 0) return NO;
    
    return CGRectIntersectsRect(self._ch_visibleContentRect, rectForFooter);
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForVisibleRows {
    NSArray<NSIndexPath *> *visibleRows = [self indexPathsForVisibleRows];
    if (!visibleRows.count) return @[];
    
    return [visibleRows ch_sortedArrayInAscendingWithKeys:@[
                                                             @"section",
                                                             @"row"
                                                             ]];
}

- (NSArray<NSNumber *> *)ch_sectionsForVisibleHeaders {
    return [self ch_sectionsForHeadersInRect:[self _ch_visibleContentRect]];
}

- (NSArray<NSNumber *> *)ch_sectionsForVisibleFooters {
    return [self ch_sectionsForFootersInRect:[self _ch_visibleContentRect]];
}

- (NSIndexPath *)ch_indexPathForFirstVisibleRow {
    return [self.ch_indexPathsForVisibleRows ch_objectOrNilAtIndex:0];
}

- (NSIndexPath *)ch_indexPathForLastVisibleRow {
    return [self.ch_indexPathsForVisibleRows lastObject];
}

- (NSInteger)ch_sectionForFirstVisibleHeader {
    NSNumber *buffer = [self.ch_sectionsForVisibleHeaders ch_objectOrNilAtIndex:0];
    return buffer ? buffer.integerValue : -1;
}

- (NSInteger)ch_sectionForLastVisibleHeader {
    NSNumber *buffer = [self.ch_sectionsForVisibleHeaders lastObject];
    return buffer ? buffer.integerValue : -1;
}

- (NSInteger)ch_sectionForFirstVisibleFooter {
    NSNumber *buffer = [self.ch_sectionsForVisibleFooters ch_objectOrNilAtIndex:0];
    return buffer ? buffer.integerValue : -1;
}

- (NSInteger)ch_sectionForLastVisibleFooter {
    NSNumber *buffer = [self.ch_sectionsForVisibleFooters lastObject];
    return buffer ? buffer.integerValue : -1;
}

#pragma mark - Scroll
- (void)ch_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section {
    [self ch_scrollToRow:row inSection:section atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)ch_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section animated:(BOOL)animated {
    [self ch_scrollToRow:row inSection:section atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)ch_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self ch_scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)ch_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (![self _ch_containsIndexPathAfterReload:indexPath]) {
        [self _ch_logForInvalidIndexPaths:@[indexPath]];
        return;
    }
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

#pragma mark - Insert
- (NSIndexSet *)_ch_sectionsByInsertingSections:(NSIndexSet *)sections {
    NSInteger reloadSections = [self _ch_numberOfSectionsAfterReload];
    if (!reloadSections) return nil;
    if (![self _ch_containsSectionsAfterReload:sections]) return nil;

    NSInteger currentSections = [self numberOfSections];
    NSInteger offset = currentSections + sections.count;
    if (offset != reloadSections) return nil;
    
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, reloadSections)];
}

- (NSArray<NSIndexPath *> *)_ch_indexPathsForRowsByInsertingRows:(NSArray<NSIndexPath *> *)indexPaths {
    NSArray<NSIndexPath *> *reloadedRows = [self _ch_indexPathsForRowsAfterReload];
    if (!reloadedRows.count) return nil;
    if (![self _ch_containsIndexPathsAfterReload:indexPaths]) return nil;
    
    return reloadedRows;
}

- (BOOL)_ch_shouldInsertSections:(NSIndexSet *)sections {
    NSInteger count = sections.count;
    if (!count) return NO;
    
    NSIndexSet *targetSections = [self _ch_sectionsByInsertingSections:sections];
    if (!targetSections) return NO;
    
    return YES;
}

- (BOOL)_ch_shouldInsertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!indexPaths.count) return NO;
    
    NSArray<NSIndexPath *> *targetIndexPaths = [self _ch_indexPathsForRowsByInsertingRows:indexPaths];
    if (!targetIndexPaths) return NO;
    
    return YES;
}

- (void)ch_insertRow:(NSUInteger)row inSection:(NSUInteger)section {
    [self ch_insertRow:row inSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toInsert = [NSIndexPath indexPathForRow:row inSection:section];
    [self ch_insertRowAtIndexPath:toInsert withRowAnimation:animation];
}

- (void)ch_insertRowAtIndexPath:(NSIndexPath *)indexPath {
    [self ch_insertRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self ch_insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)ch_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self _ch_shouldInsertRowsAtIndexPaths:indexPaths]) {
        [self _ch_logForInvalidIndexPaths:indexPaths];
        return;
    }
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)ch_insertSection:(NSUInteger)section {
    [self ch_insertSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self ch_insertSections:sections withRowAnimation:animation];
}

- (void)ch_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self _ch_shouldInsertSections:sections]) {
        [self _ch_logForInvalidSections:sections];
        return;
    }
    [self insertSections:sections withRowAnimation:animation];
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

- (NSArray<NSIndexPath *> *)_ch_indexPathsForRowsByDeletingRows:(NSArray<NSIndexPath *> *)indexPaths {
    NSArray<NSIndexPath *> *currentRows = self.ch_indexPathsForRows;
    if (!currentRows.count) return nil;
    if (![self ch_containsIndexPaths:indexPaths]) return nil;
    
    __block NSMutableArray *buffer = @[].mutableCopy;
    if ([currentRows isEqualToArray:indexPaths]) return buffer.copy;
    
    NSIndexPath *aFromIndexPath = self.ch_firstIndexPath;
    NSIndexPath *aToIndexPath = self.ch_lastIndexPath;
    NSMutableDictionary<NSNumber *, NSNumber *> *offsets = @{}.mutableCopy;
    for (NSIndexPath *indexPath in indexPaths) {
        NSNumber *key = @(indexPath.section);
        NSNumber *rowsValue = [offsets objectForKey:key];
        if (!rowsValue) {
            [offsets setObject:@1 forKey:key];
            continue;
        }
        
        NSInteger rows = rowsValue.integerValue + 1;
        [offsets setObject:@(rows) forKey:key];
    }
    
    for (NSInteger i = aFromIndexPath.section; i <= aToIndexPath.section; i++) {
        NSInteger rows = [self numberOfRowsInSection:i];
        NSInteger rowsOffset = [offsets objectForKey:@(i)].integerValue;
        NSInteger from = 0;
        NSInteger to = rows;
        if (i == aFromIndexPath.section) {
            from = aFromIndexPath.row;
        } else if (i == aToIndexPath.section) {
            to = aToIndexPath.row + 1;
        }
        to -= rowsOffset;
        for (NSInteger j = from; j < to; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
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

- (BOOL)_ch_shouldDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!indexPaths.count) return NO;
    
    NSArray<NSIndexPath *> *perviousIndexPaths = [self ch_indexPathsForRows];
    if (![perviousIndexPaths ch_containsObjects:indexPaths]) return NO;
    
    NSArray<NSIndexPath *> *targetIndexPaths = [self _ch_indexPathsForRowsByDeletingRows:indexPaths];
    if (!targetIndexPaths) return NO;
    
    NSArray<NSIndexPath *> *reloadIndexPaths = [self _ch_indexPathsForRowsAfterReload];
    if (![reloadIndexPaths isEqualToArray:targetIndexPaths]) return NO;
    
    return YES;
}

- (void)ch_deleteRow:(NSUInteger)row inSection:(NSUInteger)section {
    [self ch_deleteRow:row inSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toDelete = [NSIndexPath indexPathForRow:row inSection:section];
    [self ch_deleteRowAtIndexPath:toDelete withRowAnimation:animation];
}

- (void)ch_deleteRowAtIndexPath:(NSIndexPath *)indexPath {
    [self ch_deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self ch_deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)ch_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths deleteOrder:(CHUITableViewDeleteOrder)deleteOrder withRowAnimation:(UITableViewRowAnimation)animation {
    if (!indexPaths.count) return;
    
    NSMutableArray *deletedIndexPaths = [NSMutableArray arrayWithArray:indexPaths];
    if (indexPaths.count > 1 && deleteOrder != CHUITableViewDeleteOrderNone) {
        if (deleteOrder == CHUITableViewDeleteOrderAscending) {
            [deletedIndexPaths ch_sortedArrayInAscending];
        } else if (deleteOrder == CHUITableViewDeleteOrderDecending) {
            [deletedIndexPaths ch_sortedArrayInDescending];
        }
    }
    [self ch_deleteRowsAtIndexPaths:deletedIndexPaths.copy withRowAnimation:animation];
}

- (void)ch_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self _ch_shouldDeleteRowsAtIndexPaths:indexPaths]) {
        [self _ch_logForInvalidIndexPaths:indexPaths];
        return;
    }
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)ch_deleteSection:(NSUInteger)section {
    [self ch_deleteSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self ch_deleteSections:sections withRowAnimation:animation];
}

- (void)ch_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self _ch_shouldDeleteSections:sections]) {
        [self _ch_logForInvalidSections:sections];
        return;
    }
    [self deleteSections:sections withRowAnimation:animation];
}

#pragma mark - Reload
- (void)ch_reloadRow:(NSUInteger)row inSection:(NSUInteger)section {
    [self ch_reloadRow:row inSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toReload = [NSIndexPath indexPathForRow:row inSection:section];
    [self ch_reloadRowAtIndexPath:toReload withRowAnimation:animation];
}

- (void)ch_reloadRowAtIndexPath:(NSIndexPath *)indexPath {
    [self ch_reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self ch_reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)ch_reloadVisibleRows {
    [self ch_reloadRowsAtIndexPaths:self.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_reloadVisibleRowsWithRowAnimation:(UITableViewRowAnimation)animation {
    [self ch_reloadRowsAtIndexPaths:self.indexPathsForVisibleRows withRowAnimation:animation];
}

- (void)ch_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self _ch_containsIndexPathsAfterReload:indexPaths]) {
        [self _ch_logForInvalidIndexPaths:indexPaths];
        return;
    }
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)ch_reloadSection:(NSUInteger)section {
    [self ch_reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ch_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self ch_reloadSections:sections withRowAnimation:animation];
}

- (void)ch_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self _ch_containsSectionsAfterReload:sections]) {
        [self _ch_logForInvalidSections:sections];
        return;
    }
    [self reloadSections:sections withRowAnimation:animation];
}

#pragma mark - Select
- (void)ch_clearSelectedRows:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:indexPath animated:animated];
    }];
}

#pragma mark - Position
- (CHUITableViewCellPosition)ch_positionForRowInRows:(NSIndexPath *)indexPath {
    if (![self ch_containsIndexPath:indexPath]) return CHUITableViewCellPositionNone;
    
    NSInteger sections = [self numberOfSections];
    if (!sections) return CHUITableViewCellPositionNone;
    if (sections == 1) return  CHUITableViewCellPositionSingle;
    if ([indexPath ch_isEqualToIndexPath:self.ch_firstIndexPath]) return CHUITableViewCellPositionTop;
    if ([indexPath ch_isEqualToIndexPath:self.ch_lastIndexPath]) return CHUITableViewCellPositionBottom;
    
    return CHUITableViewCellPositionMiddle;
}

- (CHUITableViewCellPosition)ch_positionForRowInSection:(NSIndexPath *)indexPath {
    if (![self ch_containsIndexPath:indexPath]) return CHUITableViewCellPositionNone;
    if (![self numberOfSections]) return CHUITableViewCellPositionNone;
    
    NSInteger rows = [self numberOfRowsInSection:indexPath.section];
    if (!rows) return CHUITableViewCellPositionNone;
    if (rows == 1) return CHUITableViewCellPositionSingle;
    if (indexPath.row == 0) return CHUITableViewCellPositionTop;
    if (indexPath.row == rows - 1) return CHUITableViewCellPositionBottom;
    
    return CHUITableViewCellPositionMiddle;
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForPositionInRows:(CHUITableViewCellPosition)postion {
    NSMutableArray *indexPaths = @[].mutableCopy;
    
    NSInteger sections = [self numberOfSections];
    if (!sections) return indexPaths.copy;
    
    NSInteger rows = [self ch_numberOfRowsInSections];
    if (!rows) return indexPaths.copy;
    
    switch (postion) {
        case CHUITableViewCellPositionNone:
            break;
        case CHUITableViewCellPositionSingle:
        {
            if (rows == 1) {
                [indexPaths ch_addObject:self.ch_firstIndexPath];
            }
        }
            break;
        case CHUITableViewCellPositionTop:
        {
            [indexPaths ch_addObject:self.ch_firstIndexPath];
        }
            break;
        case CHUITableViewCellPositionMiddle:
        {
            NSIndexPath *firstIndexPath = self.ch_firstIndexPath;
            NSIndexPath *lastIndexPath = self.ch_lastIndexPath;
            if (firstIndexPath && lastIndexPath) {
                NSArray<NSIndexPath *> *buffer = [self ch_indexPathsForRowsFromIndexPath:firstIndexPath toIndexPath:lastIndexPath];
                [indexPaths ch_addObjectsFromArray:buffer];
                [indexPaths ch_removeObject:lastIndexPath];
                [indexPaths ch_removeObject:firstIndexPath];
            }
        }
            break;
        case CHUITableViewCellPositionBottom:
        {
            [indexPaths ch_addObject:self.ch_lastIndexPath];
        }
            break;
    }
    if (indexPaths.count <= 1) return indexPaths.copy;
    
    return [indexPaths ch_deduplicatedArray];
}

- (NSArray<NSIndexPath *> *)ch_indexPathsForPosition:(CHUITableViewCellPosition)postion inSection:(NSUInteger)section {
    NSMutableArray *indexPaths = @[].mutableCopy;
    if (![self ch_containsSection:section]) return indexPaths.copy;
    
    NSInteger rows = [self numberOfRowsInSection:section];
    if (!rows) return  indexPaths.copy;
    
    switch (postion) {
        case CHUITableViewCellPositionNone:
            break;
        case CHUITableViewCellPositionSingle:
        {
            if (rows == 1) {
                [indexPaths ch_addObject:[NSIndexPath indexPathForRow:0 inSection:section]];
            }
        }
            break;
        case CHUITableViewCellPositionTop:
        {
            [indexPaths ch_addObject:[NSIndexPath indexPathForRow:0 inSection:section]];
        }
            break;
        case CHUITableViewCellPositionMiddle:
        {
            for (NSInteger i = 1; i < rows - 1; i++) {
                [indexPaths ch_addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
        }
            break;
        case CHUITableViewCellPositionBottom:
        {
            [indexPaths ch_addObject:[NSIndexPath indexPathForRow:rows - 1 inSection:section]];
        }
            break;
    }
    if (indexPaths.count <= 1) return indexPaths.copy;
    
    return [indexPaths ch_deduplicatedArray];
}

#pragma mark - Swizzle
- (void)_ch_ui_table_view_setDelegate:(id<UITableViewDelegate>)delegate {
    [self _ch_ui_table_view_setDelegate:delegate];

    [self _ch_swizzleUITableViewDelegateMethod:@selector(tableView:viewForHeaderInSection:)];
    [self _ch_swizzleUITableViewDelegateMethod:@selector(tableView:viewForFooterInSection:)];
}

- (void)_ch_swizzleUITableViewDelegateMethod:(SEL)selector {
    if (!self.delegate) return;
    if (![self.delegate respondsToSelector:selector]) return;
    
    NSArray *selectors = @[
        [NSValue ch_valueWithSelector:selector],
    ];
    CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix([self.delegate class], selectors, @"_ch_ui_table_view_");
}

@end


@implementation NSIndexPath (CHUITableView)

- (BOOL)ch_isEqualToSection:(NSIndexPath *)indexPath {
    if (!indexPath) return NO;
    if (![indexPath isKindOfClass:[NSIndexPath class]]) return NO;
    if (self == indexPath) return YES;
    
    return self.section == indexPath.section;
}

- (BOOL)ch_isEqualToRow:(NSIndexPath *)indexPath {
    if (!indexPath) return NO;
    if (![indexPath isKindOfClass:[NSIndexPath class]]) return NO;
    if (self == indexPath) return YES;
    
    return self.row == indexPath.row;
}

- (NSIndexPath *)ch_indexPathByAddingSection:(NSInteger)section {
    return [self ch_indexPathByAddingRow:0 section:section];
}

- (NSIndexPath *)ch_indexPathByAddingRow:(NSInteger)row {
    return [self ch_indexPathByAddingRow:row section:0];
}

- (NSIndexPath *)ch_indexPathByAddingRow:(NSInteger)row section:(NSInteger)section {
    return [NSIndexPath indexPathForRow:self.row + row inSection:self.section + section];
}

@end


@interface NSObject (CHUITableViewDelegate)
@end

@implementation NSObject (CHUITableViewDelegate)

- (UIView *)_ch_ui_table_view_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [self _ch_ui_table_view_tableView:tableView viewForHeaderInSection:section];
    if (view) {
        [tableView._ch_headersForSections setObject:view forKey:@(section)];
    } else {
        [tableView._ch_headersForSections removeObjectForKey:@(section)];
    }
    return view;
}

- (UIView *)_ch_ui_table_view_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [self _ch_ui_table_view_tableView:tableView viewForFooterInSection:section];
    if (view) {
        [tableView._ch_footersForSections setObject:view forKey:@(section)];
    } else {
        [tableView._ch_footersForSections removeObjectForKey:@(section)];
    }
    return view;
}

@end
