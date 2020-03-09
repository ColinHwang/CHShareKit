//
//  UITableView+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CHUITableViewDeleteOrder) { ///< 删除顺序
    CHUITableViewDeleteOrderNone      = 0,             ///< 无序
    CHUITableViewDeleteOrderAscending = 1,             ///< 正序
    CHUITableViewDeleteOrderDecending = 2,             ///< 逆序
};

typedef NS_ENUM(NSInteger, CHUITableViewCellPosition) { ///< Cell所在的位置
    CHUITableViewCellPositionNone   = 0,                ///< 无
    CHUITableViewCellPositionTop    = 1 << 0,           ///< 顶部
    CHUITableViewCellPositionMiddle = 1 << 1,           ///< 中间范围
    CHUITableViewCellPositionBottom = 1 << 2,           ///< 底部
    CHUITableViewCellPositionSingle = CHUITableViewCellPositionTop | CHUITableViewCellPositionMiddle | CHUITableViewCellPositionBottom, ///< 单独
};

@interface UITableView (CHBase)

#pragma mark - Base
@property (nonatomic, readonly) NSInteger ch_firstSection; ///< 获取首个Section(无则返回-1)
@property (nonatomic, readonly) NSInteger ch_lastSection;  ///< 获取最末Section(无则返回-1)

/**
 获取指定Section的首行Row(无则返回-1)

 @param section Section
 @return 首行Row
 */
- (NSInteger)ch_firstRowInSection:(NSUInteger)section;

/**
 获取指定Section的最末Row(无则返回-1)

 @param section Section
 @return 获取指定Section的最末Row
 */
- (NSInteger)ch_lastRowInSection:(NSUInteger)section;

/**
 获取首个IndexPath(无则返回nil)
 */
@property (nullable, nonatomic, readonly) NSIndexPath *ch_firstIndexPath;

/**
 获取最末IndexPath(无则返回nil)
 */
@property (nullable, nonatomic, readonly) NSIndexPath *ch_lastIndexPath;

/**
 获取Section对应的首个IndexPath(无则返回nil)

 @param section Section
 @return Section对应的首个IndexPath(无则返回nil)
 */
- (nullable NSIndexPath *)ch_firstIndexPathInSection:(NSUInteger)section;

/**
 获取Section对应的最末IndexPath(无则返回nil)

 @param section Section
 @return Section对应的最末IndexPath(无则返回nil)
 */
- (nullable NSIndexPath *)ch_lastIndexPathInSection:(NSUInteger)section;

/**
 获取完整Sections中Rows的数量
 */
@property (nonatomic, readonly) NSInteger ch_numberOfRowsInSections;

/**
 获取完整Sections中Rows对应的IndexPath集(无则返回空数组)
 */
@property (nonatomic, readonly) NSArray<NSIndexPath *> *ch_indexPathsForRows;

/**
 获取指定Section中Rows对应的IndexPath集(无则返回空数组)

 @param section 指定Section
 @return 指定Section中Rows对应的IndexPath集
 */
- (NSArray<NSIndexPath *> *)ch_indexPathsForRowsInSection:(NSUInteger)section;

/**
 获取IndexPath范围内的IndexPath集(无则返回空数组)

 @param fromIndexPath IndexPath(nil则为首个IndexPath)
 @param toIndexPath IndexPath(nil则为最末IndexPath)
 @return IndexPath范围内的IndexPath集(无则返回空数组)
 */
- (NSArray<NSIndexPath *> *)ch_indexPathsForRowsFromIndexPath:(nullable NSIndexPath *)fromIndexPath toIndexPath:(nullable NSIndexPath *)toIndexPath;

/**
 是否包含指定Section

 @param section Section
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsSection:(NSUInteger)section;

/**
 是否包含指定Section集

 @param sections Section集
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsSections:(NSIndexSet *)sections;

/**
 指定Section是否包含指定Row

 @param row     Row
 @param section Section
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsRow:(NSUInteger)row inSection:(NSUInteger)section;

/**
 是否包含指定IndexPath(根据Section/Row判断)
 
 @param indexPath IndexPath
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsIndexPath:(NSIndexPath *)indexPath;

/**
 是否包含指定IndexPath集(根据Section/Row判断)

 @param indexPaths IndexPath集
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 设置DataSource和Delegate执行者, 执行者须遵循<UITableViewDataSource, UITableViewDelegate>协议

 @param dataSourceDelegate DataSource和Delegate执行者
 */
