//
//  UIApplication+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/9.
//  
//

#import "UIApplication+CHBase.h"
#import <mach/mach.h>
#import "NSArray+CHBase.h"
#import "NSObject+CHBase.h"
#import "NSString+CHBase.h"
#import <sys/sysctl.h>
#import "UIDevice+CHMachineInfo.h"
#import "UIScreen+CHBase.h"

#define CHUIApplicationNetworkIndicatorDelay (1/30.0)

@interface CHUIApplicationNetworkIndicatorInfo : NSObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CHUIApplicationNetworkIndicatorInfo
@end


@implementation UIApplication (CHBase)

#pragma mark - Base
- (NSString *)ch_appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)ch_appBundleDisplayName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSString *)ch_appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)ch_appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)ch_appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSURL *)ch_documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)ch_documentsPath {
    return CHNSDocumentsDirectory();
}

- (NSURL *)ch_cachesURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)ch_cachesPath {
    return CHNSCachesDirectory();
}

- (NSURL *)ch_libraryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)ch_libraryPath {
    return CHNSLibraryDirectory();
}

- (NSURL *)ch_temporaryURL {
    return [NSURL fileURLWithPath:CHNSTemporaryDirectory() isDirectory:YES];
}

- (NSString *)ch_temporaryPath {
    return CHNSTemporaryDirectory();
}

- (CGFloat)ch_statusBarHeight {
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    return MIN(statusBarSize.height, statusBarSize.width);
}

- (CGFloat)ch_statusBarWidth {
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    return MAX(statusBarSize.height, statusBarSize.width);
}

- (UIEdgeInsets)ch_safeAreaInsets {
    UIWindow *window = [[self windows] ch_objectOrNilAtIndex:0];
    if (!window) return UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        return window.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

#pragma mark - Check
- (BOOL)_ch_isFileExistInMainBundle:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)ch_isPirated {
    if ([[UIDevice currentDevice] ch_isSimulator]) return YES; // Simulator is not from appstore
    
    if (getgid() <= 10) return YES; // 目前进程的组识别码 process ID shouldn't be root
    // 破解版包含标签
    if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"SignerIdentity"]) return YES;
    // 签名信息
    if (![self _ch_isFileExistInMainBundle:@"_CodeSignature"]) return YES;
    
    if (![self _ch_isFileExistInMainBundle:@"SC_Info"]) return YES;
    
    //if someone really want to crack your app, this method is useless..
    //you may change this method's name, encrypt the code and do more check..
    return NO;
}

- (BOOL)ch_isBeingDebugged {
    size_t size = sizeof(struct kinfo_proc);
    struct kinfo_proc info;
    int ret = 0, name[4];
    memset(&info, 0, sizeof(struct kinfo_proc));
    
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    
    if (ret == (sysctl(name, 4, &info, &size, NULL, 0))) {
        return ret != 0;
    }
    return (info.kp_proc.p_flag & P_TRACED) ? YES : NO;
}

#pragma mark - Top View Controller
- (UIViewController *)ch_topViewController {
    __block UIWindow *normalWindow = [self.delegate window];
    if (normalWindow.windowLevel != UIWindowLevelNormal) {
        [self.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.windowLevel == UIWindowLevelNormal) {
                normalWindow = obj;
                *stop = YES;
            }
        }];
    }
    return [self _ch_nextTopForViewController:normalWindow.rootViewController];
}

- (UIViewController *)_ch_nextTopForViewController:(UIViewController *)inViewController {
    while (inViewController.presentedViewController) {
        inViewController = inViewController.presentedViewController;
    }
    
    if ([inViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedViewController = [self _ch_nextTopForViewController:((UITabBarController *)inViewController).selectedViewController];
        return selectedViewController;
    } else if ([inViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *selectedViewController = [self _ch_nextTopForViewController:((UINavigationController *)inViewController).visibleViewController];
        return selectedViewController;
    } else {
        return inViewController;
    }
}

#pragma mark - Network Activity Indicator
- (void)_ch_setNetworkActivityInfo:(CHUIApplicationNetworkIndicatorInfo *)info {
    [self willChangeValueForKey:NSStringFromSelector(@selector(_ch_networkActivityInfo))];
    [self ch_setAssociatedValue:info withKey:_cmd];
    [self didChangeValueForKey:NSStringFromSelector(@selector(_ch_networkActivityInfo))];
}

- (CHUIApplicationNetworkIndicatorInfo *)_ch_networkActivityInfo {
    return [self ch_getAssociatedValueForKey:@selector(_ch_setNetworkActivityInfo:)];
}

- (void)_ch_delaySetActivity:(NSTimer *)timer {
    NSNumber *visiable = timer.userInfo;
    if (self.networkActivityIndicatorVisible != visiable.boolValue) {
        [self setNetworkActivityIndicatorVisible:visiable.boolValue];
    }
    [timer invalidate];
}

- (void)_ch_changeNetworkActivityCount:(NSInteger)delta {
    @synchronized(self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CHUIApplicationNetworkIndicatorInfo *info = [self _ch_networkActivityInfo];
            if (!info) {
                info = [CHUIApplicationNetworkIndicatorInfo new];
                [self _ch_setNetworkActivityInfo:info];
            }
            NSInteger count = info.count;
            count += delta;
            info.count = count;
            [info.timer invalidate];
            info.timer = [NSTimer timerWithTimeInterval:CHUIApplicationNetworkIndicatorDelay target:self selector:@selector(_ch_delaySetActivity:) userInfo:@(info.count > 0) repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:info.timer forMode:NSRunLoopCommonModes];
        });
    }
}

- (void)ch_incrementNetworkActivityCount {
    [self _ch_changeNetworkActivityCount:1];
}

- (void)ch_decrementNetworkActivityCount {
    [self _ch_changeNetworkActivityCount:-1];
}

#pragma mark - Lanuch Image
- (UIImage *)ch_appLanuchImage {
    return [self ch_appLanuchImageForOrientation:self.statusBarOrientation];
}

- (UIImage *)ch_appLanuchImageForOrientation:(UIInterfaceOrientation)orientation {
    NSString *orientationType = nil;
    switch (orientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            orientationType = @"Portrait";
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            orientationType = @"Landscape";
        }
            break;
    }
    
    NSString *lanuchImageName = nil;
    NSArray *imageDatas = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    CGSize screenSize = [[UIScreen mainScreen] ch_boundsForOrientation:orientation].size;
    for (NSDictionary *imageData in imageDatas) {
        NSString *aOrientationType = [imageData objectForKey:@"UILaunchImageOrientation"];
        if (![orientationType isEqualToString:aOrientationType]) continue;
        
        CGSize imageSize = CGSizeFromString([imageData objectForKey:@"UILaunchImageSize"]);
        if (!CGSizeEqualToSize(screenSize, imageSize)) continue;
        
        lanuchImageName = [imageData objectForKey:@"UILaunchImageName"];
    }
    if (!lanuchImageName.length) return nil;
    
    return [UIImage imageNamed:lanuchImageName];
}

@end
