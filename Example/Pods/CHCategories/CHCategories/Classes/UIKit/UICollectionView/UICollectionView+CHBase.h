//
//  UICollectionView+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CHUICollectionViewDeleteOrder) { ///< 删除顺序
    CHUICollectionViewDeleteOrderNone      = 0,             ///< 无序
    CHUICollectionViewDeleteOrderAscending = 1,             ///< 正序
    CHUICollectionViewDeleteOrderDecending = 2,             ///< 逆序
};

@interface UICollectionView (CHBase)

#pragma mark - Base
@property (nonatomic, readonly) NSInteger ch_firstSection; ///< 获取首个Section(无则返回-1)
@property (nonatomic, readonly) NSInteger ch_lastSection;  ///< 获取最末Section(无则返回-1)

/**
 获取指定Section的首个Item(无则返回-1)

 @param section Section
 @return 首个Item
 */
- (NSInteger)ch_firstItemInSection:(NSUInteger)section;

/**
 获取指定Section的最末Item(无则返回-1)

 @param section Section
 @return 最末Item
 */
- (NSInteger)ch_lastItemInSection:(NSUInteger)section;

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
 获取完整Sections中Items的数量
 */
@property (nonatomic, readonly) NSInteger ch_numberOfItemsInSections;

/**
 获取完整Sections中Items对应的IndexPath集(无则返回空数组)
 */
@property (nonatomic, readonly) NSArray<NSIndexPath *> *ch_indexPathsForItems;

/**
 获取指定Section中Items对应的IndexPath集(无则返回空数组)
 
 @param section 指定Section
 @return 指定Section中Rows对应的IndexPath集
 */
- (NSArray<NSIndexPath *> *)ch_indexPathsForItemsInSection:(NSUInteger)section;

/**
 获取IndexPath范围内的IndexPath集(无则返回空数组)
 
 @param fromIndexPath IndexPath(nil则为首个IndexPath)
 @param toIndexPath IndexPath(nil则为最末IndexPath)
 @return IndexPath范围内的IndexPath集(无则返回空数组)
 */
- (NSArray<NSIndexPath *> *)ch_indexPathsForItemsFromIndexPath:(nullable NSIndexPath *)fromIndexPath toIndexPath:(nullable NSIndexPath *)toIndexPath;

/**
 是否包含指定Section
 
 @param section Section
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsSection:(NSUInteger)section;

/**
 指定Section是否包含指定Item

 @param item    Item
 @param section Section
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsItem:(NSUInteger)item inSection:(NSUInteger)section;

/**
 是否包含指定IndexPath(根据Section/Item判断)
 
 @param indexPath IndexPath
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsIndexPath:(NSIndexPath *)indexPath;

/**
 是否包含指定IndexPath集(根据Section/Item判断)
 
 @param indexPaths IndexPath集
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 设置DataSource和Delegate执行者, 执行者须遵循<UICollectionViewDataSource, UICollectionDelegate>协议

 @param dataSourceDelegate DataSource和Delegate执行者
 */
- (void)ch_setupDataSourceDelegate:(id)dataSourceDelegate;

/**
 移除DataSource和Delegate执行者(nil)
 */
- (void)ch_removeDataSourceDelegate;

/**
 获取在Item内的View对应的IndexPath(无则返回nil)
 
 @param view Item内的View
 @return Item内的View对应的IndexPath(无则返回nil)
 */
- (nullable NSIndexPath *)ch_indexPathForViewInItem:(UIView *)view;

#pragma mark - Visible
/**
 判断IndexPath对应的Item是否可视

 @param indexPath IndexPath
 @return 可见返回YES, 否则返回NO
 */
- (BOOL)ch_isVisibleItemForIndexPath:(NSIndexPath *)indexPath;

/**
 获取可视Item集对应的IndexPath集(类似`indexPathsForVisibleItems`, 升序排序)
 */
@property (nonatomic, readonly) NSArray<NSIndexPath *> *ch_indexPathsForVisibleItems;

/**
 获取首个可视Item对应的IndexPath(无则返回nil)
 */
@property (nonatomic, readonly) NSIndexPath *ch_indexPathForFirstVisibleItem;

/**
 获取最末可视Item对应的IndexPath(无则返回nil)
 */
@property (nonatomic, readonly) NSIndexPath *ch_indexPathForLastVisibleItem;

#pragma mark - Register
/**
 根据Nib文件, 注册HeaderView(SupplementaryView)

 @param nib        Nib文件
 @param identifier 重用标识
 */
- (void)ch_registerNib:(UINib *)nib forHeaderViewWithReuseIdentifier:(NSString *)identifier;

/**
 根据Nib文件, 注册FooterView(SupplementaryView)

 @param nib        Nib文件
 @param identifier 重用标识
 */
- (void)ch_registerNib:(UINib *)nib forFooterViewWithReuseIdentifier:(NSString *)identifier;

/**
 根据View类别, 注册HeaderView(SupplementaryView)

 @param viewClass  View类别
 @param identifier 重用标识
 */
- (void)ch_registerClass:(Class)viewClass forHeaderViewWithReuseIdentifier:(NSString *)identifier;

/**
 根据View类别, 注册FooterView(SupplementaryView)

 @param viewClass  View类别
 @param identifier 重用标识
 */
- (void)ch_registerClass:(Class)viewClass forFooterViewWithReuseIdentifier:(NSString *)identifier;

/**
 根据重用标识和IndexPath，重用HeaderView

 @param identifier 重用标识
 @param indexPath  IndexPath
 @return HeaderView
 */
