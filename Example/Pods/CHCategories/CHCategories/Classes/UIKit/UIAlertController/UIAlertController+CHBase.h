//
//  UIAlertController+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2019/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (CHBase)

#pragma mark - Base
@property (nullable, nonatomic, strong) UIImage *ch_image;      ///< 图片
@property (nullable, nonatomic, strong) UIColor *ch_titleColor; ///< 标题颜色

@end


@interface UIAlertController (CHBase)

#pragma mark - Base
@property (nullable, nonatomic, strong) NSAttributedString *ch_attributedTitle; ///< Attributed标题
@property (nullable, nonatomic, strong) NSAttributedString *ch_attributedMessage; ///< Attributed消息
@property (nullable, nonatomic, strong) UIViewController *ch_contentViewController; ///< 内容Controller

/**
 根据标题、字体、字体颜色, 设置标题

 @param title 标题
 @param font 字体
 @param textColor 字体颜色
 */
- (void)ch_setTitle:(nullable NSString *)title
               font:(nullable UIFont *)font
          textColor:(nullable UIColor *)textColor;

/**
 根据消息、字体、字体颜色, 设置消息

 @param message 消息
 @param font 字体
 @param textColor 字体颜色
 */
- (void)ch_setMessage:(nullable NSString *)message
                 font:(nullable UIFont *)font
            textColor:(nullable UIColor *)textColor;

/**
 根据内容Controller、内容显示尺寸, 设置自定义内容

 @param contentViewController 内容Controller
 @param contentSize 内容显示尺寸
 */
- (void)ch_setContentViewController:(UIViewController *)contentViewController contentSize:(CGSize)contentSize;

/**
 根据标题、消息、sourceView、显示风格, 创建UIAlertController对象

 @param title 标题
 @param message 消息
 @param sourceView sourceView
 @param preferredStyle 显示风格
 @return UIAlertController对象
 */
+ (instancetype)ch_alertControllerWithTitle:(nullable NSString *)title
                                    message:(nullable NSString *)message
                                 sourceView:(nullable UIView *)sourceView
                             preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 根据标题、消息、sourceItem、显示风格, 创建UIAlertController对象

 @param title 标题
 @param message 消息
 @param sourceItem sourceItem
 @param preferredStyle 显示风格
 @return UIAlertController对象
 */
+ (instancetype)ch_alertControllerWithTitle:(nullable NSString *)title
                                    message:(nullable NSString *)message
                                 sourceItem:(nullable UIBarButtonItem *)sourceItem
                             preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 根据标题、消息, 创建UIAlertController对象(UIAlertControllerStyleAlert样式)

 @param title 标题
 @param message 消息
 @return UIAlertController对象(UIAlertControllerStyleAlert样式)
 */
+ (instancetype)ch_alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

/**
 根据标题、消息、sourceView, 创建UIAlertController对象(UIAlertControllerStyleActionSheet样式)

 @param title 标题
 @param message 消息
 @param sourceView sourceView
 @return UIAlertController对象(UIAlertControllerStyleActionSheet样式)
 */
+ (instancetype)ch_actionSheetControllerWithTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                       sourceView:(nullable UIView *)sourceView;

/**
 根据标题、消息、sourceItem, 创建UIAlertController对象(UIAlertControllerStyleActionSheet样式)

 @param title 标题
 @param message 消息
 @param sourceItem sourceItem
 @return UIAlertController对象(UIAlertControllerStyleActionSheet样式)
 */
+ (instancetype)ch_actionSheetControllerWithTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                       sourceItem:(nullable UIBarButtonItem *)sourceItem;

/**
 根据Action标题、标题颜色、风格、回调处理, 添加UIAlertAction对象

 @param title 标题
 @param titleColor 标题颜色
 @param style 风格
 @param handler 回调处理
 */
- (void)ch_addActionWithTitle:(nullable NSString *)title
                   titleColor:(nullable UIColor *)titleColor
                        style:(UIAlertActionStyle)style
                      handler:(void (^ __nullable)(UIAlertAction *action))handler;

/**
 根据Action标题、标题颜色、回调处理, 添加UIAlertAction对象(UIAlertActionStyleDefault样式)

 @param title 标题
 @param titleColor 标题颜色
 @param handler 回调处理
 */
- (void)ch_addDefaultActionWithTitle:(nullable NSString *)title
                          titleColor:(nullable UIColor *)titleColor
                             handler:(void (^ __nullable)(UIAlertAction *action))handler;

/**
根据Action标题、标题颜色、回调处理, 添加UIAlertAction对象(UIAlertActionStyleCancel样式)

 @param title 标题
 @param titleColor 标题颜色
 @param handler 回调处理
 */
- (void)ch_addCancelActionWithTitle:(nullable NSString *)title
                         titleColor:(nullable UIColor *)titleColor
                            handler:(void (^ __nullable)(UIAlertAction *action))handler;

/**
 根据Action标题、标题颜色、回调处理, 添加UIAlertAction对象(UIAlertActionStyleDestructive样式)

 @param title 标题
 @param titleColor 标题颜色
 @param handler 回调处理
 */
- (void)ch_addDestructiveActionWithTitle:(nullable NSString *)title
                              titleColor:(nullable UIColor *)titleColor
                                 handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
