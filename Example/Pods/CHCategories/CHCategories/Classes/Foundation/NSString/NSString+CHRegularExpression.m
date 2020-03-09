//
//  NSString+CHRegularExpression.m
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//

#import "NSString+CHRegularExpression.h"

@implementation NSString (CHRegularExpression)

#pragma mark - Regular Expression
- (BOOL)ch_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
    if (!pattern) return NO;
    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
}

- (void)ch_enumerateRegexMatches:(NSString *)regex options:(NSRegularExpressionOptions)options usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (block) {
            block([self substringWithRange:result.range], result.range, stop);
        }
    }];
}

- (NSString *)ch_stringByReplacingRegex:(NSString *)regex options:(NSRegularExpressionOptions)options withString:(NSString *)replacement {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern) return self;
    
    return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:replacement];
}

- (NSArray *)ch_matchUrls {
    if (self) {
        NSError *error;
        NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(\\w\\.(com|cn|net))";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        
        if (arrayOfAllMatches.count != 0) {
            return arrayOfAllMatches;
        }
    }
    return nil;
}

@end
