//
//  NSString+CHShareKit.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "NSString+CHShareKit.h"
#import "CHSKPrivateDefines.h"

#import <CHCategories/CHCategories.h>

@implementation NSString (CHShareKit)

- (BOOL)ch_sk_isValidTitleForWX {
    return (self.length <= CHSKWXShareTitleMaxLength);
}

- (BOOL)ch_sk_isValidDescForWX {
    return (self.length <= CHSKWXShareDescMaxLength);
}

- (BOOL)ch_sk_isValidURLStringForWX {
    if (!self.length) return NO;
    
    NSString *URLString = [self ch_sk_stringByAddingPercentEscapesForURL];
    return (URLString.length <= CHSKWXShareURLStringMaxLength);
}

- (NSString *)ch_sk_stringByAddingPercentEscapesForURL {
    if (!self) return nil;
    if (!self.length) return nil;
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
