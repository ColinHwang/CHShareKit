//
//  NSParagraphStyle+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/14.
//
//

#import "NSParagraphStyle+CHBase.h"
#import <CoreText/CoreText.h>

@implementation NSParagraphStyle (CHBase)

#pragma mark - Base
+ (NSParagraphStyle *)ch_paragraphstyleWithCTParagraphStyle:(CTParagraphStyleRef)CTParagraphStyle {
    if (CTParagraphStyle == NULL) return nil;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat lineSpacing;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing)) {
        style.lineSpacing = lineSpacing;
    }
#pragma clang diagnostic pop
    
    CGFloat paragraphSpacing;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing)) {
        style.paragraphSpacing = paragraphSpacing;
    }
    
    CTTextAlignment alignment;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment)) {
        style.alignment = NSTextAlignmentFromCTTextAlignment(alignment);
    }
    
    CGFloat firstLineHeadIndent;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent)) {
        style.firstLineHeadIndent = firstLineHeadIndent;
    }
    
    CGFloat headIndent;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent)) {
        style.headIndent = headIndent;
    }
    
    CGFloat tailIndent;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent)) {
        style.tailIndent = tailIndent;
    }
    
    CTLineBreakMode lineBreakMode;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode)) {
        style.lineBreakMode = (NSLineBreakMode)lineBreakMode;
    }
    
    CGFloat minimumLineHeight;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight)) {
        style.minimumLineHeight = minimumLineHeight;
    }
    
    CGFloat maximumLineHeight;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maximumLineHeight)) {
        style.maximumLineHeight = maximumLineHeight;
    }
    
    CTWritingDirection baseWritingDirection;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &baseWritingDirection)) {
        style.baseWritingDirection = (NSWritingDirection)baseWritingDirection;
    }
    
    CGFloat lineHeightMultiple;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple)) {
        style.lineHeightMultiple = lineHeightMultiple;
    }
    
    CGFloat paragraphSpacingBefore;
    if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore)) {
        style.paragraphSpacingBefore = paragraphSpacingBefore;
    }
    
    if ([style respondsToSelector:@selector(tabStops)]) {
        CFArrayRef tabStops;
        if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops)) {
            if ([style respondsToSelector:@selector(setTabStops:)]) {
                NSMutableArray *tabs = [NSMutableArray new];
                [((__bridge NSArray *)(tabStops))enumerateObjectsUsingBlock : ^(id obj, NSUInteger idx, BOOL *stop) {
                    CTTextTabRef ctTab = (__bridge CFTypeRef)obj;
                    
                    NSTextTab *tab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentFromCTTextAlignment(CTTextTabGetAlignment(ctTab)) location:CTTextTabGetLocation(ctTab) options:(__bridge id)CTTextTabGetOptions(ctTab)];
                    [tabs addObject:tab];
                }];
                if (tabs.count) {
                    style.tabStops = tabs;
                }
            }
        }
        
        CGFloat defaultTabInterval;
        if (CTParagraphStyleGetValueForSpecifier(CTParagraphStyle, kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &defaultTabInterval)) {
            if ([style respondsToSelector:@selector(setDefaultTabInterval:)]) {
                style.defaultTabInterval = defaultTabInterval;
            }
        }
    }
    
    return style;
}

