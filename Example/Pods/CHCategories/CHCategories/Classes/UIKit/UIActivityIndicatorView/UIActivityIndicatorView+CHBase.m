//
//  UIActivityIndicatorView+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2019/2/1.
//

#import "UIActivityIndicatorView+CHBase.h"

@implementation UIActivityIndicatorView (CHBase)

#pragma mark - Base
- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style size:(CGSize)size {
    self = [self initWithActivityIndicatorStyle:style];
    if (self) {
        CGSize initialSize = self.bounds.size;
        CGFloat scale = size.width / initialSize.width;
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return self;
}

@end
