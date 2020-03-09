//
//  NSURL+CHBase.h
//  CHCategories
//
//  Created by CHwangs on 2019/2/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (CHBase)

#pragma mark - Base
/**
 获取当前URL Query的参数列表
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *ch_queryItems;

@end

NS_ASSUME_NONNULL_END