- (CTParagraphStyleRef)ch_CTParagraphStyle CF_RETURNS_RETAINED {
    CTParagraphStyleSetting set[kCTParagraphStyleSpecifierCount] = { 0 };
    int count = 0;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat lineSpacing = self.lineSpacing;
    set[count].spec = kCTParagraphStyleSpecifierLineSpacing;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &lineSpacing;
    count++;
#pragma clang diagnostic pop
    
    CGFloat paragraphSpacing = self.paragraphSpacing;
    set[count].spec = kCTParagraphStyleSpecifierParagraphSpacing;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &paragraphSpacing;
    count++;
    
    CTTextAlignment alignment = NSTextAlignmentToCTTextAlignment(self.alignment);
    set[count].spec = kCTParagraphStyleSpecifierAlignment;
    set[count].valueSize = sizeof(CTTextAlignment);
    set[count].value = &alignment;
    count++;
    
    CGFloat firstLineHeadIndent = self.firstLineHeadIndent;
    set[count].spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &firstLineHeadIndent;
    count++;
    
    CGFloat headIndent = self.headIndent;
    set[count].spec = kCTParagraphStyleSpecifierHeadIndent;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &headIndent;
    count++;
    
    CGFloat tailIndent = self.tailIndent;
    set[count].spec = kCTParagraphStyleSpecifierTailIndent;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &tailIndent;
    count++;
    
    CTLineBreakMode paraLineBreak = (CTLineBreakMode)self.lineBreakMode;
    set[count].spec = kCTParagraphStyleSpecifierLineBreakMode;
    set[count].valueSize = sizeof(CTLineBreakMode);
    set[count].value = &paraLineBreak;
    count++;
    
    CGFloat minimumLineHeight = self.minimumLineHeight;
    set[count].spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &minimumLineHeight;
    count++;
    
    CGFloat maximumLineHeight = self.maximumLineHeight;
    set[count].spec = kCTParagraphStyleSpecifierMaximumLineHeight;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &maximumLineHeight;
    count++;
    
    CTWritingDirection paraWritingDirection = (CTWritingDirection)self.baseWritingDirection;
    set[count].spec = kCTParagraphStyleSpecifierBaseWritingDirection;
    set[count].valueSize = sizeof(CTWritingDirection);
    set[count].value = &paraWritingDirection;
    count++;
    
    CGFloat lineHeightMultiple = self.lineHeightMultiple;
    set[count].spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &lineHeightMultiple;
    count++;
    
    CGFloat paragraphSpacingBefore = self.paragraphSpacingBefore;
    set[count].spec = kCTParagraphStyleSpecifierParagraphSpacingBefore;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &paragraphSpacingBefore;
    count++;
    
    if([self respondsToSelector:@selector(tabStops)]) {
        NSMutableArray *tabs = [NSMutableArray array];
        if ([self respondsToSelector:@selector(tabStops)]) {
            NSInteger numTabs = self.tabStops.count;
            if (numTabs) {
                [self.tabStops enumerateObjectsUsingBlock: ^(NSTextTab *tab, NSUInteger idx, BOOL *stop) {
                    CTTextTabRef ctTab = CTTextTabCreate(NSTextAlignmentToCTTextAlignment(tab.alignment), tab.location, (__bridge CFTypeRef)tab.options);
                    [tabs addObject:(__bridge id)ctTab];
                    CFRelease(ctTab);
                }];
                
                CFArrayRef tabStops = (__bridge CFArrayRef)(tabs);
                set[count].spec = kCTParagraphStyleSpecifierTabStops;
                set[count].valueSize = sizeof(CFArrayRef);
                set[count].value = &tabStops;
                count++;
            }
        }
        
        if ([self respondsToSelector:@selector(defaultTabInterval)]) {
            CGFloat defaultTabInterval = self.defaultTabInterval;
            set[count].spec = kCTParagraphStyleSpecifierDefaultTabInterval;
            set[count].valueSize = sizeof(CGFloat);
            set[count].value = &defaultTabInterval;
            count++;
        }
    }
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(set, count);
    return style;
}

#pragma mark - Creation
+ (instancetype)ch_paragraphStyleWithLineHeight:(CGFloat)lineHeight {
        return [self ch_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)ch_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode {
        return [self ch_paragraphStyleWithLineHeight:lineHeight lineBreakMode:lineBreakMode textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)ch_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = textAlignment;
    if ([self isKindOfClass:[NSMutableParagraphStyle class]]) return paragraphStyle;
    
    return paragraphStyle.copy;
}

@end


@implementation NSMutableParagraphStyle (CHBase)

#pragma mark - Base
- (void)ch_addTabStop:(NSTextTab *)tabStop {
    NSMutableArray *buffer = self.tabStops.mutableCopy;
    if (tabStop) {
        [buffer addObject:tabStop];
    }
    self.tabStops = buffer.copy;
}

- (void)ch_removeTabStop:(NSTextTab *)tabStop {
    NSMutableArray *buffer = self.tabStops.mutableCopy;
    if (tabStop) {
        [buffer removeObject:tabStop];
    }
    self.tabStops = buffer.copy;
}

- (void)ch_setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    self.lineSpacing = paragraphStyle.lineSpacing;
    self.paragraphSpacing = paragraphStyle.paragraphSpacing;
    self.alignment = paragraphStyle.alignment;
    self.firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
    self.headIndent = paragraphStyle.headIndent;
    self.tailIndent = paragraphStyle.tailIndent;
    self.lineBreakMode = paragraphStyle.lineBreakMode;
    self.minimumLineHeight = paragraphStyle.minimumLineHeight;
    self.maximumLineHeight = paragraphStyle.maximumLineHeight;
    self.baseWritingDirection = paragraphStyle.baseWritingDirection;
    self.lineHeightMultiple = paragraphStyle.lineHeightMultiple;
    self.paragraphSpacingBefore = paragraphStyle.paragraphSpacingBefore;
    self.hyphenationFactor = paragraphStyle.hyphenationFactor;
    self.tabStops = paragraphStyle.tabStops;
    self.tabStops = paragraphStyle.tabStops;
    if (@available(iOS 9.0, *)) {
        self.allowsDefaultTighteningForTruncation = paragraphStyle.allowsDefaultTighteningForTruncation;
    } 
}

@end
