//
//  NSString+CHShareKit.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "NSString+CHShareKit.h"
#import <CHCategories/CHCategories.h>

@implementation NSString (CHShareKit)

- (NSString *)ch_sk_stringByAddingPercentEscapesForURL {
    if (!self.length) return nil;
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
