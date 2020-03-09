//
//  NSPointerArray+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2018/6/2.
//

#import "NSPointerArray+CHBase.h"

@implementation NSPointerArray (CHBase)

#pragma mark - Base
- (NSUInteger)ch_indexOfPointer:(nullable void *)pointer {
    if (!pointer) return NSNotFound;
    
    NSPointerArray *array = [self copy];
    for (NSUInteger i = 0; i < array.count; i++) {
        if ([array pointerAtIndex:i] == ((void *)pointer)) return i;
    }
    return NSNotFound;
}

- (BOOL)ch_containsPointer:(nullable void *)pointer {
    if (!pointer) return NO;
    if ([self ch_indexOfPointer:pointer] != NSNotFound) return YES;
    return NO;
}

@end
