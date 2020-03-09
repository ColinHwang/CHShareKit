//
//  UIDevice+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/9.
//  
//

#import "UIDevice+CHBase.h"
#import <arpa/inet.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <ifaddrs.h>
#import <mach/mach.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <sys/socket.h>
#import <sys/sysctl.h>

typedef NS_ENUM(NSUInteger, CHUIDeviceCurrentMemoryInfo) {
    CHUIDeviceCurrentMemoryInfoUsed = 1,
    CHUIDeviceCurrentMemoryInfoFree,
    CHUIDeviceCurrentMemoryInfoActive,
    CHUIDeviceCurrentMemoryInfoInactive,
    CHUIDeviceCurrentMemoryInfoWired,
    CHUIDeviceCurrentMemoryInfoPurgeable,
};

@implementation UIDevice (CHBase)

#pragma mark - Base
+ (float)ch_systemVersion {
    static float version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.floatValue;
    });
    return version;
}

- (NSString *)ch_currentLanguage {
    NSArray*languages = [NSLocale preferredLanguages];
    if (!languages || !languages.count) return @"";
    
    return [languages objectAtIndex:0];
}

- (NSString *)ch_machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (NSString *)ch_machineModelName {
    /*
     https://www.theiphonewiki.com
     */
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self ch_machineModel];
        if (!model) return;
        NSDictionary *dict = @{
                               @"Watch1,1" : @"Apple Watch 38mm",
                               @"Watch1,2" : @"Apple Watch 42mm",
                               @"Watch2,3" : @"Apple Watch Series 2 38mm",
                               @"Watch2,4" : @"Apple Watch Series 2 42mm",
                               @"Watch2,6" : @"Apple Watch Series 1 38mm",
                               @"Watch2,7" : @"Apple Watch Series 1 42mm",
                               @"Watch3,1" : @"Apple Watch Series 3 38mm (Cellular)",
                               @"Watch3,2" : @"Apple Watch Series 3 42mm (Cellular)",
                               @"Watch3,3" : @"Apple Watch Series 3 38mm",
                               @"Watch3,4" : @"Apple Watch Series 3 42mm",
                               @"Watch4,1" : @"Apple Watch Series 4 40mm",
                               @"Watch4,2" : @"Apple Watch Series 4 44mm",
                               @"Watch4,3" : @"Apple Watch Series 4 40mm (Cellular)",
                               @"Watch4,4" : @"Apple Watch Series 4 44mm (Cellular)",
                               
                               @"iPod1,1" : @"iPod touch 1",
                               @"iPod2,1" : @"iPod touch 2",
                               @"iPod3,1" : @"iPod touch 3",
                               @"iPod4,1" : @"iPod touch 4",
                               @"iPod5,1" : @"iPod touch 5",
                               @"iPod7,1" : @"iPod touch 6",
                               @"iPod9,1" : @"iPod touch 7",
                               
                               @"iPhone1,1" : @"iPhone 1G",
                               @"iPhone1,2" : @"iPhone 3G",
                               @"iPhone2,1" : @"iPhone 3GS",
                               @"iPhone3,1" : @"iPhone 4 (GSM)",
                               @"iPhone3,2" : @"iPhone 4",
                               @"iPhone3,3" : @"iPhone 4 (CDMA)",
                               @"iPhone4,1" : @"iPhone 4S",
                               @"iPhone5,1" : @"iPhone 5 (GSM)",
                               @"iPhone5,2" : @"iPhone 5 (CDMA)",
                               @"iPhone5,3" : @"iPhone 5c (GSM)",
                               @"iPhone5,4" : @"iPhone 5c (Global)",
                               @"iPhone6,1" : @"iPhone 5s (GSM)",
                               @"iPhone6,2" : @"iPhone 5s (Global)",
                               @"iPhone7,1" : @"iPhone 6 Plus",
                               @"iPhone7,2" : @"iPhone 6",
                               @"iPhone8,1" : @"iPhone 6s",
                               @"iPhone8,2" : @"iPhone 6s Plus",
                               @"iPhone8,4" : @"iPhone SE",
                               @"iPhone9,1" : @"iPhone 7",
                               @"iPhone9,2" : @"iPhone 7 Plus",
                               @"iPhone9,3" : @"iPhone 7",
                               @"iPhone9,4" : @"iPhone 7 Plus",
                               @"iPhone10,1" : @"iPhone 8",
                               @"iPhone10,2" : @"iPhone 8 Plus",
                               @"iPhone10,3" : @"iPhone X",
                               @"iPhone10,4" : @"iPhone 8",
                               @"iPhone10,5" : @"iPhone 8 Plus",
                               @"iPhone10,6" : @"iPhone X",
                               @"iPhone11,2" : @"iPhone XS",
                               @"iPhone11,4" : @"iPhone XS Max",
                               @"iPhone11,6" : @"iPhone XS Max",
                               @"iPhone11,8" : @"iPhone XR",
                               @"iPhone12,1" : @"iPhone 11",
                               @"iPhone12,3" : @"iPhone 11 Pro",
                               @"iPhone12,5" : @"iPhone 11 Pro Max",
                               
                               @"iPad1,1" : @"iPad 1",
                               @"iPad2,1" : @"iPad 2 (WiFi)",
                               @"iPad2,2" : @"iPad 2 (GSM)",
                               @"iPad2,3" : @"iPad 2 (CDMA)",
                               @"iPad2,4" : @"iPad 2 (32nm)",
                               @"iPad2,5" : @"iPad mini 1 (WiFi)",
                               @"iPad2,6" : @"iPad mini 1 (GSM)",
                               @"iPad2,7" : @"iPad mini 1 (CDMA)",
                               @"iPad3,1" : @"iPad 3 (WiFi)",
                               @"iPad3,2" : @"iPad 3 (CDMA)",
                               @"iPad3,3" : @"iPad 3 (GSM)",
                               @"iPad3,4" : @"iPad 4 (WiFi)",
                               @"iPad3,5" : @"iPad 4 (GSM)",
                               @"iPad3,6" : @"iPad 4 (CDMA)",
                               @"iPad4,1" : @"iPad Air (WiFi)",
                               @"iPad4,2" : @"iPad Air (Cellular)",
                               @"iPad4,3" : @"iPad Air (China)",
                               @"iPad4,4" : @"iPad mini 2 (WiFi)",
                               @"iPad4,5" : @"iPad mini 2 (Cellular)",
                               @"iPad4,6" : @"iPad mini 2 (China)",
                               @"iPad4,7" : @"iPad mini 3 (WiFi)",
                               @"iPad4,8" : @"iPad mini 3 (Cellular)",
                               @"iPad4,9" : @"iPad mini 3 (China)",
                               @"iPad5,1" : @"iPad mini 4",
                               @"iPad5,2" : @"iPad mini 4",
                               @"iPad5,3" : @"iPad Air 2 (WiFi)",
                               @"iPad5,4" : @"iPad Air 2 (Cellular)",
                               @"iPad6,3" : @"iPad Pro 9.7 inch (WiFi)",
                               @"iPad6,4" : @"iPad Pro 9.7 inch (Cellular)",
                               @"iPad6,7" : @"iPad Pro 12.9 inch (WiFi)",
                               @"iPad6,8" : @"iPad Pro 12.9 inch (Cellular)",
                               @"iPad6,11" : @"iPad 5 (WiFi)",
                               @"iPad6,12" : @"iPad 5 (Cellular)",
                               @"iPad7,1" : @"iPad Pro 12.9 inch 2 (WiFi)",
                               @"iPad7,2" : @"iPad Pro 12.9 inch 2 (Cellular)",
                               @"iPad7,3" : @"iPad Pro 10.5 inch (WiFi)",
                               @"iPad7,4" : @"iPad Pro 10.5 inch (Cellular)",
                               @"iPad7,5" : @"iPad 6 (WiFi)",
                               @"iPad7,6" : @"iPad 6 (Cellular)",
                               @"iPad8,1" : @"iPad Pro 11 inch (WiFi)",
                               @"iPad8,2" : @"iPad Pro 11 inch (WiFi)",
                               @"iPad8,3" : @"iPad Pro 11 inch (Cellular)",
                               @"iPad8,4" : @"iPad Pro 11 inch (Cellular)",
                               @"iPad8,5" : @"iPad Pro 12.9 inch 3 (WiFi)",
                               @"iPad8,6" : @"iPad Pro 12.9 inch 3 (WiFi)",
                               @"iPad8,7" : @"iPad Pro 12.9 inch 3 (Cellular)",
                               @"iPad11,1" : @"iPad mini 5",
                               @"iPad11,2" : @"iPad mini 5",
                               @"iPad11,3" : @"iPad Air 3",
                               @"iPad11,4" : @"iPad Air 3",
                               
                               @"AppleTV2,1" : @"Apple TV 2",
                               @"AppleTV3,1" : @"Apple TV 3",
                               @"AppleTV3,2" : @"Apple TV 3",
                               @"AppleTV5,3" : @"Apple TV 4",
                               @"AppleTV6,2" : @"Apple TV 4K",
                               
                               @"AirPods1,1" : @"AirPods 1",
                               @"AirPods2,1" : @"AirPods 2",
                               
                               @"i386" : @"Simulator x86",
                               @"x86_64" : @"Simulator x64",
                               };
        name = dict[model];
        if (!name) name = model;
    });
    return name;
}

