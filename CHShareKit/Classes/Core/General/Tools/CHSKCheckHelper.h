//
//  CHSKCheckHelper.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>
#import "CHSKDefines.h"

@class CHSKShareMessage;

NS_ASSUME_NONNULL_BEGIN

@interface CHSKCheckHelper : NSObject

#pragma mark - Check Share Message
/**
 根据分享平台类型, 检测分享信息是否有效
 
 @param shareMessage 分享信息
 @param platformType 分享平台类型
 @return 分享信息有效返回CHSKWXShareMessageValidCode, 否则返回CHSKErrorCode
 */
+ (NSInteger)isValidShareMessage:(CHSKShareMessage *)shareMessage forSharePlatform:(CHSKPlatformType)platformType;

/**
 检测微信好友分享信息是否有效
 
 @param shareMessage 分享信息
 @return 分享信息有效返回CHSKWXShareMessageValidCode, 否则返回CHSKErrorCode
 */
+ (NSInteger)isValidShareMessageForWXSession:(CHSKShareMessage *)shareMessage;

/**
 检测微信朋友圈分享信息是否有效
 
 @param shareMessage 分享信息
 @return 分享信息有效返回CHSKWXShareMessageValidCode, 否则返回CHSKErrorCode
 */
+ (NSInteger)isValidShareMessageForWXTimeline:(CHSKShareMessage *)shareMessage;

/**
 检测QQ好友分享信息是否有效
 
 @param shareMessage 分享信息
 @return 分享信息有效返回CHSKWXShareMessageValidCode, 否则返回CHSKErrorCode
 */
+ (NSInteger)isValidShareMessageForQQFriends:(CHSKShareMessage *)shareMessage;

/**
 检测QQ空间分享信息是否有效
 
 @param shareMessage 分享信息
 @return 分享信息有效返回CHSKWXShareMessageValidCode, 否则返回CHSKErrorCode
 */
+ (NSInteger)isValidShareMessageForQZone:(CHSKShareMessage *)shareMessage;

@end

NS_ASSUME_NONNULL_END
