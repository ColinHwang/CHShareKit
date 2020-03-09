//
//  UIApplication+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/9.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (CHBase)

#pragma mark - Base
@property (nonatomic, readonly) NSString *ch_appBundleName;        ///< 获取应用的包名(展示在iDevice<SpringBoard>中)
@property (nonatomic, readonly) NSString *ch_appBundleDisplayName; ///< 获取应用的本地化包名
@property (nonatomic, readonly) NSString *ch_appBundleID;          ///< 获取应用的Bundle ID(com.xxx.yyy)
@property (nonatomic, readonly) NSString *ch_appVersion;           ///< 获取应用的版本(1.2.0)
@property (nonatomic, readonly) NSString *ch_appBuildVersion;      ///< 获取应用的构建版本(123)

@property (nonatomic, readonly) NSURL *ch_documentsURL;       ///< 获取应用沙盒内Documents文件夹的URL
@property (nonatomic, readonly) NSString *ch_documentsPath;   ///< 获取应用沙盒内Documents文件夹的路径
@property (nonatomic, readonly) NSURL *ch_cachesURL;          ///< 获取应用沙盒内Caches文件夹的URL
@property (nonatomic, readonly) NSString *ch_cachesPath;      ///< 获取应用沙盒内Caches文件夹的路径
@property (nonatomic, readonly) NSURL *ch_libraryURL;         ///< 获取应用沙盒内Library文件夹的URL
@property (nonatomic, readonly) NSString *ch_libraryPath;     ///< 获取应用沙盒内Library文件夹的路径
@property (nonatomic, readonly) NSURL *ch_temporaryURL;       ///< 获取应用沙盒内Tmp文件夹的URL
@property (nonatomic, readonly) NSString *ch_temporaryPath;   ///< 获取应用沙盒内Tmp文件夹的路径

@property (nonatomic, readonly) CGFloat ch_statusBarHeight;     ///< 获取当前应用状态栏的高度, 状态栏隐藏时高度为0
@property (nonatomic, readonly) CGFloat ch_statusBarWidth;      ///< 获取当前应用状态栏的宽度, 状态栏隐藏时宽度为0
@property (nonatomic, readonly) UIEdgeInsets ch_safeAreaInsets; ///< 获取当前应用的SafeAreaInsets

#pragma mark - Check
@property (nonatomic, readonly) BOOL ch_isPirated;       ///< 应用是否为盗版(非通过AppStore安装, 包被破解, 简单判断)
@property (nonatomic, readonly) BOOL ch_isBeingDebugged; ///< 应用是否在调试模式运行

#pragma mark - Top View Controller
/**
 获取当前应用顶层的ViewController
 */
@property (nonatomic, readonly) UIViewController *ch_topViewController;

#pragma mark - Network Activity Indicator
/**
 增加活跃的网络请求数(若增加前为0, 将开启状态栏网络请求提示器动画. 该方法为线程安全, 应用扩展中无效)
 */
- (void)ch_incrementNetworkActivityCount;

/**
 减少活跃的网络请求数(若减少后为0, 将关闭状态栏网络请求提示器动画. 该方法为线程安全, 应用扩展中无效)
 */
- (void)ch_decrementNetworkActivityCount;

#pragma mark - Lanuch Image
/**
获取当前设备方向对应的启动图片(或为nil)
*/
@property (nonatomic, readonly, nullable) UIImage *ch_appLanuchImage;

/**
 根据设备方向, 获取对应的启动图片(或为nil)

 @param orientation 设备方向
 @return 对应的启动图片, 无则返回nil
 */
- (nullable UIImage *)ch_appLanuchImageForOrientation:(UIInterfaceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
