//
//  NSIndexPath+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/4.
//

#import "NSIndexPath+CHBase.h"

@implementation NSIndexPath (CHBase)

#pragma mark - Base
- (BOOL)ch_isEqualToIndexPath:(NSIndexPath *)other {
    if (!other) return NO;
    if (![other isKindOfClass:[NSIndexPath class]]) return NO;
    if (self == other) return YES;
    
    return [self compare:other] == NSOrderedSame;
}

@end
