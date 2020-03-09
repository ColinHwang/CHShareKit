//
//  UIBarItem+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2019/2/13.
//

#import "UIBarItem+CHBase.h"

@implementation UIBarItem (CHBase)

#pragma mark - Base
- (UIView *)ch_view {
    if ([self respondsToSelector:@selector(view)]) {
        return [self valueForKey:@"view"];
    }
    return nil;
}

@end
