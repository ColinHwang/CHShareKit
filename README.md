# CHShareKit

## 中文介绍
CHShareKit是一个iOS平台的分享组件，支持微信、QQ第三方授权登录及分享功能。

## 安装
### 通过[CocoaPods](https://cocoapods.org)安装
该命令下默认支持全平台
```ruby
pod 'CHShareKit'
```
若只支持特定平台可使用如下命令安装子组件：
```ruby
pod 'CHShareKit/QQBridge'
pod 'CHShareKit/WXBridge'
```
## 使用方法
### 初始化
- 打开*AppDelegate.m(*代表你的工程名字)导入头文件
```objective-c
#import <CHShareKit/CHShareKit.h>
```
- 在`- (BOOL)application: didFinishLaunchingWithOptions:`方法中调用`registerActivePlatforms:configurationHandler:`方法来初始化SDK并且初始化第三方平台
```objective-c
 [CHSKShare registerActivePlatforms:@[@(CHSKPlatformTypeQQ), @(CHSKPlatformTypeWX)]
               configurationHandler:^CHSKPlatformConfiguration *(CHSKPlatformType platformType) {
     switch (platformType) {
         case CHSKPlatformTypeQQ:
         {
             return [CHSKPlatformConfiguration configurationForQQWithAppId:@"appId" appSecret:@"appSecret"];
         }
             break;
         case CHSKPlatformTypeWX:
         {
             return [CHSKPlatformConfiguration configurationForWXWithAppId:@"appId" appSecret:@"appSecret" universalLink:@"universalLink"];
         }
             break;
         default:
             return nil;
             break;
     }
 }];
 ```
 ### 分享
 - 构造分享参数
  ```objective-c
  // 创建文本分享类信息
  CHSKShareMessage *shareMessage = [CHSKShareMessage shareMessageWithTitle:@"title"];
  // 创建图片分享类信息
  CHSKShareMessage *shareMessage = [CHSKShareMessage shareMessageWithTitle:@"title" image:@"picture/pictureURL"];
  // 创建图片分享类信息
  CHSKShareMessage *shareMessage = [CHSKShareMessage shareMessageWithTitle:@"title" image:@"picture/pictureURL" thumbali:@"picture/pictureURL"];
  // 创建网页类分享信息
  CHSKShareMessage *shareMessage = [CHSKShareMessage shareMessageWithTitle:@"title" description:@"description" image:@"picture/pictureURL" url:[NSURL URLWithString:@"URLString"]];
 ```
 - 调用分享接口
```objective-c
   [CHSKShare shareTo:CHSKPlatformTypeWX message:shareMessage shareHandler:^(CHSKResponseState state, CHSKShareMessage *message, NSDictionary *extraData, NSError *error) {
       switch (state) {
           case CHSKResponseStateBegin:
           {
               // 开始分享
           }
               break;
           case CHSKResponseStateSuccess:
           {
               // 分享成功
           }
               break;
           case CHSKResponseStateFailure:
           {
               // 分享失败
           }
               break;
           case CHSKResponseStateFinish:
           {
               // 分享完成
           }
               break;
           case CHSKResponseStateCancel:
           {
               // 取消分享
           }
               break;
       }
   }];
```
- 处理被打开时的URL
```objective-c
/// iOS 9.0以上
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [CHSKShare handleOpenURL:url];
}

/// iOS 9.0以下
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [CHSKShare handleOpenURL:url];
}
```
### 授权
- 调用授权接口
```objective-c
[CHSKShare authorizeTo:CHSKPlatformTypeWX authorizeHandler:^(CHSKResponseState state, CHSKUser *user, NSDictionary *extraData, NSError *error) {
    switch (state) {
        case CHSKResponseStateBegin:
        {
            // 开始授权
        }
            break;
        case CHSKResponseStateSuccess:
        {
            // 授权成功
        }
            break;
        case CHSKResponseStateFailure:
        {
            // 授权失败
        }
            break;
        case CHSKResponseStateFinish:
        {
            // 授权完成
        }
            break;
        case CHSKResponseStateCancel:
        {
            // 取消授权
        }
            break;
    }
}];
```
- 处理被打开时的URL
```objective-c
/// iOS 9.0以上
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [CHSKShare handleOpenURL:url];
}

/// iOS 9.0以下
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [CHSKShare handleOpenURL:url];
}
```
## 平台配置
### URL Scheme配置
- info.plist -> Info -> URL Types

| 平台     | 配置URL Scheme 格式                                  | 举例                                                         |
| -------- | ---------------------------------------------------- | ------------------------------------------------------------ |
| 微信     | 微信的appid                                          | wx123456789                                           |
| QQ/Qzone | tencent+腾讯QQ开放平台appID，<br/>QQ+APPID的十六进制 | 如appID：123456789 最后配置：tencent123456789<br/>QQ75BCD15 |
### 配置白名单
- info.plist中添加key:LSApplicationQueriesSchemes，类型为Array，添加需要支持的项目，类型为字符串类型

| 平台  | OpenURL白名单说明                                            |
| ----- | ------------------------------------------------------------ |
| 微信  | wechat<br/>weixin                                            |
| QQ    | mqqOpensdkSSoLogin<br/>mqqopensdkapiV2<br/>mqqopensdkapiV3<br/>wtloginmqq2<br/>mqq<br/>mqqapi<br/>timapi<br/>mqqopensdkminiapp |
| QZone | mqzoneopensdk<br/>mqzoneopensdk<br/>apimqzoneopensdkapi19<br/>mqzoneopensdkapiV2<br/>mqqOpensdkSSoLogin<br/>mqqopensdkapiV2<br/>mqqopensdkapiV3<br/>wtloginmqq2<br/>mqqapi<br/>mqqwpa<br/>mqzone<br/>mqq<br/>mqqopensdkapiV4<br/>mqqopensdkminiapp |

- 在iOS9中，如果没有添加上述白名单，系统会打印类似如下提示:.-canOpenURL: failed for URL: “sinaweibohdsso://xxx” – error: “This app is not allowed to query for scheme sinaweibohdsso”，如没有添加相关白名单，有可能导致分享失败，例如不会跳转微信，不会跳转QQ等
- 添加完上述所需的名单,系统依然会打印类似信息：.-canOpenURL: failed for URL: “sinaweibohdsso://xxx” – error: “null”这是系统打印的信息，目前是无法阻止其打印，即无法消除的
## 作者
ColinHwang, chwang7158@gmail.com
## 协议
MIT
## 致谢
ShareSDK
