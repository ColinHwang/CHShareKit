//
//  NSURLComponents+CHBase.m
//  Pods
//
//  Created by CHwang on 17/8/8.
//
//

#import "NSURLComponents+CHBase.h"

@implementation NSURLComponents (CHBase)

#pragma mark - Base
- (void)ch_addQueryItem:(NSURLQueryItem *)queryItem {
    if (!queryItem) return;
    
    NSMutableArray *buffer = self.queryItems ? self.queryItems.mutableCopy : @[].mutableCopy;
    [buffer addObject:queryItem];
    self.queryItems = buffer.copy;
}

- (void)ch_addQueryItemWithName:(NSString *)name value:(NSString *)value {
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:name value:value];
    [self ch_addQueryItem:queryItem];
}

@end
