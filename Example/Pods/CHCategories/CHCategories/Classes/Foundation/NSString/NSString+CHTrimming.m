//
//  NSString+CHTrimming.m
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//

#import "NSString+CHTrimming.h"
#import "NSString+CHBase.h"
#import "NSString+CHRegularExpression.h"

@implementation NSString (CHTrimming)

- (NSString *)ch_stringByTrimmingDecimalNumbers {
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = @"[0-9]";
    });
    return [self ch_stringByReplacingRegex:regex options:0 withString:@""];
}

- (NSString *)ch_stringByTrimmingLetters {
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = @"[a-zA-Z]";
    });
    return [self ch_stringByReplacingRegex:regex options:0 withString:@""];
}

- (NSString *)ch_stringByTrimmingUppercaseLetters {
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = @"[A-Z]";
    });
    return [self ch_stringByReplacingRegex:regex options:0 withString:@""];
}

- (NSString *)ch_stringByTrimmingLowercaseLetters {
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = @"[a-z]";
    });
    return [self ch_stringByReplacingRegex:regex options:0 withString:@""];
}

- (NSString *)ch_stringByTrimmingAlphanumericCharacters {
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = @"[0-9a-zA-Z]";
    });
    return [self ch_stringByReplacingRegex:regex options:0 withString:@""];
}

- (NSString *)ch_stringByTrimmingPunctuation {
    /*
     https://zh.wikipedia.org/wiki/Unicode%E5%AD%97%E7%AC%A6%E5%88%97%E8%A1%A8
     !"#$%&'()*+,-./
     :;<=>?@
     [\]^_`
     {|}~
     */
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = @"[\\U00000021-\\U0000002F\\U0000003A-\\U00000040\\U0000005B-\\U00000060\\U0000007B-\\U0000007E]";
    });
    return [self ch_stringByReplacingRegex:regex options:0 withString:@""];
}

- (NSString *)ch_stringByTrimmingCharacter:(unichar)character {
    NSString *string = [NSString stringWithFormat:@"%c", character];
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
}

- (NSString *)ch_stringByTrimmingAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)ch_stringByTrimmingExtraWhitespace {
    if (!self.length) return self;
    
    NSString *string = [self ch_stringByTrimmingWhitespace];
    
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    
    return [components componentsJoinedByString:@" "];
}

- (NSString *)ch_stringByTrimmingWhitespace {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)ch_stringByTrimmingWhitespaceAndNewline {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)ch_stringByTrimmingLineBreakCharacters {
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = @"[\r\n]";
    });
    return [self ch_stringByReplacingRegex:regex options:0 withString:@""];
}

- (NSString *)ch_stringByTrimmingUnknownCharacters {
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = @"[\u0300-\u036F]";
    });
    return [self ch_stringByReplacingRegex:regex options:0 withString:@""];
}

- (NSArray<NSString *> *)ch_substringsByTrimmingWhitespaceAndNewline {
    return [self ch_substringsInRange:self.ch_rangeOfAll usingBlock:^BOOL(NSString *substring, NSRange substringRange, BOOL *stop) {
        return substring.ch_stringByTrimmingWhitespaceAndNewline.length;
    }];
}

@end
