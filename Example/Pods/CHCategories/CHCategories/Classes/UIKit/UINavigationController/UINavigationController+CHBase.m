//
//  UINavigationController+CHBase.m
//  Pods
//
//  Created by CHwang on 17/7/19.
//
//

#import "UINavigationController+CHBase.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"
#import "UIViewController+CHBase.h"

@implementation UINavigationController (CHBase)

#pragma mark - Base
+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray *selectors = @[
                [NSValue ch_valueWithSelector:@selector(initWithRootViewController:)],
                [NSValue ch_valueWithSelector:@selector(initWithNavigationBarClass:toolbarClass:)],
            ];
            CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix(self, selectors, @"_ch_ui_navigation_controller_");
        });
    }
}

- (void)ch_removeViewControllerFromClassName:(NSString *)className {
    [self ch_removeViewControllerFromClassName:className options:0];
}

- (void)ch_removeViewControllerFromClassName:(NSString *)className options:(NSEnumerationOptions)opts {
    if (!className || !className.length) return;
    
    Class class = NSClassFromString(className);
    [self ch_removeViewControllerFromClass:class options:opts];
}

- (void)ch_removeViewControllerFromClass:(Class)aClass  {
    [self ch_removeViewControllerFromClass:aClass options:0];
}

- (void)ch_removeViewControllerFromClass:(Class)aClass options:(NSEnumerationOptions)opts {
    if (!self.viewControllers || !self.viewControllers.count) return;
    if (![aClass isSubclassOfClass:[UIViewController class]]) return;
    
    __block NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    __block BOOL changed = NO;
    [self.viewControllers enumerateObjectsWithOptions:opts usingBlock:^(__kindof UIViewController * _Nonnull viewController, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([viewController isKindOfClass:[aClass class]]) {
            changed = YES;
            [viewControllers removeObject:viewController];
            *stop = YES;
        }
    }];
    
    if (!changed) return;
    self.viewControllers = viewControllers.copy;
}

- (void)ch_removeViewControllersFromClassNames:(NSSet<NSString *> *)classNames {
    if (!classNames || !classNames.count ) return;
    
    NSMutableSet *buffer = [NSMutableSet set];
    NSEnumerator *enumerator = [classNames objectEnumerator];
    for (NSString *className in enumerator) {
        Class aClass = NSClassFromString(className);
        [buffer addObject:aClass];
    }
    if (!buffer.count) return;
    
    [self ch_removeViewControllersFromClasses:buffer.copy];
}

- (void)ch_removeViewControllersFromClasses:(NSSet<Class> *)classes {
    if (!classes || !classes.count) return;
    
    NSMutableSet *buffer = [NSMutableSet set];
    NSEnumerator *enumerator = [classes objectEnumerator];
    for (Class aClass in enumerator) {
        if (![aClass isSubclassOfClass:[UIViewController class]]) continue;
        
        [buffer addObject:aClass];
    }
    if (!buffer.count) return;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    BOOL changed = NO;
    for (UIViewController *viewController in self.viewControllers) {
        if ([buffer containsObject:viewController.class]) {
            changed = YES;
            [viewControllers removeObject:viewController];
        }
    }
    
    if (!changed) return;
    self.viewControllers = viewControllers.copy;
}

#pragma mark - Pop
- (nullable NSArray<__kindof UIViewController *> *)ch_popToViewControllerFromClassName:(NSString *)className animated:(BOOL)animated {
    if (!className || !className.length) return nil;
    
    Class class = NSClassFromString(className);
    return [self ch_popToViewControllerFromClass:class animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)ch_popToViewControllerFromClass:(Class)aClass animated:(BOOL)animated {
    if (!self.viewControllers || !self.viewControllers.count) return nil;
    if (![aClass isSubclassOfClass:[UIViewController class]]) return nil;
    
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:[aClass class]]) {
            if (self.topViewController == viewController) continue;
            
            return [self popToViewController:viewController animated:animated];
        }
    }
    return nil;
}

#pragma mark - Swizzle
- (instancetype)_ch_ui_navigation_controller_initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    UINavigationController *viewController = [self _ch_ui_navigation_controller_initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    viewController.modalPresentationStyle = [UIViewController ch_preferredModalPresentationStyle];
    return viewController;
}

- (instancetype)_ch_ui_navigation_controller_initWithRootViewController:(UIViewController *)rootViewController {
    UINavigationController *viewController = [self _ch_ui_navigation_controller_initWithRootViewController:rootViewController];
    viewController.modalPresentationStyle = [UIViewController ch_preferredModalPresentationStyle];
    return viewController;
}

@end