- (void)ch_setupDataSourceDelegate:(id)dataSourceDelegate;

/**
 *  移除DataSource和Delegate执行者(nil)
 */
- (void)ch_removeDataSourceDelegate;

/**
 标记一个tableView的动画块,  增、删、选中rows或sections时使用, 协调UITableView的动画效果(在动画块内, 不建议使用reloadData方法, 会影响动画效果)

 @param block 动画块
 */
- (void)ch_updateWithBlock:(void(^)(UITableView *tableView))block;

/**
 获取Sectionf对应的Rows集的Rect

 @param section Sectionf
 @return Sectionf对应的Rows集的Rect
 */
- (CGRect)ch_rectForRowsInSection:(NSInteger)section;

/**
 获取Point对应的Header所在的Section(无则返回-1)

 @param point Point
 @return Point对应的Header所在的Section(无则返回-1)
 */
- (NSInteger)ch_sectionForHeaderAtPoint:(CGPoint)point;

/**
 获取Point对应的Footer所在的Section(无则返回-1)

 @param point Point
 @return Point对应的Footer所在的Section(无则返回-1)
 */
- (NSInteger)ch_sectionForFooterAtPoint:(CGPoint)point;

/**
 获取HeaderView对应的Section(HeaderView不可视/无则返回-1)

 @param headerView HeaderView
 @return HeaderView对应的Section(HeaderView不可视/无则返回-1)
 */
- (NSInteger)ch_sectionForHeaderView:(UIView *)headerView;

/**
 获取FooterView对应的Section(FooterView不可视/无则返回-1)

 @param footerView FooterView
 @return FooterView对应的Section(FooterView不可视/无则返回-1)
 */
- (NSInteger)ch_sectionForFooterView:(UIView *)footerView;

/**
 获取指定范围内, 对应的Header集所在的Section集(无则返回空数组)

 @param rect 指定范围
 @return 指定范围内, 对应的Header集所在的Section集(无则返回空数组)
 */
- (NSArray<NSNumber *> *)ch_sectionsForHeadersInRect:(CGRect)rect;

/**
 获取指定范围内, 对应的Footer集所在的Section集(无则返回空数组)

 @param rect 指定范围
 @return 指定范围内, 对应的Footer集所在的Section集(无则返回空数组)
 */
- (NSArray<NSNumber *> *)ch_sectionsForFootersInRect:(CGRect)rect;

/**
 获取在Row内的View对应的IndexPath(无则返回nil)

 @param view Cell内的View
 @return Cell内的View对应的IndexPath(无则返回nil)
 */
- (nullable NSIndexPath *)ch_indexPathForViewInRow:(UIView *)view;

/**
 获取在Header内的View对应的Section(无则返回-1)

 @param view Header内的View
 @return Header内的View对应的Section(无则返回-1)
 */
- (NSInteger)ch_sectionForViewInHeader:(UIView *)view;

/**
 获取在Footer内的View对应的Section(无则返回-1)
 
 @param view Footer内的View
 @return Footer内的View对应的Section(无则返回-1)
 */
- (NSInteger)ch_sectionForViewInFooter:(UIView *)view;

/**
 获取Section对应的HeaderView(无则返回nil)

 @param section Section
 @return Section对应的HeaderView(无则返回nil)
 */
- (nullable UIView *)ch_headerViewForSection:(NSUInteger)section;

/**
 获取Section对应的FooterView(无则返回nil)
 
 @param section Section
 @return Section对应的FooterView(无则返回nil)
 */
- (nullable UIView *)ch_footerViewForSection:(NSUInteger)section;

#pragma mark - Estimated Height
//@property (nonatomic, assign) BOOL ch_estimatedRowHeightEnabled;           ///< 是否开启Row预估高度
//@property (nonatomic, assign) BOOL ch_estimatedSectionHeaderHeightEnabled; ///< 是否开启Section Header预估高度
//@property (nonatomic, assign) BOOL ch_estimatedSectionFooterHeightEnabled; ///< 是否开启Section Header预估高度