- (__kindof UICollectionReusableView *)ch_dequeueReusableHeaderViewWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/**
 根据重用标识和IndexPath，重用FooterView

 @param identifier 重用标识
 @param indexPath  IndexPath
 @return FooterView
 */
- (__kindof UICollectionReusableView *)ch_dequeueReusableFooterViewWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Scroll
/**
 滑动到指定Section(Item为0, 越界则不执行)

 @param section        Section
 @param scrollPosition 滑动位置
 @param animated       动画
 */
- (void)ch_scrollToSection:(NSUInteger)section
          atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                  animated:(BOOL)animated;

/**
 滑动到指定Section和Item(滑动到Item顶部, 默认动画, 越界则不执行)

 @param item    Item
 @param section 组
 */
- (void)ch_scrollToItem:(NSUInteger)item inSection:(NSUInteger)section;

/**
 滑动到指定Section和Item(滑动到Item顶部, 越界则不执行)

 @param item     Item
 @param section  Section
 @param animated 动画
 */
- (void)ch_scrollToItem:(NSUInteger)item
              inSection:(NSUInteger)section
               animated:(BOOL)animated;

/**
 滑动到指定Section和Item(越界则不执行)

 @param item           Item
 @param section        Section
 @param scrollPosition 滑动位置
 @param animated       动画
 */
- (void)ch_scrollToItem:(NSUInteger)item
              inSection:(NSUInteger)section
       atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
               animated:(BOOL)animated;

/**
 滑动到指定IndexPath位置(类似`scrollToItemAtIndexPath:atScrollPosition:animated:`, IndexPath越界则不滑动)

 @param indexPath IndexPath
 @param scrollPosition 滑动位置
 @param animated 动画
 */
- (void)ch_scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

#pragma mark - Insert
/**
 根据指定的Section和Item, 插入Item(越界则不执行)

 @param item    Item
 @param section Section
 */
- (void)ch_insertItem:(NSUInteger)item inSection:(NSUInteger)section;

/**
 根据指定的IndexPath, 插入Item

 @param indexPath IndexPath
 */
- (void)ch_insertItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据指定的IndexPath集, 插入Item(类似`insertItemsAtIndexPaths:`, 越界则不执行)

 @param indexPaths IndexPath集
 */
- (void)ch_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 根据指定的Section, 插入Section

 @param section Section
 */
- (void)ch_insertSection:(NSUInteger)section;

/**
 根据指定的Section集, 插入Section(类似`insertSections:`, 越界则不执行)
 
 @param sections  Section集
 */
- (void)ch_insertSections:(NSIndexSet *)sections;

#pragma mark - Delete
/**
 根据指定的Section和Item, 删除Item(越界则不执行)

 @param item    Item
 @param section Section
 */
- (void)ch_deleteItem:(NSUInteger)item inSection:(NSUInteger)section;

/**
 根据指定的IndexPath, 删除Item(越界则不执行)

 @param indexPath IndexPath
 */
- (void)ch_deleteItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据IndexPaths集, 删除指定的Item(无序/正序/逆序删除, 越界则不执行)

 @param indexPaths 一组IndexPaths
 @param deleteOrder 删除顺序
 */
- (void)ch_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths deleteOrder:(CHUICollectionViewDeleteOrder)deleteOrder;

/**
 根据IndexPaths集, 删除Item(类似`deleteItemsAtIndexPath:`, 越界则不执行)

 @param indexPaths IndexPaths集
 */
- (void)ch_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 根据指定的Section, 删除Section(越界则不执行)

 @param section Section
 */
- (void)ch_deleteSection:(NSUInteger)section;

/**
 根据指定的Section集, 删除Section(越界则不执行)
 
 @param sections Section集
 */
- (void)ch_deleteSections:(NSIndexSet *)sections;

#pragma mark - Reload
/**
 根据指定的Section和Item, 刷新Item(越界则不执行)

 @param item    Item
 @param section Section
 */
- (void)ch_reloadItem:(NSUInteger)item inSection:(NSUInteger)section;

/**
 根据指定的IndexPath, 刷新Item(越界则不执行)

 @param indexPath IndexPath
 */
- (void)ch_reloadItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据指定的IndexPath集, 刷新Item(类似`reloadItemsAtIndexPaths:`, 越界则不执行)

 @param indexPaths IndexPath集
 */
- (void)ch_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 根据指定的Section, 刷新Section(越界则不执行)

 @param section Section
 */
- (void)ch_reloadSection:(NSUInteger)section;

/**
 根据指定的Section集, 刷新Section(类似`reloadSections:withRowAnimation:`, 越界则不执行)
 
 @param sections Section集
 */
- (void)ch_reloadSections:(NSIndexSet *)sections;

/**
 刷新界面并保持Item选中状态
 */
- (void)ch_reloadDataByKeepingSelection;

#pragma mark - Select
/**
 清除所有选中Item的选中状态

 @param animated 动画
 */
- (void)ch_clearSelectedItems:(BOOL)animated;

@end


@interface NSIndexPath (CHUICollectionView)
/**
 判断两个IndexPath的Item是否相等

 @param indexPath 另一个IndexPath
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isEqualToItem:(NSIndexPath *)indexPath;

/**
 指定添加Item数, 获取新IndexPath(Section不变)

 @param item 添加Item数
 @return 新IndexPath(Section不变)
 */
- (NSIndexPath *)ch_indexPathByAddingItem:(NSInteger)item;

/**
 指定添加Item数和Section数, 获取新IndexPath

 @param item    添加Item数
 @param section 添加Section数
 @return 新IndexPath
 */
- (NSIndexPath *)ch_indexPathByAddingItem:(NSInteger)item section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
