//
//  NSJSONSerialization+CHBase.m
//  Pods
//
//  Created by CHwang on 17/2/4.
//
//

#import "NSJSONSerialization+CHBase.h"

@implementation NSJSONSerialization (CHBase)

#pragma mark - Base
+ (id)ch_JSONObjectWithString:(NSString *)string error:(NSError **)error {
    if (!string) return nil;
    if (![string isKindOfClass:[NSString class]]) return nil;
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    id JSONObject = [NSJSONSerialization JSONObjectWithData:stringData options:NSJSONReadingAllowFragments error:error];
    if (!JSONObject) return nil;
    
    if ([JSONObject isKindOfClass:[NSString class]]) {
        JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONObject dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
    }
    return JSONObject;
}

@end