#pragma mark - Stick
/**
 判断Section对应的Header是否粘附在顶部(Style须为UITableViewStylePlain, Header将要进入/离开顶部为非粘附状态)

 @param section Section
 @return 粘附返回YES, 否则返回NO
 */
- (BOOL)ch_isStickyHeaderForSection:(NSUInteger)section;

/**
 判断Section对应的Footer是否粘附在底部(Style须为UITableViewStylePlain, Footer将要进入/离开顶部为非粘附状态)

 @param section Section
 @return 粘附返回YES, 否则返回NO
 */
- (BOOL)ch_isStickyFooterForSection:(NSUInteger)section;

/**
 获取粘附在顶部的Header对应的Section(Style须为UITableViewStylePlain, Header将要进入/离开顶部为非粘附状态, 无则返回-1)

 @return 粘附在顶部的Header对应的Section(Style须为UITableViewStylePlain, Header将要进入/离开顶部为非粘附状态, 无则返回-1)
 */
- (NSInteger)ch_sectionForStickyHeader;

/**
 获取粘附在底部的Footer对应的Section(Style须为UITableViewStylePlain, Footer将要进入/离开底部为非粘附状态, 无则返回-1)

 @return 粘附在底部的Footer对应的Section(Style须为UITableViewStylePlain, Footer将要进入/离开底部为非粘附状态, 无则返回-1)
 */
- (NSInteger)ch_sectionForStickyFooter;

#pragma mark - Visible
/**
 判断IndexPath对应的Row是否可视
 
 @param indexPath IndexPath
 @return 可视返回YES, 否则返回NO
 */
- (BOOL)ch_isVisibleRowForIndexPath:(NSIndexPath *)indexPath;

/**
 判断Section对应的Header是否可视
 
 @param section Section
 @return 可视返回YES, 否则返回NO
 */
- (BOOL)ch_isVisibleHeaderInSection:(NSUInteger)section;

/**
 判断Section对应的Footer是否可视
 
 @param section 判断Section对应的Header是否可视
 @return 可视返回YES, 否则返回NO
 */
- (BOOL)ch_isVisibleFooterInSection:(NSUInteger)section;

/**
 获取可视Row集对应的IndexPath集(类似`indexPathsForVisibleRows`, 升序排序, 无则返回空数组)
 */
@property (nonatomic, readonly) NSArray<NSIndexPath *> *ch_indexPathsForVisibleRows;

/**
  获取可视Header集对应的Section集(无则返回空数组)
 */
@property (nonatomic, readonly) NSArray<NSNumber *> *ch_sectionsForVisibleHeaders;

/**
 获取可视Footer集对应的Section集(无则返回空数组)
 */
@property (nonatomic, readonly) NSArray<NSNumber *> *ch_sectionsForVisibleFooters;

/**
 获取首个可视Row对应的IndexPath(无则返回nil)
 */
@property (nullable, nonatomic, readonly) NSIndexPath *ch_indexPathForFirstVisibleRow;

/**
 获取最末可视Row对应的IndexPath(无则返回nil)
 */
@property (nullable, nonatomic, readonly) NSIndexPath *ch_indexPathForLastVisibleRow;

/**
 获取首个可视Header对应的Section(无则返回-1)
 */
@property (nonatomic, readonly) NSInteger ch_sectionForFirstVisibleHeader;

/**
 获取最末可视Header对应的Section(无则返回-1)
 */
@property (nonatomic, readonly) NSInteger ch_sectionForLastVisibleHeader;

/**
 获取首个可视Footer对应的Section(无则返回-1)
 */
@property (nonatomic, readonly) NSInteger ch_sectionForFirstVisibleFooter;

/**
 获取最末可视Footer对应的Section(无则返回-1)
 */
@property (nonatomic, readonly) NSInteger ch_sectionForLastVisibleFooter;

#pragma mark - Scroll
/**
 滑动到指定的Section和Row(滑动到Row顶部, 默认动画, 越界则不执行)

 @param row     Row
 @param section Section
 */
- (void)ch_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section;

/**
 *  滑动到指定的Section和Row(滑动到Row顶部, 越界则不执行)
 *
 *  @param row      Row
 *  @param section  Section
 *  @param animated 动画
 */
