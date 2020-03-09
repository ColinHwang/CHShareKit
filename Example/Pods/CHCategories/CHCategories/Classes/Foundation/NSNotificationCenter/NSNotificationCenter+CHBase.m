//
//  NSNotificationCenter+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/4.
//

#import "NSNotificationCenter+CHBase.h"
#include <pthread.h>

@implementation NSNotificationCenter (CHBase)

#pragma mark - Base
- (void)ch_postNotificationOnMainThread:(NSNotification *)notification {
    if (pthread_main_np()) return [self postNotification:notification]; // 当前线程为主线程 pthread_main_np() -> 当前线程为主线程, 返回非空值
    [self ch_postNotificationOnMainThread:notification waitUntilDone:NO];
}

- (void)ch_postNotificationOnMainThread:(NSNotification *)notification waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) return [self postNotification:notification];
    [[self class] performSelectorOnMainThread:@selector(_ch_postNotification:) withObject:notification waitUntilDone:wait]; // 在其他线程中，执行主线程制定的方法, waitUntilDone: -> 当前线程是否要被阻塞，直到主线程将我们制定的代码块执行完
}

- (void)ch_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:nil];
    [self ch_postNotificationOnMainThreadWithName:name object:object userInfo:nil waitUntilDone:NO];
}

- (void)ch_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:userInfo];
    [self ch_postNotificationOnMainThreadWithName:name object:object userInfo:userInfo waitUntilDone:NO];
}

- (void)ch_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:userInfo];
    NSMutableDictionary *info = [[NSMutableDictionary allocWithZone:nil] initWithCapacity:3];
    if (name) [info setObject:name forKey:@"name"];
    if (object) [info setObject:object forKey:@"object"];
    if (userInfo) [info setObject:userInfo forKey:@"userInfo"];
    [[self class] performSelectorOnMainThread:@selector(_ch_postNotificationName:) withObject:info waitUntilDone:wait];
}

// 与系统同名方法区分
+ (void)_ch_postNotification:(NSNotification *)notification  {
    [[self defaultCenter] postNotification:notification];
}

+ (void)_ch_postNotificationName:(NSDictionary *)info {
    NSString *name = [info objectForKey:@"name"];
    id object = [info objectForKey:@"object"];
    NSDictionary *userInfo = [info objectForKey:@"userInfo"];
    
    [[self defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}


@end
