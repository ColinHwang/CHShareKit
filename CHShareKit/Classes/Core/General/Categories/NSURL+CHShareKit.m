//
//  NSURL+CHShareKit.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "NSURL+CHShareKit.h"
#import "NSString+CHShareKit.h"

@implementation NSURL (CHShareKit)

- (BOOL)ch_sk_isValidURLForWX {
    return [self.absoluteString ch_sk_isValidURLStringForWX];
}

@end
