//
//  NSArray+CHShareKit.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "NSArray+CHShareKit.h"
#import "NSObject+CHShareKit.h"

@implementation NSArray (CHShareKit)

- (BOOL)ch_sk_isValidShareImages {
    if (![self count]) return NO;
    
    for (id element in self) {
        if ([element ch_sk_isValidClassForShareImage]) continue;
        
        return NO;
    }
    return YES;
}

- (BOOL)ch_sk_isValidShareImagesForWX {
    if (![self count]) return NO;
    
    for (id element in self) {
        if ([element ch_sk_isValidShareImageForWX]) continue;
        
        return NO;
    }
    return YES;
}

@end
