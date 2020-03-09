//
//  UIAlertController+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2019/8/8.
//

#import "UIAlertController+CHBase.h"
#import "UIDevice+CHMachineInfo.h"
#import "NSAttributedString+CHBase.h"

@implementation UIAlertAction (CHBase)

#pragma mark - Base
- (UIImage *)ch_image {
    return (UIImage *)[self valueForKey:@"image"];
}

- (void)setCh_image:(UIImage *)ch_image {
    [self setValue:ch_image forKey:@"image"];
}

- (UIColor *)ch_titleColor {
    return (UIColor *)[self valueForKey:@"titleTextColor"];
}

- (void)setCh_titleColor:(UIColor *)ch_titleColor {
    [self setValue:ch_titleColor forKey:@"titleTextColor"];
}

@end


@implementation UIAlertController (CHBase)

#pragma mark - Base
- (NSAttributedString *)ch_attributedTitle {
    return (NSAttributedString *)[self valueForKey:@"attributedTitle"];
}

- (void)setCh_attributedTitle:(NSAttributedString *)ch_attributedTitle {
    [self setValue:ch_attributedTitle forKey:@"attributedTitle"];
}

- (NSAttributedString *)ch_attributedMessage {
    return (NSAttributedString *)[self valueForKey:@"attributedMessage"];
}

- (void)setCh_attributedMessage:(NSAttributedString *)ch_attributedMessage {
    [self setValue:ch_attributedMessage forKey:@"attributedMessage"];
}

- (UIViewController *)ch_contentViewController {
    return (UIViewController *)[self valueForKey:@"contentViewController"];
}

- (void)setCh_contentViewController:(UIViewController *)ch_contentViewController {
    [self setValue:ch_contentViewController forKey:@"contentViewController"];
}

- (void)ch_setTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    if (font) {
        [attributedString ch_addFont:font];
    }
    if (textColor) {
        [attributedString ch_addForegroundColor:textColor];
    }
    [self setCh_attributedTitle:attributedString];
}

- (void)ch_setMessage:(NSString *)message font:(UIFont *)font textColor:(UIColor *)textColor {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
    if (font) {
        [attributedString ch_addFont:font];
    }
    if (textColor) {
        [attributedString ch_addForegroundColor:textColor];
    }
    [self setCh_attributedTitle:attributedString];
}

- (void)ch_setContentViewController:(UIViewController *)contentViewController contentSize:(CGSize)contentSize {
    contentViewController.preferredContentSize = contentSize;
    [self setCh_contentViewController:contentViewController];
}

+ (instancetype)ch_alertControllerWithTitle:(NSString *)title message:(NSString *)message sourceView:(UIView *)sourceView preferredStyle:(UIAlertControllerStyle)preferredStyle {
    UIAlertController *alertController = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (![UIDevice currentDevice].ch_isPad) return alertController;
    if (!sourceView) return alertController;
    
    alertController.popoverPresentationController.sourceView = sourceView;
    alertController.popoverPresentationController.sourceRect = sourceView.bounds;
    return alertController;
}

+ (instancetype)ch_alertControllerWithTitle:(NSString *)title message:(NSString *)message sourceItem:(UIBarButtonItem *)sourceItem preferredStyle:(UIAlertControllerStyle)preferredStyle {
    UIAlertController *alertController = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (![UIDevice currentDevice].ch_isPad) return alertController;
    if (!sourceItem) return alertController;
    
    alertController.popoverPresentationController.barButtonItem = sourceItem;
    return alertController;
}

+ (instancetype)ch_alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    return [self ch_alertControllerWithTitle:title message:message sourceView:nil preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)ch_actionSheetControllerWithTitle:(NSString *)title message:(NSString *)message sourceView:(UIView *)sourceView {
    return [self ch_alertControllerWithTitle:title message:message sourceView:sourceView preferredStyle:UIAlertControllerStyleActionSheet];
}

+ (instancetype)ch_actionSheetControllerWithTitle:(NSString *)title message:(NSString *)message sourceItem:(UIBarButtonItem *)sourceItem {
    return [self ch_alertControllerWithTitle:title message:message sourceItem:sourceItem preferredStyle:UIAlertControllerStyleActionSheet];
}

- (void)ch_addActionWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                        style:(UIAlertActionStyle)style
                      handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    if (titleColor) {
        action.ch_titleColor = titleColor;
    }
    [self addAction:action];
}

- (void)ch_addDefaultActionWithTitle:(NSString *)title
                          titleColor:(UIColor *)titleColor
                             handler:(void (^ __nullable)(UIAlertAction *action))handler {
    [self ch_addActionWithTitle:title titleColor:titleColor style:UIAlertActionStyleDefault handler:handler];
}

- (void)ch_addCancelActionWithTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                            handler:(void (^ __nullable)(UIAlertAction *action))handler {
    [self ch_addActionWithTitle:title titleColor:titleColor style:UIAlertActionStyleCancel handler:handler];
}

- (void)ch_addDestructiveActionWithTitle:(NSString *)title
                              titleColor:(UIColor *)titleColor
                                 handler:(void (^ __nullable)(UIAlertAction *action))handler {
    [self ch_addActionWithTitle:title titleColor:titleColor style:UIAlertActionStyleDestructive handler:handler];
}

@end
