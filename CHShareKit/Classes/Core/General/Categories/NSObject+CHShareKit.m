//
//  NSObject+CHShareKit.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "NSObject+CHShareKit.h"
#import "NSString+CHShareKit.h"
#import "NSURL+CHShareKit.h"

@implementation NSObject (CHShareKit)

- (BOOL)ch_sk_isValidClassForShareImage {
    if ([self isKindOfClass:[UIImage class]]) return YES;
    if ([self isKindOfClass:[NSURL class]]) return YES;
    if ([self isKindOfClass:[NSString class]]) return YES;
    
    return NO;
}

- (BOOL)ch_sk_isValidShareImageForWX {
    if ([self isKindOfClass:[UIImage class]]) return YES;
    if ([self isKindOfClass:[NSURL class]]) return [(NSURL *)self ch_sk_isValidURLForWX];
    if ([self isKindOfClass:[NSString class]]) return [(NSString *)self ch_sk_isValidURLStringForWX];
    
    return NO;
}

@end
