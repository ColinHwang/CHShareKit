//
//  NSException+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2019/8/30.
//

#import "NSException+CHBase.h"
#import "NSObject+CHBase.h"
#import "NSValue+CHBase.h"

static BOOL CH_NS_EXCEPTIOM_KVC_ACCESS_PROHIBITED_EXCEPTIOM_ENABLED = NO;

@implementation NSException (CHBase)

#pragma mark - Base
+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray *selectors = @[
                [NSValue ch_valueWithSelector:@selector(raise:format:)],
            ];
            CHNSObjectSwizzleClassMethodsWithNewMethodPrefix(self, selectors, @"_ch_ns_exception_");
        });
    }
}

+ (void)ch_setupKVCAccessProhibitedExceptionEnabled:(BOOL)enabled {
    CH_NS_EXCEPTIOM_KVC_ACCESS_PROHIBITED_EXCEPTIOM_ENABLED = enabled;
}

+ (BOOL)ch_KVCAccessProhibitedExceptionEnabled {
    return CH_NS_EXCEPTIOM_KVC_ACCESS_PROHIBITED_EXCEPTIOM_ENABLED;
}

#pragma mark - Swizzle
+ (void)_ch_ns_exception_raise:(NSExceptionName)name format:(NSString *)format, ... {
    // iOS13, 苹果对UIKit组件KVC访问私有变量进行了访问保护
    if (name == NSGenericException && [format isEqualToString:@"Access to %@'s %@ ivar is prohibited. This is an application bug"]) {
        if (![self ch_KVCAccessProhibitedExceptionEnabled]) return;
    }
    
    [self raise:name format:@"%@", format];
}

@end

