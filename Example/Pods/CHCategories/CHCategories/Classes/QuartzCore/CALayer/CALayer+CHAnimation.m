//
//  CALayer+CHAnimation.m
//  CHCategories
//
//  Created by CHwang on 2019/1/25.
//

#import "CALayer+CHAnimation.h"
#import <UIKit/UIKit.h>

@implementation CALayer (CHAnimation)

#pragma mark - Animation
- (CGFloat)ch_transformRotation {
    NSNumber *value = [self valueForKeyPath:@"transform.rotation"];
    return value.doubleValue;
}

- (void)setCh_transformRotation:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.rotation"];
}

- (CGFloat)ch_transformRotationX {
    NSNumber *value = [self valueForKeyPath:@"transform.rotation.x"];
    return value.doubleValue;
}

- (void)setCh_transformRotationX:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.rotation.x"];
}

- (CGFloat)ch_transformRotationY {
    NSNumber *value = [self valueForKeyPath:@"transform.rotation.y"];
    return value.doubleValue;
}

- (void)setCh_transformRotationY:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.rotation.y"];
}

- (CGFloat)ch_transformRotationZ {
    NSNumber *value = [self valueForKeyPath:@"transform.rotation.z"];
    return value.doubleValue;
}

- (void)setCh_transformRotationZ:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.rotation.z"];
}

- (CGFloat)ch_transformScaleX {
    NSNumber *value = [self valueForKeyPath:@"transform.scale.x"];
    return value.doubleValue;
}

- (void)setCh_transformScaleX:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.scale.x"];
}

- (CGFloat)ch_transformScaleY {
    NSNumber *value = [self valueForKeyPath:@"transform.scale.y"];
    return value.doubleValue;
}

- (void)setCh_transformScaleY:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.scale.y"];
}

- (CGFloat)ch_transformScaleZ {
    NSNumber *value = [self valueForKeyPath:@"transform.scale.z"];
    return value.doubleValue;
}

- (void)setCh_transformScaleZ:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.scale.z"];
}

- (CGFloat)ch_transformScale {
    NSNumber *value = [self valueForKeyPath:@"transform.scale"];
    return value.doubleValue;
}

- (void)setCh_transformScale:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.scale"];
}

- (CGFloat)ch_transformTranslationX {
    NSNumber *value = [self valueForKeyPath:@"transform.translation.x"];
    return value.doubleValue;
}

- (void)setCh_transformTranslationX:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.translation.x"];
}

- (CGFloat)ch_transformTranslationY {
    NSNumber *value = [self valueForKeyPath:@"transform.translation.y"];
    return value.doubleValue;
}

- (void)setCh_transformTranslationY:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.translation.y"];
}

- (CGFloat)ch_transformTranslationZ {
    NSNumber *value = [self valueForKeyPath:@"transform.translation.z"];
    return value.doubleValue;
}

- (void)setCh_transformTranslationZ:(CGFloat)value {
    [self setValue:@(value) forKeyPath:@"transform.translation.z"];
}

- (CGFloat)ch_transformDepth {
    return self.transform.m34;
}

- (void)setCh_transformDepth:(CGFloat)value {
    CATransform3D transform = self.transform;
    transform.m34 = value;
    self.transform = transform;
}

#pragma mark - Animations
- (void)ch_removeDefaultAnimations {
    NSMutableDictionary<NSString *, id<CAAction>> *actions = @{
                                                               NSStringFromSelector(@selector(bounds)): [NSNull null],
                                                               NSStringFromSelector(@selector(position)): [NSNull null],
                                                               NSStringFromSelector(@selector(zPosition)): [NSNull null],
                                                               NSStringFromSelector(@selector(anchorPoint)): [NSNull null],
                                                               NSStringFromSelector(@selector(anchorPointZ)): [NSNull null],
                                                               NSStringFromSelector(@selector(transform)): [NSNull null],
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                                               NSStringFromSelector(@selector(hidden)): [NSNull null],
                                                               NSStringFromSelector(@selector(doubleSided)): [NSNull null],
#pragma clang diagnostic pop
                                                               NSStringFromSelector(@selector(sublayerTransform)): [NSNull null],
                                                               NSStringFromSelector(@selector(masksToBounds)): [NSNull null],
                                                               NSStringFromSelector(@selector(contents)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsRect)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsScale)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsCenter)): [NSNull null],
                                                               NSStringFromSelector(@selector(minificationFilterBias)): [NSNull null],
                                                               NSStringFromSelector(@selector(backgroundColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(cornerRadius)): [NSNull null],
                                                               NSStringFromSelector(@selector(borderWidth)): [NSNull null],
                                                               NSStringFromSelector(@selector(borderColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(opacity)): [NSNull null],
                                                               NSStringFromSelector(@selector(compositingFilter)): [NSNull null],
                                                               NSStringFromSelector(@selector(filters)): [NSNull null],
                                                               NSStringFromSelector(@selector(backgroundFilters)): [NSNull null],
                                                               NSStringFromSelector(@selector(shouldRasterize)): [NSNull null],
                                                               NSStringFromSelector(@selector(rasterizationScale)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowOpacity)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowOffset)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowRadius)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowPath)): [NSNull null]
                                                               }.mutableCopy;
    self.actions = actions.copy;
}

