//
//  UIViewController+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2020/3/7.
//

#import "UIViewController+CHBase.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
static UIModalPresentationStyle CH_UI_VIEW_CONTROLLER_PREFERRED_MODAL_PRESENTATION_STYLE = UIModalPresentationAutomatic;
#pragma clang diagnostic pop

@implementation UIViewController (CHBase)

#pragma mark - Base
+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray *selectors = @[
                [NSValue ch_valueWithSelector:@selector(init)],
                [NSValue ch_valueWithSelector:@selector(initWithCoder:)],
                [NSValue ch_valueWithSelector:@selector(initWithNibName:bundle:)],
            ];
            CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix(self, selectors, @"_ch_ui_view_controller_");
        });
    }
}

+ (void)ch_setupPreferredModalPresentationStyle:(UIModalPresentationStyle)style {
    CH_UI_VIEW_CONTROLLER_PREFERRED_MODAL_PRESENTATION_STYLE = style;
}

+ (UIModalPresentationStyle)ch_preferredModalPresentationStyle {
    return CH_UI_VIEW_CONTROLLER_PREFERRED_MODAL_PRESENTATION_STYLE;
}

#pragma mark - Swizzle
- (instancetype)_ch_ui_view_controller_init {
    UIViewController *viewController = [self _ch_ui_view_controller_init];
    [self _ch_ui_view_controller_configurePreferredModalPresentationStyle:viewController];
    return viewController;
}

- (instancetype)_ch_ui_view_controller_initWithCoder:(NSCoder *)coder {
    UIViewController *viewController = [self _ch_ui_view_controller_initWithCoder:coder];
    [self _ch_ui_view_controller_configurePreferredModalPresentationStyle:viewController];
    return viewController;
}

- (instancetype)_ch_ui_view_controller_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    UIViewController *viewController = [self _ch_ui_view_controller_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self _ch_ui_view_controller_configurePreferredModalPresentationStyle:viewController];
    return viewController;
}

- (void)_ch_ui_view_controller_configurePreferredModalPresentationStyle:(UIViewController *)viewController {
    if (@available(iOS 13.0, *)) {
        UIModalPresentationStyle preferredModalPresentationStyle = [UIViewController ch_preferredModalPresentationStyle];
        if (viewController.modalPresentationStyle != preferredModalPresentationStyle) {
            viewController.modalPresentationStyle = preferredModalPresentationStyle;
        }
    }
}

@end
