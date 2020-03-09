//
//  UISlider+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UISlider+CHBase.h"

@implementation UISlider (CHBase)

#pragma mark - Base
- (CGRect)ch_trackRect {
    return [self trackRectForBounds:self.bounds];
}

- (CGRect)ch_thumbRect {
    return [self thumbRectForBounds:self.bounds trackRect:self.ch_trackRect value:self.value];
}

@end