- (void)ch_scrollToRow:(NSUInteger)row
             inSection:(NSUInteger)section
              animated:(BOOL)animated;

/**
 滑动到指定的Section和Row(越界则不执行)

 @param row            Row
 @param section        Section
 @param scrollPosition 滑动位置
 @param animated       动画
 */
- (void)ch_scrollToRow:(NSUInteger)row
             inSection:(NSUInteger)section
      atScrollPosition:(UITableViewScrollPosition)scrollPosition
              animated:(BOOL)animated;

/**
 滑动到指定的IndexPath位置(类似`scrollToRowAtIndexPath:atScrollPosition:animated:`, 越界则不执行)

 @param indexPath IndexPath
 @param scrollPosition 滑动位置
 @param animated 动画
 */
- (void)ch_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

#pragma mark - Insert
/**
 根据指定的Section和Row, 插入Row(无动画, 越界则不执行)

 @param row     Row
 @param section Section
 */
- (void)ch_insertRow:(NSUInteger)row inSection:(NSUInteger)section;

/**
 *  根据指定的Section和Row, 插入Row(越界则不执行)
 *
 *  @param row       Row
 *  @param section   Section
 *  @param animation 动画
 */
- (void)ch_insertRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的IndexPath, 插入Row(无动画, 越界则不执行)

 @param indexPath IndexPath
 */
- (void)ch_insertRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据指定的IndexPath, 插入Row(越界则不执行)

 @param indexPath IndexPath
 @param animation 动画
 */
- (void)ch_insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的IndexPath集, 插入Row(类似`insertRowsAtIndexPaths:withRowAnimation`, 越界则不执行)

 @param indexPaths IndexPath集
 @param animation 动画
 */
- (void)ch_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的Section, 插入Section(无动画, 越界则不执行)

 @param section Section
 */
- (void)ch_insertSection:(NSUInteger)section;

/**
 根据指定的Section, 插入Section(越界则不执行)

 @param section   Section
 @param animation 动画
 */
- (void)ch_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的Section集, 插入Section(类似`insertSections:withRowAnimation:`, 越界则不执行)
 
 @param sections  Section集
 @param animation 动画
 */
- (void)ch_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

#pragma mark - Delete
/**
 根据指定的Section和Row, 删除Row(无动画, 越界则不执行)

 @param row     Row
 @param section Section
 */
- (void)ch_deleteRow:(NSUInteger)row inSection:(NSUInteger)section;

/**
 根据指定的Section和Row, 删除Row(越界则不执行)

 @param row       Row
 @param section   Section
 @param animation 动画
 */
- (void)ch_deleteRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据IndexPath, 删除Row(无动画, 越界则不执行)

 @param indexPath IndexPath
 */
- (void)ch_deleteRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据IndexPath, 删除Row(越界则不执行)

 @param indexPath IndexPath
 @param animation 动画
 */
- (void)ch_deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据IndexPaths集, 删除Row(无序/正序/逆序删除, 越界则不执行)

 @param indexPaths  IndexPaths集
 @param deleteOrder 删除顺序
 @param animation   动画
 */
- (void)ch_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                      deleteOrder:(CHUITableViewDeleteOrder)deleteOrder
                 withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据IndexPaths集, 删除Row(类似`deleteRowsAtIndexPaths:withRowAnimation:`, 越界则不执行)

 @param indexPaths IndexPaths集
 @param animation 动画
 */
- (void)ch_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的Section, 删除Section(无动画, 越界则不执行)

 @param section Section
 */
- (void)ch_deleteSection:(NSUInteger)section;

/**
 根据指定的Section, 删除Section(越界则不执行)

 @param section   Section
 @param animation 动画
 */
- (void)ch_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的Section集, 删除Section(类似`deleteSections:withRowAnimation:`, 越界则不执行)

 @param sections Section集
 @param animation 动画
 */
- (void)ch_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

#pragma mark - Reload
/**
 根据指定的Section和Row, 刷新Row(无动画, 越界则不执行)

 @param row     Row
 @param section Section
 */
- (void)ch_reloadRow:(NSUInteger)row inSection:(NSUInteger)section;

