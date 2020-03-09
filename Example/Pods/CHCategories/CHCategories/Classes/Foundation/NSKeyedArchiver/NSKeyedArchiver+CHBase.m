//
//  NSKeyedArchiver+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/4.
//

#import "NSKeyedArchiver+CHBase.h"

@implementation NSKeyedArchiver (CHBase)

#pragma mark - Base
+ (id)ch_unarchiveObjectWithData:(NSData *)data exception:(__autoreleasing NSException **)exception {
    id object = nil;
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } @catch (NSException *e) {
        if (exception) *exception = e;
    } @finally {
    }
    return object;
}

+ (id)ch_unarchiveObjectWithFile:(NSString *)path exception:(__autoreleasing NSException **)exception {
    id object = nil;
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    } @catch (NSException *e) {
        if (exception) *exception = e;
    } @finally {
    }
    return object;
}

@end
