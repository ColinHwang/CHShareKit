//
//  UIDevice+CHMachineInfo.h
//  CHCategories
//
//  Created by CHwang on 2019/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (CHMachineInfo)

#pragma mark - Check
@property (nonatomic, readonly) BOOL ch_isPhone;                    ///< 设备是否为iPhone
@property (nonatomic, readonly) BOOL ch_isPod;                      ///< 设备是否为iPod
@property (nonatomic, readonly) BOOL ch_isPad;                      ///< 设备是否为iPad
@property (nonatomic, readonly) BOOL ch_isSimulator;                ///< 设备是否为模拟器
@property (nonatomic, readonly) BOOL ch_isJailbroken;               ///< 设备是否为越狱设备
@property (nonatomic, readonly) BOOL ch_isTV NS_AVAILABLE_IOS(9_0); ///< 设备是否为iTV
@property (nonatomic, readonly) BOOL ch_canMakePhoneCalls;          ///< 设备是否能打电话

#pragma mark - Machine Model Info
@property (nonatomic, readonly) BOOL ch_isiPhone4;      ///< 设备是否为iPhone4
@property (nonatomic, readonly) BOOL ch_isiPhone4s;     ///< 设备是否为iPhone4s
@property (nonatomic, readonly) BOOL ch_isiPhone5;      ///< 设备是否为iPhone5
@property (nonatomic, readonly) BOOL ch_isiPhone5c;     ///< 设备是否为iPhone5c
@property (nonatomic, readonly) BOOL ch_isiPhone5s;     ///< 设备是否为iPhone5s
@property (nonatomic, readonly) BOOL ch_isiPhone6;      ///< 设备是否为iPhone6
@property (nonatomic, readonly) BOOL ch_isiPhone6Plus;  ///< 设备是否为iPhone6 Plus
@property (nonatomic, readonly) BOOL ch_isiPhone6s;     ///< 设备是否为iPhone6s
@property (nonatomic, readonly) BOOL ch_isiPhone6sPlus; ///< 设备是否为iPhone6s Plus
@property (nonatomic, readonly) BOOL ch_isiPhoneSE;     ///< 设备是否为iPhoneSE
@property (nonatomic, readonly) BOOL ch_isiPhone7;      ///< 设备是否为iPhone7
@property (nonatomic, readonly) BOOL ch_isiPhone7Plus;  ///< 设备是否为iPhone7 Plus
@property (nonatomic, readonly) BOOL ch_isiPhone8;      ///< 设备是否为iPhone8
@property (nonatomic, readonly) BOOL ch_isiPhone8Plus;  ///< 设备是否为iPhone8 Plus
@property (nonatomic, readonly) BOOL ch_isiPhoneX;      ///< 设备是否为iPhoneX
@property (nonatomic, readonly) BOOL ch_isiPhoneXR;     ///< 设备是否为iPhoneXR
@property (nonatomic, readonly) BOOL ch_isiPhoneXS;     ///< 设备是否为iPhoneXS
@property (nonatomic, readonly) BOOL ch_isiPhoneXSMax;  ///< 设备是否为iPhoneXSMax

#pragma mark - Operation System Info
@property (nonatomic, readonly) BOOL ch_isiOS6Later;  ///< 设备系统版本是否iOS6及以上
@property (nonatomic, readonly) BOOL ch_isiOS7Later;  ///< 设备系统版本是否iOS7及以上
@property (nonatomic, readonly) BOOL ch_isiOS8Later;  ///< 设备系统版本是否iOS8及以上
@property (nonatomic, readonly) BOOL ch_isiOS9Later;  ///< 设备系统版本是否iOS9及以上
@property (nonatomic, readonly) BOOL ch_isiOS10Later; ///< 设备系统版本是否iOS10及以上
@property (nonatomic, readonly) BOOL ch_isiOS11Later; ///< 设备系统版本是否iOS11及以上
@property (nonatomic, readonly) BOOL ch_isiOS12Later; ///< 设备系统版本是否iOS12及以上
@property (nonatomic, readonly) BOOL ch_isiOS13Later; ///< 设备系统版本是否iOS13及以上

@end

NS_ASSUME_NONNULL_END
