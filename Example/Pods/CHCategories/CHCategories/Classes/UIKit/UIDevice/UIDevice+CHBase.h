//
//  UIDevice+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/9.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 设备网络传输类型:
 
 WWAN: Wireless Wide Area Network. -> 2G/3G/4G.
 
 WIFI: Wi-Fi.
 
 AWDL: Apple Wireless Direct Link (peer-to-peer connection). -> AirDrop, AirPlay, GameKit
 */
typedef NS_OPTIONS(NSUInteger, CHUIDeviceNetworkTrafficType) {
    CHUIDeviceNetworkTrafficTypeWWANSent     = 1 << 0,
    CHUIDeviceNetworkTrafficTypeWWANReceived = 1 << 1,
    CHUIDeviceNetworkTrafficTypeWIFISent     = 1 << 2,
    CHUIDeviceNetworkTrafficTypeWIFIReceived = 1 << 3,
    CHUIDeviceNetworkTrafficTypeAWDLSent     = 1 << 4,
    CHUIDeviceNetworkTrafficTypeAWDLReceived = 1 << 5,
    
    CHUIDeviceNetworkTrafficTypeWWAN = CHUIDeviceNetworkTrafficTypeWWANSent | CHUIDeviceNetworkTrafficTypeWWANReceived,
    CHUIDeviceNetworkTrafficTypeWIFI = CHUIDeviceNetworkTrafficTypeWIFISent | CHUIDeviceNetworkTrafficTypeWIFIReceived,
    CHUIDeviceNetworkTrafficTypeAWDL = CHUIDeviceNetworkTrafficTypeAWDLSent | CHUIDeviceNetworkTrafficTypeAWDLReceived,
    
    CHUIDeviceNetworkTrafficTypeALL = CHUIDeviceNetworkTrafficTypeWWAN |
    CHUIDeviceNetworkTrafficTypeWIFI |
    CHUIDeviceNetworkTrafficTypeAWDL,
};

@interface UIDevice (CHBase)

#pragma mark - Base
/**
 获取设备系统版本

 @return 设备系统版本
 */
+ (float)ch_systemVersion;

@property (nonatomic, readonly) NSString *ch_currentLanguage; ///< 获取设备当前语言

/**
 设备的机器型号("iPhone6,1", http://theiphonewiki.com/wiki/Models )
 */
@property (nonatomic, readonly) NSString *ch_machineModel;

/**
 设备的机器型号名称("iPhone 5s", http://theiphonewiki.com/wiki/Models )
 */
@property (nullable, nonatomic, readonly) NSString *ch_machineModelName;

/**
 设备的开机时间
 */
@property (nonatomic, readonly) NSDate *ch_systemUptime;

#pragma mark - CPU Info
@property (nonatomic, readonly) NSUInteger ch_cpuCount;                       ///< 获取运行该进程的系统的处于激活状态的CPU处理器(内核)数量
@property (nonatomic, readonly) float ch_cpuUsage;                            ///< 获取当前CPU的占用率(1.0 -> 100%. error -> -1)
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *ch_cpuUsagePerProcessor; ///< 获取当前CPU每个处理器(内核)的占用率(1.0 -> 100%. error -> nil)

#pragma mark - Disk Info
@property (nonatomic, readonly) int64_t ch_diskSpace;     ///< 当前硬盘总空间(单位字节, error -> -1)
@property (nonatomic, readonly) int64_t ch_diskSpaceFree; ///< 当前硬盘空闲空间(单位字节, error -> -1)
@property (nonatomic, readonly) int64_t ch_diskSpaceUsed; ///< 当前硬盘已使用空间(单位字节, error -> -1)

#pragma mark - Memory Info
@property (nonatomic, readonly) int64_t ch_memoryTotal;     ///< 当前内存物理总空间(单位字节, error -> -1)
@property (nonatomic, readonly) int64_t ch_memoryUsed;      ///< 当前内存已使用空间(单位字节, active + inactive + wired, error -> -1)
@property (nonatomic, readonly) int64_t ch_memoryFree;      ///< 当前内存空闲空间(单位字节, error -> -1)
@property (nonatomic, readonly) int64_t ch_memoryActive;    ///< 当前内存活动空间(单位字节, 已使用, 但可被分页. error -> -1)
@property (nonatomic, readonly) int64_t ch_memoryInactive;  ///< 当前内存不活跃空间(单位字节, 内存不足时, 应用可抢占这部分内存, 可看作空闲内存. error -> -1)
@property (nonatomic, readonly) int64_t ch_memoryWired;     ///< 当前内存系统核心占用空间(单位字节, 已使用, 且不可被分页. error -> -1)
@property (nonatomic, readonly) int64_t ch_memoryPurgeable; ///< 当前内存可回收内存空间(单位字节, error -> -1)

#pragma mark - Network Info
@property (nullable, nonatomic, readonly) NSString *ch_ipAddressWIFI; ///< 设备当前WIFI IP地址(或为nil, @"192.168.1.111");
@property (nullable, nonatomic, readonly) NSString *ch_ipAddressCell; ///< 设备当前Cell IP地址(可为nil, @"10.2.2.222");
@property (nullable, nonatomic, readonly) NSString *ch_macAddress;    ///< 设备的Mac地址(iOS 7以后，无法通过该接口获取有效Mac地址)

/**
 根据设备网络传输类型, 获取设备网络传输数据大小(单位字节, 从上次启动时间算起)
 Usage:
 
 uint64_t bytes = [[UIDevice currentDevice] getNetworkTrafficBytes:CHNetworkTrafficTypeALL];
 NSTimeInterval time = CACurrentMediaTime();
 
 uint64_t bytesPerSecond = (bytes - _lastBytes) / (time - _lastTime);
 
 _lastBytes = bytes;
 _lastTime = time;
 
 @param types 设备网络传输类型
 @return 设备网络传输数据大小
 */
- (uint64_t)ch_getNetworkTrafficBytes:(CHUIDeviceNetworkTrafficType)types;

#pragma mark - SIM Info
@property (nullable, nonatomic, readonly) NSString *ch_SIMCarrierName; ///< 获取设备SIM卡运营商名字(无则返回nil)

@end

NS_ASSUME_NONNULL_END
