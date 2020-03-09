//
//  UIBarButtonItem+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UIBarButtonItem+CHBase.h"
#import "NSObject+CHBase.h"
#import "UIControl+CHBase.h"
#import "UIGestureRecognizer+CHBase.h"
#import "UIView+CHBase.h"

static const int CH_UI_BAR_BUTTON_ITEM_BLOCK_KEY;

@interface CHUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation CHUIBarButtonItemBlockTarget

- (id)initWithBlock:(void (^)(id sender))block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    !self.block?:self.block(sender);
}

@end


@implementation UIBarButtonItem (CHBase)

#pragma mark - Base
- (void)_ch_setActionBlock:(void (^)(id sender))block {
    CHUIBarButtonItemBlockTarget *target = [[CHUIBarButtonItemBlockTarget alloc] initWithBlock:block];
    [self ch_setAssociatedValue:target withKey:&CH_UI_BAR_BUTTON_ITEM_BLOCK_KEY];
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id sender))_ch_actionBlock {
    CHUIBarButtonItemBlockTarget *target = [self ch_getAssociatedValueForKey:&CH_UI_BAR_BUTTON_ITEM_BLOCK_KEY];
    return target.block;
}

+ (UIBarButtonItem *)ch_barButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithImage:image style:style target:target action:action];
}

+ (UIBarButtonItem *)ch_barButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id sender))actionBlock {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:style target:nil action:NULL];
    !actionBlock?:[barButtonItem _ch_setActionBlock:actionBlock];
    return barButtonItem;
}

+ (UIBarButtonItem *)ch_barButtonItemWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:target action:action];
}

+ (UIBarButtonItem *)ch_barButtonItemWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id sender))actionBlock {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:nil action:NULL];
    !actionBlock?:[barButtonItem _ch_setActionBlock:actionBlock];
    return barButtonItem;
}

+ (UIBarButtonItem *)ch_barButtonItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.opaque = YES;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    button.ch_size = button.currentImage.size; // 避免图片拉伸
    
    return [UIBarButtonItem ch_barButtonItemWithCustomView:button target:target action:action];;
}

+ (UIBarButtonItem *)ch_barButtonItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage actionBlock:(void (^)(id sender))actionBlock {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.opaque = YES;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    button.ch_size = button.currentImage.size; // 避免图片拉伸
    
    return [UIBarButtonItem ch_barButtonItemWithCustomView:button actionBlock:actionBlock];
}

+ (UIBarButtonItem *)ch_barButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
}

+ (UIBarButtonItem *)ch_barButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id sender))actionBlock {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:style target:nil action:NULL];
    !actionBlock?:[barButtonItem _ch_setActionBlock:actionBlock];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)ch_barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
}

+ (UIBarButtonItem *)ch_barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem actionBlock:(void (^)(id sender))actionBlock {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:nil action:NULL];
    !actionBlock?:[barButtonItem _ch_setActionBlock:actionBlock];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)ch_barButtonItemWithCustomView:(UIView *)customView target:(id)target action:(SEL)action {
    if (!customView) return nil;
    
    if ([customView isKindOfClass:[UIControl class]]) {
        [(UIControl *)customView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    } else {
        [customView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}

+ (UIBarButtonItem *)ch_barButtonItemWithCustomView:(UIView *)customView actionBlock:(void (^)(id sender))actionBlock {
    if (!customView) return nil;
    
    if ([customView isKindOfClass:[UIControl class]]) {
        [(UIControl *)customView ch_setBlockForTouchUpInsideControlEvent:actionBlock];
    } else {
        [customView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:actionBlock]];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}

@end