- (NSDate *)ch_systemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}

#pragma mark - CPU Info
- (NSUInteger)ch_cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

- (float)ch_cpuUsage {
    float cpu = 0;
    NSArray *cpus = [self ch_cpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

- (NSArray<NSNumber *> *)ch_cpuUsagePerProcessor {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock; // 锁
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    }  else {
        return nil;
    }
}


#pragma mark - Disk Info
- (int64_t)ch_diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)ch_diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)ch_diskSpaceUsed {
    int64_t total = self.ch_diskSpace;
    int64_t free = self.ch_diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

#pragma mark - Memory Info
- (int64_t)ch_memoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}

static uint64_t ch_current_memory_info_get_by_type(CHUIDeviceCurrentMemoryInfo type) {
    mach_port_t host_port = mach_host_self(); // returns send rights to the task's host self port. 获取进程权限
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t); // sizeof():字节数
    vm_size_t page_size; // 页面数
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size); // Provide the system's virtual page size.
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size); //  returns scheduling and virtual memory statistics concerning the host as specified by flavor.
    if (kern != KERN_SUCCESS) return -1;
    
    switch (type) {
        case CHUIDeviceCurrentMemoryInfoUsed:
            return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count); // 乘以vm_page_size拿到字节数。free是空闲内存; active是已使用, 但可被分页的(在iOS中，只有在磁盘上静态存在的才能被分页，例如文件的内存映射，而动态分配的内存是不能被分页的); inactive是不活跃的, 实际上内存不足时, 你的应用就可以抢占这部分内存, 因此也可看作空闲内存; wire就是已使用, 且不可被分页的。
        case CHUIDeviceCurrentMemoryInfoFree:
            return vm_stat.free_count * page_size;
        case CHUIDeviceCurrentMemoryInfoActive:
            return vm_stat.active_count * page_size;
        case CHUIDeviceCurrentMemoryInfoInactive:
            return vm_stat.inactive_count * page_size;
        case CHUIDeviceCurrentMemoryInfoWired:
            return vm_stat.wire_count * page_size;
        case CHUIDeviceCurrentMemoryInfoPurgeable:
            return vm_stat.purgeable_count * page_size;
            
        default:
            break;
    }
}

