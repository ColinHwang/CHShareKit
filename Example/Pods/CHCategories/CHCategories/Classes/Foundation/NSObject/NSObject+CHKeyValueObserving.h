//
//  NSObject+CHKeyValueObserving.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//  KVO

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CHKeyValueObserving)

/**
 根据KeyPath, 注册KVO通知事件回调(Block与Block捕获的对象被引用, 调用removeObserverBlocksForKeyPath:或removeObserverBlocks方法释放)
 
 @param keyPath KVO观察的属性对应的KeyPath(KeyPath不能为nil)
 @param block   KVO通知注册事件回调
 */
- (void)ch_addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldValue, id newValue))block;

/**
 停止并释放KeyPath对应的所有KVO回调事件(通过ch_addObserverBlockForKeyPath:block:添加)
 
 @param keyPath  KVO观察的属性对应的KeyPath, 与KVO通知注册事件回调对应
 */
- (void)ch_removeObserverBlocksForKeyPath:(NSString *)keyPath;

/**
 停止并释放所有KVO回调事件(通过ch_addObserverBlockForKeyPath:block:添加)
 */
- (void)ch_removeObserverBlocks;

@end

NS_ASSUME_NONNULL_END
