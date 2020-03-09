//
//  UITabBarItem+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2019/2/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (CHBase)

#pragma mark - Base
/**
 获取UITabBarItem的图标界面(无返回nil)

 @return UITabBarItem的图标界面(无返回nil)
 */
- (nullable UIImageView *)ch_imageView;

@end

NS_ASSUME_NONNULL_END
