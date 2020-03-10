//
//  CHSKCheckHelper.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKCheckHelper.h"
#import "NSString+CHShareKit.h"

@implementation CHSKCheckHelper

#pragma mark - Public methods
+ (BOOL)isValidTitle:(NSString *)title {
    return title != nil;
}

+ (BOOL)isValidDesc:(NSString *)desc {
    return desc != nil;
}

+ (BOOL)isValidURLString:(NSString *)URLString {
    return URLString.length;
}

+ (BOOL)isValidURL:(NSURL *)URL {
    return URL && URL.absoluteString.length;
}

+ (BOOL)isValidImage:(id)image {
    if (!image) return NO;
    if ([image isKindOfClass:[UIImage class]]) return YES;
    if ([image isKindOfClass:[NSURL class]]) return [self isValidURL:image];
    if ([image isKindOfClass:[NSString class]]) return [self isValidURLString:image];
    
    return NO;
}

+ (BOOL)isValidImages:(NSArray<id> *)images {
    if (!images.count) return NO;
    
    for (id image in images) {
        if ([self isValidImage:image]) continue;
        
        return NO;
    }
    return YES;
}

@end
