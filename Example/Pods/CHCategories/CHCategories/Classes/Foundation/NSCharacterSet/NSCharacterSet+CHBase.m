//
//  NSCharacterSet+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2020/2/1.
//

#import "NSCharacterSet+CHBase.h"

@implementation NSCharacterSet (CHBase)

#pragma mark - Base
+ (NSCharacterSet *)ch_URLQueryUserInputAllowedCharacterSet {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet ch_URLQueryUserInputAllowedCharacterSet];
    return characterSet.copy;
}

@end


@implementation NSMutableCharacterSet (CHBase)

#pragma mark - Base
+ (NSMutableCharacterSet *)ch_URLQueryUserInputAllowedCharacterSet {
    NSMutableCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [characterSet removeCharactersInString:@"#&="];
    return characterSet;
}

@end
