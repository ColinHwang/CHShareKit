//
//  CALayer+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/6.
//

#import "CALayer+CHBase.h"
#import "CHCoreGraphicHelper.h"
#import <UIKit/UIKit.h>

@implementation CALayer (CHBase)

#pragma mark - Base
- (UIViewContentMode)ch_contentMode {
    return CHCAGravityToUIViewContentMode(self.contentsGravity);
}

- (void)setCh_contentMode:(UIViewContentMode)contentMode {
    self.contentsGravity = CHUIViewContentModeToCAGravity(contentMode);
}

- (void)ch_exchangeSublayerAtIndex:(unsigned)index1 withSublayerAtIndex:(unsigned)index2 {
    CALayer *sublayer1 = [self.sublayers objectAtIndex:index1];
    if (!sublayer1) return;
    
    CALayer *sublayer2 = [self.sublayers objectAtIndex:index2];
    if (!sublayer2) return;
    
    if (index1 == index2) return;

    [sublayer1 removeFromSuperlayer];
    [sublayer2 removeFromSuperlayer];
    if (index1 > index2) {
        [self insertSublayer:sublayer1 atIndex:index2];
        [self insertSublayer:sublayer2 atIndex:index1];
    } else {
        [self insertSublayer:sublayer2 atIndex:index1];
        [self insertSublayer:sublayer1 atIndex:index2];
    }
}

- (void)ch_bringSublayerToFront:(CALayer *)sublayer {
    if (!sublayer) return;
    if (self == sublayer) return;
    if (![self.sublayers containsObject:sublayer]) return;
    
    [sublayer removeFromSuperlayer];
    [self insertSublayer:sublayer atIndex:(unsigned)self.sublayers.count];
}

- (void)ch_sendSublayerToBack:(CALayer *)sublayer {
    if (!sublayer) return;
    if (self == sublayer) return;
    if (![self.sublayers containsObject:sublayer]) return;
    
    [sublayer removeFromSuperlayer];
    [self insertSublayer:sublayer atIndex:0];
}

- (void)ch_bringToFront {
    if (self.superlayer) {
        [self.superlayer ch_bringSublayerToFront:self];
    }
}

- (void)ch_sendToBack {
    if (self.superlayer) {
        [self.superlayer ch_sendSublayerToBack:self];
    }
}

- (void)ch_removeSublayer:(CALayer *)sublayer {
    if ([self.sublayers containsObject:sublayer]) {
        [sublayer removeFromSuperlayer];
    }
}

- (void)ch_removeAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeFromSuperlayer];
    }
}

#pragma mark - Layout
- (CGFloat)ch_x {
    return self.frame.origin.x;
}

- (void)setCh_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)ch_y {
    return self.frame.origin.y;
}

- (void)setCh_y:(CGFloat)ch_y {
    CGRect frame = self.frame;
    frame.origin.y = ch_y;
    self.frame = frame;
}

- (CGPoint)ch_origin {
    return self.frame.origin;
}

- (void)setCh_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)ch_width {
    return self.frame.size.width;
}

- (void)setCh_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)ch_height {
    return self.frame.size.height;
}

- (void)setCh_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)ch_frameSize {
    return self.frame.size;
}

- (void)setCh_frameSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)ch_centerX {
    return self.frame.origin.x + self.frame.size.width * 0.5;
}

- (void)setCh_centerX:(CGFloat)centerX {
    CGRect frame = self.frame;
    frame.origin.x = centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)ch_centerY {
    return self.frame.origin.y + self.frame.size.height * 0.5;
}

- (void)setCh_centerY:(CGFloat)centerY {
    CGRect frame = self.frame;
    frame.origin.y = centerY - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGPoint)ch_center {
    return CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5,
                       self.frame.origin.y + self.frame.size.height * 0.5);
}

- (void)setCh_center:(CGPoint)center {
    CGRect frame = self.frame;
    frame.origin.x = center.x - frame.size.width * 0.5;
    frame.origin.y = center.y - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGFloat)ch_left {
    return self.frame.origin.x;
}

- (void)setCh_left:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)ch_top {
    return self.frame.origin.y;
}

- (void)setCh_top:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)ch_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setCh_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ch_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setCh_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

#pragma mark - Shadow
- (void)ch_setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    [self ch_setLayerShadow:color offset:offset radius:radius opacity:1];
}

- (void)ch_setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = opacity;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - Snapshot
- (UIImage *)ch_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
