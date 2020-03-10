//
//  CHSKWXCheckHelper.m
//  CHShareKit
//
//  Created by CHwang on 2020/3/10.
//

#import "CHSKWXCheckHelper.h"
#import "CHSKPrivateDefines.h"
#import "NSString+CHShareKit.h"

@implementation CHSKWXCheckHelper

+ (BOOL)isValidTitle:(NSString *)title {
    return title.length <= CHSKWXShareTitleMaxLength;
}

+ (BOOL)isValidDesc:(NSString *)desc {
    return desc.length <= CHSKWXShareDescMaxLength;
}

+ (BOOL)isValidURLString:(NSString *)URLString {
    if (!URLString.length) return NO;
    
    NSString *aURLString = [URLString ch_sk_stringByAddingPercentEscapesForURL];
    return aURLString.length <= CHSKWXShareURLStringMaxLength;
}

+ (BOOL)isValidURL:(NSURL *)URL {
    return [self isValidURLString:URL.absoluteString];
}

@end
