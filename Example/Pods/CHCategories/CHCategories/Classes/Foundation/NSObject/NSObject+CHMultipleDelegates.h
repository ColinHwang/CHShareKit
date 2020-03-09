//
//  NSObject+CHMultipleDelegates.h
//  CHCategories
//
//  Created by CHwang on 2018/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 多代理支持(UITableView, UICollectionView 额外默认支持dataSource)
 
 self.ch_multipleDelegatesEnabled = Yes;
 self.delegate = A;
 self.delegate = B;
 */
@interface NSObject (CHMultipleDelegates)

@property (nonatomic, assign) BOOL ch_multipleDelegatesEnabled; ///< 是否支持多代理(多播代理), 默认为NO

/**
 注册指定gatter方法名的代理, 以支持多代理模式(默认只添加@selector(delegate)的方法名)

 @param getter 指定gatter方法名的代理
 */
- (void)ch_registerDelegateSelector:(SEL)getter;

/**
 移除指定代理对象

 @param delegate 指定代理对象
 */
- (void)ch_removeDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
