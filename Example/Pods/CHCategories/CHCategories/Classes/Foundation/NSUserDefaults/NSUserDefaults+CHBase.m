//
//  NSUserDefaults+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2017/12/6.
//

#import "NSUserDefaults+CHBase.h"
#import "NSDictionary+CHBase.h"

@implementation NSUserDefaults (CHBase)

#pragma mark - Base
- (BOOL)ch_containsKey:(NSString *)key {
    return [[self dictionaryRepresentation] ch_containsKey:key];
}

- (BOOL)ch_containsObjectForKey:(id)key {
    return [[self dictionaryRepresentation] ch_containsObjectForKey:key];
}

@end
