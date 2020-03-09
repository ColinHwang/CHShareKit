//
//  CHSKUser.h
//  
//
//  Created by CHwang on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "CHSKCredential.h"

#import "CHSKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHSKUser : NSObject

@property (nonatomic, strong) CHSKCredential *credential; ///< 授权凭证， 为nil则表示尚未授权
@property (nonatomic) CHSKPlatformType platformType;      ///< 平台类型
@property (nonatomic, copy) NSString *uid;                ///< 用户标识
@property (nonatomic, copy) NSString *nickname;           ///< 昵称
@property (nonatomic, copy) NSString *icon;               ///< 头像
@property (nonatomic) CHSKUserGender gender;              ///< 性别
@property (nonatomic, copy) NSString *url;                ///< 用户主页
@property (nonatomic, copy) NSString *aboutMe;            ///< 用户简介
@property (nonatomic) NSInteger verifyType;               ///< 认证用户类型
@property (nonatomic, copy) NSString *verifyReason;       ///< 认证描述
@property (nonatomic, strong) NSDate *birthday;           ///< 生日
@property (nonatomic) NSInteger followerCount;            ///< 粉丝数
@property (nonatomic) NSInteger friendCount;              ///< 好友数
@property (nonatomic) NSInteger shareCount;               ///< 分享数
@property (nonatomic) NSTimeInterval regAt;               ///< 注册时间
@property (nonatomic) NSInteger level;                    ///< 用户等级
@property (nonatomic, strong) NSArray *educations;        ///< 教育信息
@property (nonatomic, strong) NSArray *works;             ///< 职业信息
@property (nonatomic, strong) NSDictionary *rawData;      ///< 原始数据

@end

NS_ASSUME_NONNULL_END