- (int64_t)ch_memoryUsed {
    return ch_current_memory_info_get_by_type(CHUIDeviceCurrentMemoryInfoUsed);
}

- (int64_t)ch_memoryFree {
    return ch_current_memory_info_get_by_type(CHUIDeviceCurrentMemoryInfoFree);
}

- (int64_t)ch_memoryActive {
    return ch_current_memory_info_get_by_type(CHUIDeviceCurrentMemoryInfoActive);
}

- (int64_t)ch_memoryInactive {
    return ch_current_memory_info_get_by_type(CHUIDeviceCurrentMemoryInfoInactive);
}

- (int64_t)ch_memoryWired {
    return ch_current_memory_info_get_by_type(CHUIDeviceCurrentMemoryInfoWired);
}

- (int64_t)ch_memoryPurgeable {
    return ch_current_memory_info_get_by_type(CHUIDeviceCurrentMemoryInfoPurgeable);
}

#pragma mark - Network Info
- (NSString *)_ch_ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs; // 结构体指针
        while (addr) {
            // -> 指向结构体中含有子数据的指针, 用来取子数据
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family)
                {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str)); // inet_ntoa():将网络地址转换成“.”点隔的字符串格式
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        break;
                    case AF_INET6:
                    { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        break;
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

- (NSString *)ch_ipAddressWIFI {
    return [self _ch_ipAddressWithIfaName:@"en0"]; // WiFi接入时网卡为en0
}

- (NSString *)ch_ipAddressCell {
    return [self _ch_ipAddressWithIfaName:@"pdp_ip0"]; // // 2G/3G/4G接入时网卡为pdp_ip0
}

- (NSString *)ch_macAddress {
    int                 _mib[6];
    size_t              _length;
    char                *buffer;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    _mib[0] = CTL_NET;
    _mib[1] = AF_ROUTE;
    _mib[2] = 0;
    _mib[3] = AF_LINK;
    _mib[4] = NET_RT_IFLIST;
    
    if((_mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if(sysctl(_mib, 6, NULL, &_length, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if((buffer = malloc(_length)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if(sysctl(_mib, 6, buffer, &_length, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buffer;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *address = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                         *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buffer);
    
    return address;
}

typedef struct {
    uint64_t en_in;     // WIFI
    uint64_t en_out;
    uint64_t pdp_ip_in; // WWAN
    uint64_t pdp_ip_out;
    uint64_t awdl_in;   // AWDL
    uint64_t awdl_out;
} ch_net_interface_counter;

static uint64_t ch_net_counter_add(uint64_t counter, uint64_t bytes) {
    // 进位转换 0xFFFFFFFF = -1
    if (bytes < (counter % 0xFFFFFFFF)) {
        counter += 0xFFFFFFFF - (counter % 0xFFFFFFFF);
        counter += bytes;
    } else {
        counter = bytes;
    }
    return counter;
}

static uint64_t ch_net_counter_get_by_type(ch_net_interface_counter *counter, CHUIDeviceNetworkTrafficType type) {
    uint64_t bytes = 0;
    if (type & CHUIDeviceNetworkTrafficTypeWWANSent) bytes += counter->pdp_ip_out;
    if (type & CHUIDeviceNetworkTrafficTypeWWANReceived) bytes += counter->pdp_ip_in;
    if (type & CHUIDeviceNetworkTrafficTypeWIFISent) bytes += counter->en_out;
    if (type & CHUIDeviceNetworkTrafficTypeWIFIReceived) bytes += counter->en_in;
    if (type & CHUIDeviceNetworkTrafficTypeAWDLSent) bytes += counter->awdl_out;
    if (type & CHUIDeviceNetworkTrafficTypeAWDLReceived) bytes += counter->awdl_in;
    return bytes;
}

static ch_net_interface_counter ch_get_net_interface_counter() {
    static dispatch_semaphore_t lock; // 信号量
    static NSMutableDictionary *sharedInCounters;
    static NSMutableDictionary *sharedOutCounters;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInCounters = [NSMutableDictionary new];
        sharedOutCounters = [NSMutableDictionary new];
        lock = dispatch_semaphore_create(1);
    });
    
    ch_net_interface_counter counter = {0};
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    // 获取本地网络接口信息
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER); // 等待
        while (cursor) {
            //  Link layer interface(连接层接口)
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                const struct if_data *data = cursor->ifa_data; // ifa_data 存储该接口协议族的特殊信息
                NSString *name = cursor->ifa_name ? [NSString stringWithUTF8String:cursor->ifa_name] : nil; // fa_name 是接口名称，以0结尾的字符串，比如eth0，lo
                if (name) {
                    uint64_t counter_in = ((NSNumber *)sharedInCounters[name]).unsignedLongLongValue;
                    counter_in = ch_net_counter_add(counter_in, data->ifi_ibytes); // ifi_ibytes total number of octets received
                    sharedInCounters[name] = @(counter_in);
                    
                    uint64_t counter_out = ((NSNumber *)sharedOutCounters[name]).unsignedLongLongValue;
                    counter_out = ch_net_counter_add(counter_out, data->ifi_obytes);
                    sharedOutCounters[name] = @(counter_out);
                    
                    if ([name hasPrefix:@"en"]) { // WIFI
                        counter.en_in += counter_in;
                        counter.en_out += counter_out;
                    } else if ([name hasPrefix:@"awdl"]) { // AWDL
                        counter.awdl_in += counter_in;
                        counter.awdl_out += counter_out;
                    } else if ([name hasPrefix:@"pdp_ip"]) { // WWAN
                        counter.pdp_ip_in += counter_in;
                        counter.pdp_ip_out += counter_out;
                    }
                }
            }
            cursor = cursor->ifa_next;
        }
        dispatch_semaphore_signal(lock); // 释放
        freeifaddrs(addrs);
    }
    
    return counter;
}

- (uint64_t)ch_getNetworkTrafficBytes:(CHUIDeviceNetworkTrafficType)types {
    ch_net_interface_counter counter = ch_get_net_interface_counter();
    return ch_net_counter_get_by_type(&counter, types);
}

#pragma mark - SIM Info
- (NSString *)ch_SIMCarrierName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    return info.subscriberCellularProvider.carrierName;
}

@end
