//
//  UIBarItem+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2019/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarItem (CHBase)

#pragma mark - Base
/**
 获取UIBarItem/UIBarButtonItem/UITabBarItem内部的View
 Navigation设置navigationItem后且在navigationBar可见时[如, `viewDidAppear:`之后], 才可获取.
 navigationItem:
    iOS11以前 -> UINavigationButton
    iOS11以后 -> _UIButtonBarButton
 toolbarItem:
    iOS11以前 -> UIToolbarButton
    iOS11以后 -> _UIButtonBarButton;
 tabBarItem:
    -> UITabBarButton
 */
@property (nullable, nonatomic, weak, readonly) UIView *ch_view;

@end

NS_ASSUME_NONNULL_END
