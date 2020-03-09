//
//  NSAttributedString+CHCreation.m
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//

#import "NSAttributedString+CHCreation.h"
#import "NSAttributedString+CHBase.h"
#import "NSData+CHBase.h"
#import "NSString+CHBase.h"
#import "NSValue+CHBase.h"
#import <UIKit/UIKit.h>

@implementation NSAttributedString (CHCreation)

#pragma mark - Creation
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string textColor:(UIColor *)textColor {
    return [self ch_attributedStringWithString:string textColor:textColor backgroundColor:nil font:nil paragraphStyle:nil];
}

+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string backgroundColor:(UIColor *)backgroundColor {
    return [self ch_attributedStringWithString:string textColor:nil backgroundColor:backgroundColor font:nil paragraphStyle:nil];
}

+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string font:(UIFont *)font {
    return [self ch_attributedStringWithString:string textColor:nil backgroundColor:nil font:font paragraphStyle:nil];
}

+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    return [self ch_attributedStringWithString:string textColor:nil backgroundColor:nil font:nil paragraphStyle:paragraphStyle];
}

+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    if (textColor) {
        [mutableAttributedString ch_addForegroundColor:textColor];
    }
    if (backgroundColor) {
        [mutableAttributedString ch_addBackgroundColor:backgroundColor];
    }
    if (font) {
        [mutableAttributedString ch_addFont:font];
    }
    if (paragraphStyle) {
        [mutableAttributedString ch_addParagraphStyle:paragraphStyle];
    }
    return mutableAttributedString.copy;
}

#pragma mark - Mask
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string textColor:(UIColor *)color font:(UIFont *)font maskRange:(NSRange)maskRange {
    NSMutableDictionary *attributes = @{}.mutableCopy;
    if (color) {
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    return [NSAttributedString ch_attributedStringWithString:string attributes:attributes maskRange:maskRange maskAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}];
}

+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string attributes:(NSDictionary<NSString *, id> *)attrs maskRange:(NSRange)maskRange maskAttributes:(NSDictionary<NSString *, id> *)maskAttrs {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attrs];
    
    if (NSEqualRanges(maskRange, CHNSRangeZero)) return mutableAttributedString.copy;
    
    if ([mutableAttributedString ch_containsRange:maskRange]) {
        [mutableAttributedString addAttributes:maskAttrs range:maskRange];
    }
    return mutableAttributedString.copy;
}

#pragma mark - Size
+ (NSAttributedString *)ch_attributedStringWithWidth:(CGFloat)width {
    return [self ch_attributedStringWithSize:CGSizeMake(width, 1)];
}

+ (NSAttributedString *)ch_attributedStringWithHeight:(CGFloat)height {
    return [self ch_attributedStringWithSize:CGSizeMake(1, height)];
}

+ (NSAttributedString *)ch_attributedStringWithSize:(CGSize)size {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, 0, size.width, size.height);
    return [NSAttributedString attributedStringWithAttachment:attachment];
}

#pragma mark - Image
+ (NSAttributedString *)ch_attributedStringWithImage:(UIImage *)image {
    return [self ch_attributedStringWithImage:image baselineOffset:0 leftSpacing:0 rightSpacing:0];
}

+ (NSAttributedString *)ch_attributedStringWithImage:(UIImage *)image baselineOffset:(CGFloat)baselineOffset leftSpacing:(CGFloat)leftSpacing rightSpacing:(CGFloat)rightSpacing {
    if (!image) return nil;
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    NSMutableAttributedString *mutableAttributedString = [NSAttributedString attributedStringWithAttachment:attachment].mutableCopy;
    [mutableAttributedString ch_addBaselineOffset:@(baselineOffset)];
    if (leftSpacing > 0) {
        [mutableAttributedString insertAttributedString:[self ch_attributedStringWithWidth:leftSpacing] atIndex:0];
    }
    if (rightSpacing > 0) {
        [mutableAttributedString appendAttributedString:[self ch_attributedStringWithWidth:rightSpacing]];
    }
    return mutableAttributedString.copy;
}

#pragma mark - HTML
- (nullable instancetype)ch_initWithHTMLString:(NSString *)HTMLString {
    return [[[self class] alloc] initWithData:HTMLString.ch_dataValue
                                      options:@{
                                                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding),
                                                }
                           documentAttributes:nil
                                        error:nil];
}

@end
