//
//  UIDevice+CHMachineInfo.m
//  CHCategories
//
//  Created by CHwang on 2019/1/30.
//

#import "UIDevice+CHMachineInfo.h"
#import "CHCoreGraphicHelper.h"
#import "NSString+CHBase.h"
#import "UIDevice+CHBase.h"
#import "UIScreen+CHBase.h"

@implementation UIDevice (CHMachineInfo)

#pragma mark - Check
- (BOOL)ch_isPhone {
    static dispatch_once_t one;
    static BOOL phone;
    dispatch_once(&one, ^{
        phone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIDevice currentDevice].ch_canMakePhoneCalls;
    });
    return phone;
}

- (BOOL)ch_isPod {
    static dispatch_once_t one;
    static BOOL pod;
    dispatch_once(&one, ^{
        pod = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && ![UIDevice currentDevice].ch_canMakePhoneCalls && ![UIDevice currentDevice].ch_isSimulator;
    });
    return pod;
}

- (BOOL)ch_isPad {
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

- (BOOL)ch_isSimulator {
    static dispatch_once_t one;
    static BOOL simulator = NO;
    dispatch_once(&one, ^{
        NSString *model = [self ch_machineModel];
        if ([model isEqualToString:@"x86_64"] || [model isEqualToString:@"i386"]) {
            simulator = YES;
        }
    });
    return simulator;
}

- (BOOL)ch_isJailbroken {
    if ([self ch_isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString ch_stringWithUUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}

- (BOOL)ch_isTV {
    static dispatch_once_t one;
    static BOOL TV;
    dispatch_once(&one, ^{
        TV = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV;
    });
    return TV;
}

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED // 仅在iOS下
- (BOOL)ch_canMakePhoneCalls {
    static dispatch_once_t onceToken;
    static BOOL can = NO;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}
#endif

#pragma mark - Machine Model Info
#define CHDeviceIsMachineModelInSet( _objs... ) \
if (!self.ch_machineModel) return NO; \
static BOOL isConstained = NO; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
id objs[] = { _objs }; \
NSUInteger count = sizeof(objs) / sizeof(id); \
if (count > 1) { \
NSSet *set = [NSSet setWithObjects: objs count: count]; \
isConstained = [set containsObject:self.ch_machineModel]; \
} else { \
isConstained = [self.ch_machineModel isEqualToString:objs[0]]; \
} \
}); \
return isConstained; \

- (BOOL)ch_isiPhone4 {
    /*
     https://www.theiphonewiki.com
     */
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint320X480);

    CHDeviceIsMachineModelInSet(@"iPhone3,1", @"iPhone3,2", @"iPhone3,3");
}

- (BOOL)ch_isiPhone4s {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint320X480);
    
    CHDeviceIsMachineModelInSet(@"iPhone4,1");
}

- (BOOL)ch_isiPhone5 {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint320X568);
    
    CHDeviceIsMachineModelInSet(@"iPhone5,1", @"iPhone5,2");
}

- (BOOL)ch_isiPhone5c {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint320X568);
    
    CHDeviceIsMachineModelInSet(@"iPhone5,3", @"iPhone5,4");
}

- (BOOL)ch_isiPhone5s {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint320X568);
    
    CHDeviceIsMachineModelInSet(@"iPhone6,1", @"iPhone6,2");
}

- (BOOL)ch_isiPhone6 {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint375X667);
    
    CHDeviceIsMachineModelInSet(@"iPhone7,2");
}

- (BOOL)ch_isiPhone6Plus {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint414X736);
    
    CHDeviceIsMachineModelInSet(@"iPhone7,1");
}

- (BOOL)ch_isiPhone6s {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint375X667);
    
    CHDeviceIsMachineModelInSet(@"iPhone8,1");
}

- (BOOL)ch_isiPhone6sPlus {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint414X736);
    
    CHDeviceIsMachineModelInSet(@"iPhone8,2");
}

- (BOOL)ch_isiPhoneSE {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint320X568);
    
    CHDeviceIsMachineModelInSet(@"iPhone8,4");
}

- (BOOL)ch_isiPhone7 {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint375X667);
    
    CHDeviceIsMachineModelInSet(@"iPhone9,1", @"iPhone9,3");
}

- (BOOL)ch_isiPhone7Plus {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint414X736);
    
    CHDeviceIsMachineModelInSet(@"iPhone9,2", @"iPhone9,4");
}

- (BOOL)ch_isiPhone8 {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint375X667);
    
    CHDeviceIsMachineModelInSet(@"iPhone10,1", @"iPhone10,4");
}

- (BOOL)ch_isiPhone8Plus {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint414X736);
    
    CHDeviceIsMachineModelInSet(@"iPhone10,2", @"iPhone10,5");
}

- (BOOL)ch_isiPhoneX {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint375X812);
    
    CHDeviceIsMachineModelInSet(@"iPhone10,3", @"iPhone10,6");
}

- (BOOL)ch_isiPhoneXR {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint414X896);
    
    CHDeviceIsMachineModelInSet(@"iPhone11,8");
}

- (BOOL)ch_isiPhoneXS {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint375X812);
    
    CHDeviceIsMachineModelInSet(@"iPhone11,2");
}

- (BOOL)ch_isiPhoneXSMax {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint414X896);
    
    CHDeviceIsMachineModelInSet(@"iPhone11,4", @"iPhone11,6");
}

- (BOOL)ch_isiPhone11 {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint414X896);
    
    CHDeviceIsMachineModelInSet(@"iPhone12,1");
}

- (BOOL)ch_isiPhone11Pro {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint375X812);
    
    CHDeviceIsMachineModelInSet(@"iPhone12,3");
}

- (BOOL)ch_isiPhone11ProMax {
    if ([UIDevice currentDevice].ch_isSimulator) return CGSizeEqualToSize(CHScreenSize(), CHUIScreenSizeInPoint414X896);
    
    CHDeviceIsMachineModelInSet(@"iPhone12,5");
}

#undef CHDeviceIsMachineModelInSet

#pragma mark - Operation System Info
- (BOOL)ch_isiOS6Later {
    return [UIDevice ch_systemVersion] >= 6;
}

- (BOOL)ch_isiOS7Later {
    return [UIDevice ch_systemVersion] >= 7;
}

- (BOOL)ch_isiOS8Later {
    return [UIDevice ch_systemVersion] >= 8;
}

- (BOOL)ch_isiOS9Later {
    return [UIDevice ch_systemVersion] >= 9;
}

- (BOOL)ch_isiOS10Later {
    return [UIDevice ch_systemVersion] >= 10;
}

- (BOOL)ch_isiOS11Later {
    return [UIDevice ch_systemVersion] >= 11;
}

- (BOOL)ch_isiOS12Later {
    return [UIDevice ch_systemVersion] >= 12;
}

- (BOOL)ch_isiOS13Later {
    return [UIDevice ch_systemVersion] >= 13;
}

@end
