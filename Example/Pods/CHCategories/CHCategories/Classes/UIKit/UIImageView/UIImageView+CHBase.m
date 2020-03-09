//
//  UIImageView+CHBase.m
//  CHCategories
//
//  Created by Chwang on 2019/7/9.
//

#import "UIImageView+CHBase.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"

static const int CH_UI_IMAGE_VIEW_SCALE_INTRINSIC_CONTENT_SIZE_ENABLED_KEY;
static const int CH_UI_IMAGE_VIEW_PREFERRED_SCALE_INTRINSIC_CONTENT_HEIGHT_KEY;
static const int CH_UI_IMAGE_VIEW_PREFERRED_SCALE_INTRINSIC_CONTENT_WIDTH_KEY;

@implementation UIImageView (CHBase)

#pragma mark - Base
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selectors = @[
            [NSValue ch_valueWithSelector:@selector(intrinsicContentSize)],
        ];
        CHNSObjectSwizzleInstanceMethodsWithNewMethodPrefix(self, selectors, @"_ch_ui_image_view_");
    });
}

- (void)setCh_scaleIntrinsicContentSizeEnabled:(BOOL)ch_scaleIntrinsicContentSizeEnabled {
    [self ch_setAssociatedValue:@(ch_scaleIntrinsicContentSizeEnabled) withKey:&CH_UI_IMAGE_VIEW_SCALE_INTRINSIC_CONTENT_SIZE_ENABLED_KEY];
}

- (BOOL)ch_scaleIntrinsicContentSizeEnabled {
    return [[self ch_getAssociatedValueForKey:&CH_UI_IMAGE_VIEW_SCALE_INTRINSIC_CONTENT_SIZE_ENABLED_KEY] boolValue];
}

- (void)setCh_preferredScaleIntrinsicContentHeight:(CGFloat)ch_preferredScaleIntrinsicContentHeight {
    [self ch_setAssociatedValue:@(ch_preferredScaleIntrinsicContentHeight) withKey:&CH_UI_IMAGE_VIEW_PREFERRED_SCALE_INTRINSIC_CONTENT_HEIGHT_KEY];
}

- (CGFloat)ch_preferredScaleIntrinsicContentHeight {
    id value = [self ch_getAssociatedValueForKey:&CH_UI_IMAGE_VIEW_PREFERRED_SCALE_INTRINSIC_CONTENT_HEIGHT_KEY];
    if (!value) {
        value = @(-1);
    }
    return [value doubleValue];
}

- (void)setCh_preferredScaleIntrinsicContentWidth:(CGFloat)ch_preferredScaleIntrinsicContentWidth {
    [self ch_setAssociatedValue:@(ch_preferredScaleIntrinsicContentWidth) withKey:&CH_UI_IMAGE_VIEW_PREFERRED_SCALE_INTRINSIC_CONTENT_WIDTH_KEY];
}

- (CGFloat)ch_preferredScaleIntrinsicContentWidth {
    id value = [self ch_getAssociatedValueForKey:&CH_UI_IMAGE_VIEW_PREFERRED_SCALE_INTRINSIC_CONTENT_WIDTH_KEY];
    if (!value) {
        value = @(-1);
    }
    return [value doubleValue];
}

#pragma mark - Swizzle
- (CGSize)_ch_ui_image_view_intrinsicContentSize {
    CGSize size = [self _ch_ui_image_view_intrinsicContentSize];
    if (!self.ch_scaleIntrinsicContentSizeEnabled) return size;
    
    CGFloat imageWidth = self.image.size.width;
    CGFloat imageHeight = self.image.size.height;
    if (self.ch_preferredScaleIntrinsicContentHeight >= 0) {
        CGFloat scaledWidth = 0;
        if (imageHeight) {
            scaledWidth = imageWidth * self.ch_preferredScaleIntrinsicContentHeight / imageHeight;
        }
        size = CGSizeMake(scaledWidth, self.ch_preferredScaleIntrinsicContentHeight);
        return size;
    }
    
    if (self.ch_preferredScaleIntrinsicContentWidth >= 0) {
        CGFloat scaledHeight = 0;
        if (imageWidth) {
            scaledHeight = imageHeight * self.ch_preferredScaleIntrinsicContentWidth / imageWidth;
        }
        size = CGSizeMake(self.ch_preferredScaleIntrinsicContentWidth, scaledHeight);
        return size;
    }
    return size;
}

@end