#pragma mark - Fade
- (void)ch_addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    if (duration <= 0) return;
    
    NSString *mediaFunction;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
        {
            mediaFunction = kCAMediaTimingFunctionEaseInEaseOut;
        }
            break;
        case UIViewAnimationCurveEaseIn:
        {
            mediaFunction = kCAMediaTimingFunctionEaseIn;
        }
            break;
        case UIViewAnimationCurveEaseOut:
        {
            mediaFunction = kCAMediaTimingFunctionEaseOut;
        }
            break;
        case UIViewAnimationCurveLinear:
        {
            mediaFunction = kCAMediaTimingFunctionLinear;
        }
            break;
        default:
        {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:mediaFunction];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:@"calayer.fade"];
}

- (void)ch_removePreviousFadeAnimation {
    [self removeAnimationForKey:@"calayer.fade"];
}

#pragma mark - Opacity Forever
- (void)ch_addOpacityForeverAnimation:(NSTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue repeatCount:(int)repeatCount {
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:fromValue];
    animation.toValue=[NSNumber numberWithFloat:toValue];
    animation.autoreverses=YES;
    animation.duration=duration;
    animation.repeatCount=repeatCount;
    animation.removedOnCompletion=NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode=kCAFillModeForwards;
    [self addAnimation:animation forKey:@"CHOpacityForeverAnimation"];
}

- (void)ch_removeOpacityForeverAnimation {
    [self removeAnimationForKey:@"CHOpacityForeverAnimation"];
}

#pragma mark - Rotation
- (void)ch_addRotationAnimation:(NSTimeInterval)duration degree:(float)degree direction:(CHCALayerAxis)axis repeatCount:(int)repeatCount
{
    CABasicAnimation* animation;
    NSArray *axisArr = @[@"transform.rotation.x", @"transform.rotation.y", @"transform.rotation.z"];
    animation = [CABasicAnimation animationWithKeyPath:axisArr[axis]];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue= [NSNumber numberWithFloat:degree];
    animation.duration= duration;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
    [self addAnimation:animation forKey:@"CHRotationAnimation"];
}

- (void)ch_removeRotationAnimation {
    [self removeAnimationForKey:@"CHRotationAnimation"];
}

#pragma mark - Scale
- (void)ch_addScaleAnimation:(CGFloat)fromScale toScale:(CGFloat)toScale duration:(NSTimeInterval)duration repeatCount:(float)repeatCount {
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(fromScale);
    animation.toValue = @(toScale);
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self addAnimation:animation forKey:@"CHScaleAnimation"];
}

- (void)ch_removeScaleAnimation {
    [self removeAnimationForKey:@"CHScaleAnimation"];
}

#pragma mark - Shake
- (void)ch_addShakeAnimation:(NSTimeInterval)duration repeatCount:(float)repeatCount {
    NSAssert([self isKindOfClass:[CALayer class]] , @"invalid target");
    CGPoint originPos = CGPointZero;
    CGSize originSize = CGSizeZero;
    if ([self isKindOfClass:[CALayer class]]) {
        originPos = [(CALayer *)self position];
        originSize = [(CALayer *)self bounds].size;
    }
    CGFloat hOffset = originSize.width / 4;
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"position";
    anim.values=@[
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x-hOffset, originPos.y)],
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x+hOffset, originPos.y)],
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)]
                  ];
    anim.repeatCount = repeatCount;
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    [self addAnimation:anim forKey:@"CHShakeAnimation"];
}

- (void)ch_removeShakeAnimation {
    [self removeAnimationForKey:@"CHShakeAnimation"];
}

#pragma mark - Bounce
- (void)ch_addBounceAnimation:(NSTimeInterval)duration repeatCount:(float)repeatCount {
    NSAssert([self isKindOfClass:[CALayer class]] , @"invalid target");
    CGPoint originPos = CGPointZero;
    CGSize originSize = CGSizeZero;
    if ([self isKindOfClass:[CALayer class]]) {
        originPos = [(CALayer *)self position];
        originSize = [(CALayer *)self bounds].size;
    }
    CGFloat hOffset = originSize.height / 4;
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"position";
    anim.values=@[
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y-hOffset)],
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y+hOffset)],
                  [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)]
                  ];
    anim.repeatCount=repeatCount;
    anim.duration=duration;
    anim.fillMode = kCAFillModeForwards;
    [self addAnimation:anim forKey:@"CHBounceAnimation"];

}

- (void)ch_removeBounceAnimation {
    [self removeAnimationForKey:@"CHBounceAnimation"];
}

@end