/**
 根据指定的Section和Row, 刷新Row(越界则不执行)

 @param row Row
 @param section Section
 @param animation 动画
 */
- (void)ch_reloadRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的IndexPath, 刷新Row(无动画, 越界则不执行)

 @param indexPath IndexPath
 */
- (void)ch_reloadRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据指定的IndexPath, 刷新Row(越界则不执行)

 @param indexPath IndexPath
 @param animation 动画
 */
- (void)ch_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 刷新当前可视的所有Rows(无动画, 越界则不执行)
 */
- (void)ch_reloadVisibleRows;

/**
 刷新当前可视的所有Rows(越界则不执行)

 @param animation 动画
 */
- (void)ch_reloadVisibleRowsWithRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的IndexPath集, 刷新Row(类似`reloadRowsAtIndexPaths:withRowAnimation:`, 越界则不执行)

 @param indexPaths IndexPath集
 @param animation 动画
 */
- (void)ch_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的Section, 刷新Section(无动画, 越界则不执行)

 @param section Section
 */
- (void)ch_reloadSection:(NSUInteger)section;

/**
 根据指定的Section, 刷新Section(越界则不执行)

 @param section   Section
 @param animation 动画
 */
- (void)ch_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 根据指定的Section集, 刷新Section(类似`reloadSections:withRowAnimation:`, 越界则不执行)

 @param sections Section集
 @param animation 动画
 */
- (void)ch_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

#pragma mark - Select
/**
 清除所有选中Rows的选中状态

 @param animated 动画
 */
- (void)ch_clearSelectedRows:(BOOL)animated;

#pragma mark - Position
/**
 获取IndexPath对应的Row在所有Rows中的位置(无则返回CHUITableViewCellPositionNone)
 
 @param indexPath IndexPath
 @return IndexPath对应的Row在完整Sections中的位置(无则返回CHUITableViewCellPositionNone)
 */
- (CHUITableViewCellPosition)ch_positionForRowInRows:(NSIndexPath *)indexPath;

/**
 获取IndexPath对应的Row在当前Section的位置(无则返回CHUITableViewCellPositionNone)

 @param indexPath IndexPath
 @return IndexPath对应的Row在当前Section的位置(无则返回CHUITableViewCellPositionNone)
 */
- (CHUITableViewCellPosition)ch_positionForRowInSection:(NSIndexPath *)indexPath;

/**
 获取Row在所有Rows中的位置对应的IndexPath集(无则返回空数组)

 @param postion Row在所有Rows中的位置
 @return Row在所有Rows中的位置对应的IndexPath集(无则返回空数组)
 */
- (NSArray<NSIndexPath *> *)ch_indexPathsForPositionInRows:(CHUITableViewCellPosition)postion;

/**
 获取Row在当前Section的位置对应的IndexPath集(无则返回空数组)

 @param postion Row在当前Section的位置
 @param section Section
 @return Row在当前Section的位置对应的IndexPath集(无则返回空数组)
 */
- (NSArray<NSIndexPath *> *)ch_indexPathsForPosition:(CHUITableViewCellPosition)postion inSection:(NSUInteger)section;

@end


@interface NSIndexPath (CHUITableView)

/**
 判断两个IndexPath的Section是否相等

 @param indexPath 另一个IndexPath
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isEqualToSection:(NSIndexPath *)indexPath;

/**
 判断两个IndexPath的Row是否相等

 @param indexPath 另一个IndexPath
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isEqualToRow:(NSIndexPath *)indexPath;

/**
 指定添加Section数, 获取新IndexPath(Row不变)

 @param section 添加Section数
 @return 新IndexPath(Row不变)
 */
- (NSIndexPath *)ch_indexPathByAddingSection:(NSInteger)section;

/**
 指定添加Row数, 获取新的IndexPath(Section不变)

 @param row 添加Row数
 @return 新IndexPath(Section不变)
 */
- (NSIndexPath *)ch_indexPathByAddingRow:(NSInteger)row;

/**
 指定添加Row数和Section数, 获取新的IndexPath

 @param row 添加Row数
 @param section 添加Section数
 @return 新IndexPath
 */
- (NSIndexPath *)ch_indexPathByAddingRow:(NSInteger)row section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
