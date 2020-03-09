//
//  NSAttributedString+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/12.
//
//

#import "NSAttributedString+CHBase.h"
#import "NSString+CHBase.h"
#import "NSValue+CHBase.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@implementation NSAttributedString (CHBase)

#pragma mark - Base
- (NSDictionary *)_ch_defaultAttributes {
    static NSDictionary *defaultAttributes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSInteger writingDirectionEmbedding = (0 << 1); // NSTextWritingDirectionEmbedding/NSWritingDirectionEmbedding
        defaultAttributes = @{
                              NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.f],
                              NSParagraphStyleAttributeName:[NSParagraphStyle defaultParagraphStyle],
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              // NSBackgroundColorAttributeName // default nil: no background
                              NSLigatureAttributeName:[NSNumber numberWithInteger:1], // default 1: default ligatures
                              NSKernAttributeName:[NSNumber numberWithFloat:0],
                              NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone], // default 0: no underline
                              NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone], // default 0: no underline
                              // NSStrokeColorAttributeName // default nil: same as foreground color
                              NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0], // default 0: no stroke
                              // NSShadowAttributeName // default nil
                              // NSTextEffectAttributeName // default nil
                              // NSAttachmentAttributeName // default nil
                              // NSLinkAttributeName // default nil
                              NSBaselineOffsetAttributeName:[NSNumber numberWithFloat:0], // default 0
                              // NSUnderlineColorAttributeName     // default nil: same as foreground color
                              // NSStrikethroughColorAttributeName // default nil: same as foreground color
                              NSObliquenessAttributeName:[NSNumber numberWithFloat:0], // default 0: no skew
                              NSExpansionAttributeName:[NSNumber numberWithFloat:0], // default 0: no expansion
                              NSWritingDirectionAttributeName:@[@(NSWritingDirectionLeftToRight|writingDirectionEmbedding)], // LRE
                              NSVerticalGlyphFormAttributeName:[NSNumber numberWithBool:0] // 0 means horizontal text.
                              };
    });
    return defaultAttributes;
}

- (NSRange)ch_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (NSUInteger)ch_lengthOfUsingNonASCIICharacterAsTwoEncoding {
    return self.string.ch_lengthOfUsingNonASCIICharacterAsTwoEncoding;
}

- (NSDictionary<NSString *, id> *)ch_attributesAtIndex:(NSUInteger)index {
    if (index >= self.length || self.length == 0) return @{};
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (NSDictionary<NSString *, id> *)ch_attributesInRange:(NSRange)range {
    NSAssert(CHNSRangeInRange(self.ch_rangeOfAll, range), @"The range, which to search for continuous presence of attributeName, must not exceed the bounds of the receiver.");
    
    __block NSMutableDictionary *attrs = @{}.mutableCopy;
    [self enumerateAttributesInRange:self.ch_rangeOfAll options:kNilOptions usingBlock:^(NSDictionary<NSString *,id> * _Nonnull subAttrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs) {
            [attrs addEntriesFromDictionary:subAttrs];
        }
    }];
    
    __weak typeof(attrs) weakAttrs = attrs;
    [attrs enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *attrName, id attr, BOOL * _Nonnull stop) {
        if (![self ch_attribute:attrName inRange:self.ch_rangeOfAll]) {
            [weakAttrs removeObjectForKey:attrName];
        }
    }];
    
    return attrs.copy;
}

- (NSDictionary<NSString *, id> *)ch_attributes {
    return [self ch_attributesInRange:self.ch_rangeOfAll];
}

- (id)ch_attribute:(NSString *)attrName atIndex:(NSUInteger)index {
    if (!attrName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attrName atIndex:index effectiveRange:NULL];
}

- (id)ch_attribute:(NSString *)attrName inRange:(NSRange)range {
    if (!attrName) return nil;
    NSAssert(CHNSRangeInRange(self.ch_rangeOfAll, range), @"The range, which to search for continuous presence of attributeName, must not exceed the bounds of the receiver.");
    
    NSRange effectiveRange = CHNSRangeZero;
    id attr = [self attribute:attrName atIndex:range.location longestEffectiveRange:&effectiveRange inRange:range];
    if (!attr) return nil;
    if (!NSEqualRanges(effectiveRange, range)) return nil;
    
    return attr;
}

- (id)ch_attribute:(NSString *)attrName {
    return [self ch_attribute:attrName inRange:self.ch_rangeOfAll];
}

#pragma mark - Drawing
- (CGSize)ch_boundingSizeForSize:(CGSize)size {
    CGRect result = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
    return result.size;
}

- (CGFloat)ch_boundingWidth {
    CGSize size = [self ch_boundingSizeForSize:CGSizeMake(HUGE, HUGE)];
    return size.width;
}

- (CGFloat)ch_boundingHeightForWidth:(CGFloat)width {
    CGSize size = [self ch_boundingSizeForSize:CGSizeMake(width, HUGE)];
    return size.height;
}

#pragma mark - Attributed Substrings
- (NSAttributedString *)ch_attributedSubstringToIndex:(NSUInteger)to {
    NSRange range = NSMakeRange(0, to);
    return [self attributedSubstringFromRange:range];
}

- (NSAttributedString *)ch_attributedSubstringFromIndex:(NSUInteger)from {
    NSRange range = NSMakeRange(from, self.string.length-from);
    return [self attributedSubstringFromRange:range];
}

#pragma mark - Check
- (BOOL)ch_containsRange:(NSRange)range {
    if (!self.string || !self.length) return NO;
    if (!CHNSRangeInRange(self.ch_rangeOfAll, range)) return NO;
    
    return YES;
}

- (BOOL)ch_isSharedAttributesInAllRange {
    __block BOOL isShared = YES;
    __block NSDictionary *firstAttrs = nil;
    [self enumerateAttributesInRange:self.ch_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (range.location == 0) {
            firstAttrs = attrs;
        } else {
            if (firstAttrs.count != attrs.count) {
                isShared = NO;
                *stop = YES;
            } else if (firstAttrs) {
                if (![firstAttrs isEqualToDictionary:attrs]) {
                    isShared = NO;
                    *stop = YES;
                }
            }
        }
    }];
    return isShared;
}

#pragma mark - Font
- (UIFont *)ch_fontAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSFontAttributeName atIndex:index];
}

- (UIFont *)ch_fontInRange:(NSRange)range {
    return [self ch_attribute:NSFontAttributeName inRange:range];
}

- (UIFont *)ch_font {
    return [self ch_attribute:NSFontAttributeName];
}

#pragma mark - Paragraph Style
- (NSParagraphStyle *)ch_paragraphStyleAtIndex:(NSUInteger)index {
    NSParagraphStyle *paragraphStyle = [self ch_attribute:NSParagraphStyleAttributeName atIndex:index];
    if (!paragraphStyle) {
        paragraphStyle = [NSParagraphStyle defaultParagraphStyle];
    }
    return paragraphStyle;
}

- (NSParagraphStyle *)ch_paragraphStyleInRange:(NSRange)range {
    return [self ch_attribute:NSParagraphStyleAttributeName inRange:range];
}

- (NSParagraphStyle *)ch_paragraphStyle {
    return [self ch_paragraphStyleInRange:self.ch_rangeOfAll];
}

#pragma mark - Foreground Color
- (UIColor *)ch_foregroundColorAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSForegroundColorAttributeName atIndex:index];
}

- (UIColor *)ch_foregroundColorInRange:(NSRange)range {
    return [self ch_attribute:NSForegroundColorAttributeName inRange:range];
}

- (UIColor *)ch_foregroundColor {
    return [self ch_attribute:NSForegroundColorAttributeName];
}

#pragma mark - Background Color
- (UIColor *)ch_backgroundColorAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSBackgroundColorAttributeName atIndex:index];
}

- (UIColor *)ch_backgroundColorInRange:(NSRange)range {
    return [self ch_attribute:NSBackgroundColorAttributeName inRange:range];
}

- (UIColor *)ch_backgroundColor {
    return [self ch_attribute:NSBackgroundColorAttributeName];
}

#pragma mark - Ligature
- (NSNumber *)ch_ligatureAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSLigatureAttributeName atIndex:index];
}

- (NSNumber *)ch_ligatureInRange:(NSRange)range {
    return [self ch_attribute:NSLigatureAttributeName inRange:range];
}

- (NSNumber *)ch_ligature {
    return [self ch_attribute:NSLigatureAttributeName];
}

#pragma mark - Kern
- (NSNumber *)ch_kernAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSKernAttributeName atIndex:index];
}

- (NSNumber *)ch_kernInRange:(NSRange)range {
    return [self ch_attribute:NSKernAttributeName inRange:range];
}

- (NSNumber *)ch_kern {
    return [self ch_attribute:NSKernAttributeName];
}

#pragma mark - Strikethrough Style
- (NSNumber *)ch_strikethroughStyleAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSStrikethroughStyleAttributeName atIndex:index];
}

- (NSNumber *)ch_strikethroughStyleInRange:(NSRange)range {
    return [self ch_attribute:NSStrikethroughStyleAttributeName inRange:range];
}

- (NSNumber *)ch_strikethroughStyle {
    return [self ch_attribute:NSStrikethroughStyleAttributeName];
}

#pragma mark - Underline Style
- (NSNumber *)ch_underlineStyleAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSUnderlineStyleAttributeName atIndex:index];
}

- (NSNumber *)ch_underlineStyleInRange:(NSRange)range {
    return [self ch_attribute:NSUnderlineStyleAttributeName inRange:range];
}

- (NSNumber *)ch_underlineStyle {
    return [self ch_attribute:NSUnderlineStyleAttributeName];
}

#pragma mark - Stroke Color
- (UIColor *)ch_strokeColorAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSStrokeColorAttributeName atIndex:index];
}

- (UIColor *)ch_strokeColorInRange:(NSRange)range {
    return [self ch_attribute:NSStrokeColorAttributeName inRange:range];
}

- (UIColor *)ch_strokeColor {
    return [self ch_attribute:NSStrokeColorAttributeName];
}

#pragma mark - Stroke Width
- (NSNumber *)ch_strokeWidthAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSStrokeWidthAttributeName atIndex:index];
}

- (NSNumber *)ch_strokeWidthInRange:(NSRange)range {
    return [self ch_attribute:NSStrokeWidthAttributeName inRange:range];
}

- (NSNumber *)ch_strokeWidth {
    return [self ch_attribute:NSStrokeWidthAttributeName];
}

#pragma mark - Shadow
- (NSShadow *)ch_shadowAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSShadowAttributeName atIndex:index];
}

- (NSShadow *)ch_shadowInRange:(NSRange)range {
    return [self ch_attribute:NSShadowAttributeName inRange:range];
}

- (NSShadow *)ch_shadow {
    return [self ch_attribute:NSShadowAttributeName];
}

#pragma mark - Text Effect
- (NSString *)ch_textEffectAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSTextEffectAttributeName atIndex:index];
}

- (NSString *)ch_textEffectInRange:(NSRange)range {
    return [self ch_attribute:NSTextEffectAttributeName inRange:range];
}

- (NSString *)ch_textEffect {
    return [self ch_attribute:NSTextEffectAttributeName];
}

#pragma mark - Attachment
- (NSTextAttachment *)ch_attachmentAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSAttachmentAttributeName atIndex:index];
}

- (NSTextAttachment *)ch_attachmentInRange:(NSRange)range {
    return [self ch_attribute:NSAttachmentAttributeName inRange:range];
}

- (NSTextAttachment *)ch_attachment {
    return [self ch_attribute:NSAttachmentAttributeName];
}

#pragma mark - Link
- (id)ch_linkAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSLinkAttributeName atIndex:index];
}

- (id)ch_linkInRange:(NSRange)range {
    return [self ch_attribute:NSLinkAttributeName inRange:range];
}

- (id)ch_link {
    return [self ch_attribute:NSLinkAttributeName];
}

#pragma mark - Baseline Offset
- (NSNumber *)ch_baselineOffsetAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSBaselineOffsetAttributeName atIndex:index];
}

- (NSNumber *)ch_baselineOffsetInRange:(NSRange)range {
    return [self ch_attribute:NSBaselineOffsetAttributeName inRange:range];
}

- (NSNumber *)ch_baselineOffset {
    return [self ch_attribute:NSBaselineOffsetAttributeName];
}

#pragma mark - Underline Color
- (UIColor *)ch_underlineColorAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSUnderlineColorAttributeName atIndex:index];
}

- (UIColor *)ch_underlineColorInRange:(NSRange)range {
    return [self ch_attribute:NSUnderlineColorAttributeName inRange:range];
}

- (UIColor *)ch_underlineColor {
    return [self ch_attribute:NSUnderlineColorAttributeName];
}

#pragma mark - Strikethrough Color
- (UIColor *)ch_strikethroughColorAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSStrikethroughColorAttributeName atIndex:index];
}

- (UIColor *)ch_strikethroughColorInRange:(NSRange)range {
    return [self ch_attribute:NSStrikethroughColorAttributeName inRange:range];
}

- (UIColor *)ch_strikethroughColor {
    return [self ch_attribute:NSStrikethroughColorAttributeName];
}

#pragma mark - Obliqueness
- (NSNumber *)ch_obliquenessAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSObliquenessAttributeName atIndex:index];
}

- (NSNumber *)ch_obliquenessInRange:(NSRange)range {
    return [self ch_attribute:NSObliquenessAttributeName inRange:range];
}

- (NSNumber *)ch_obliqueness {
    return [self ch_attribute:NSObliquenessAttributeName];
}

#pragma mark - Expansion
- (NSNumber *)ch_expansionAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSExpansionAttributeName atIndex:index];
}

- (NSNumber *)ch_expansionInRange:(NSRange)range {
    return [self ch_attribute:NSExpansionAttributeName inRange:range];
}

- (NSNumber *)ch_expansion {
    return [self ch_attribute:NSExpansionAttributeName];
}

#pragma mark - Writing Direction
- (NSArray<NSNumber *> *)ch_writingDirectionAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSWritingDirectionAttributeName atIndex:index];
}

- (NSArray<NSNumber *> *)ch_writingDirectionInRange:(NSRange)range {
    return [self ch_attribute:NSWritingDirectionAttributeName inRange:range];
}

- (NSArray<NSNumber *> *)ch_writingDirection {
    return [self ch_attribute:NSWritingDirectionAttributeName];
}

#pragma mark - Vertical Glyph Form
- (NSNumber *)ch_verticalGlyphFormAtIndex:(NSUInteger)index {
    return [self ch_attribute:NSVerticalGlyphFormAttributeName atIndex:index];
}

- (NSNumber *)ch_verticalGlyphFormInRange:(NSRange)range {
    return [self ch_attribute:NSVerticalGlyphFormAttributeName inRange:range];
}

- (NSNumber *)ch_verticalGlyphForm {
    return [self ch_attribute:NSVerticalGlyphFormAttributeName];
}

@end


@implementation NSMutableAttributedString (CHBase)

#pragma mark - Base
- (void)ch_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) {
        [self setAttributes:@{name:value} range:range];
    } else {
        [self removeAttribute:name range:range];
    }
}

- (void)ch_setAttribute:(NSString *)name value:(id)value {
    [self ch_setAttribute:name value:(id)value range:self.ch_rangeOfAll];
}

- (void)ch_setAttributes:(NSDictionary<NSString *, id> *)attrs {
    if (attrs == (id)[NSNull null]) attrs = nil;
    [self setAttributes:@{} range:self.ch_rangeOfAll];
    [attrs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self ch_setAttribute:key value:obj];
    }];
}

- (void)ch_addAttribute:(NSString *)name value:(id)value {
    [self addAttribute:name value:value range:self.ch_rangeOfAll];
}

- (void)ch_addAttributes:(NSDictionary<NSString *, id> *)attrs {
    if (attrs == (id)[NSNull null]) attrs = nil;
    [attrs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self ch_addAttribute:key value:obj];
    }];
}

- (void)ch_removeAttribute:(NSString *)name {
    [self removeAttribute:name range:self.ch_rangeOfAll];
}

- (void)ch_removeAttributes:(NSArray<NSString *> *)attrNames range:(NSRange)range {
    if (!attrNames || attrNames.count) return;
    
    for (NSString *attrName in attrNames) {
        [self removeAttribute:attrName range:range];
    }
}

- (void)ch_removeAttributes:(NSArray<NSString *> *)attrNames {
    [self ch_removeAttributes:attrNames range:self.ch_rangeOfAll];
}

- (void)ch_removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

- (void)ch_removeAttributes {
    [self setAttributes:nil range:self.ch_rangeOfAll];
}

- (void)ch_insertString:(NSString *)string atIndex:(NSUInteger)location {
    [self replaceCharactersInRange:NSMakeRange(location, 0) withString:string];
    [self ch_removeDiscontinuousAttributesInRange:NSMakeRange(location, string.length)];
}

- (void)ch_appendString:(NSString *)string {
    NSUInteger length = self.length;
    [self replaceCharactersInRange:NSMakeRange(length, 0) withString:string];
    [self ch_removeDiscontinuousAttributesInRange:NSMakeRange(length, string.length)];
}

- (void)ch_removeDiscontinuousAttributesInRange:(NSRange)range {
    NSArray *keys = [NSMutableAttributedString ch_allDiscontinuousAttributeKeys];
    for (NSString *key in keys) {
        [self removeAttribute:key range:range];
    }
}

+ (NSArray<NSString *> *)ch_allDiscontinuousAttributeKeys {
    static NSMutableArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[(id)kCTSuperscriptAttributeName,
                 (id)kCTRunDelegateAttributeName].mutableCopy;
        float version = [UIDevice currentDevice].systemVersion.floatValue;
        if (version >= 8) {
            [keys addObject:(id)kCTRubyAnnotationAttributeName];
        }
        if (version >= 7) {
            [keys addObject:NSAttachmentAttributeName];
        }
    });
    return keys.copy;
}

#pragma mark - Font
- (void)ch_setFont:(UIFont *)font range:(NSRange)range {
    [self ch_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)ch_setFont:(UIFont *)font {
    [self ch_setAttribute:NSFontAttributeName value:font];
}

- (void)ch_addFont:(UIFont *)font range:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (void)ch_addFont:(UIFont *)font {
    [self ch_addAttribute:NSFontAttributeName value:font];
}

- (void)ch_removeFontInRange:(NSRange)range {
    [self removeAttribute:NSFontAttributeName range:range];
}

- (void)ch_removeFont {
    [self ch_removeAttribute:NSFontAttributeName];
}

#pragma mark - Paragraph Style
- (void)ch_setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    [self ch_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

- (void)ch_setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    [self ch_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
}

- (void)ch_addParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

- (void)ch_addParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    [self ch_addAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
}

- (void)ch_removeParagraphStyleInRange:(NSRange)range {
    [self removeAttribute:NSParagraphStyleAttributeName range:range];
}

- (void)ch_removeParagraphStyle {
    [self ch_removeAttribute:NSParagraphStyleAttributeName];
}

#pragma mark - Foreground Color
- (void)ch_setForegroundColor:(UIColor *)color range:(NSRange)range
{
    [self ch_setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)ch_setForegroundColor:(UIColor *)color {
    [self ch_setAttribute:NSForegroundColorAttributeName value:color];
}

- (void)ch_addForegroundColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)ch_addForegroundColor:(UIColor *)color {
    [self ch_addAttribute:NSForegroundColorAttributeName value:color];
}

- (void)ch_removeForegroundColorInRange:(NSRange)range {
    [self removeAttribute:NSForegroundColorAttributeName range:range];
}

- (void)ch_removeForegroundColor {
    [self ch_removeAttribute:NSForegroundColorAttributeName];
}

#pragma mark - Background Color
- (void)ch_setBackgroundColor:(UIColor *)color range:(NSRange)range {
    [self ch_setAttribute:NSBackgroundColorAttributeName value:color range:range];
}

- (void)ch_setBackgroundColor:(UIColor *)color {
    [self ch_setAttribute:NSBackgroundColorAttributeName value:color];
}

- (void)ch_addBackgroundColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
}

- (void)ch_addBackgroundColor:(UIColor *)color {
    [self ch_addAttribute:NSBackgroundColorAttributeName value:color];
}

- (void)ch_removeBackgroundColorInRange:(NSRange)range {
    [self removeAttribute:NSBackgroundColorAttributeName range:range];
}

- (void)ch_removeBackgroundColor {
    [self ch_removeAttribute:NSBackgroundColorAttributeName];
}

#pragma mark - Ligature
- (void)ch_setLigature:(NSNumber *)ligature range:(NSRange)range {
    [self ch_setAttribute:NSLigatureAttributeName value:ligature range:range];
}

- (void)ch_setLigature:(NSNumber *)ligature {
    [self ch_setAttribute:NSLigatureAttributeName value:ligature];
}

- (void)ch_addLigature:(NSNumber *)ligature range:(NSRange)range {
    [self addAttribute:NSLigatureAttributeName value:ligature range:range];
}

- (void)ch_addLigature:(NSNumber *)ligature {
    [self ch_addAttribute:NSLigatureAttributeName value:ligature];
}

- (void)ch_removeLigatureInRange:(NSRange)range {
    [self removeAttribute:NSLigatureAttributeName range:range];
}

- (void)ch_removeLigature {
    [self ch_removeAttribute:NSLigatureAttributeName];
}

#pragma mark - Kern
- (void)ch_setKern:(NSNumber *)kern range:(NSRange)range {
    [self ch_setAttribute:NSKernAttributeName value:kern range:range];
}

- (void)ch_setKern:(NSNumber *)kern {
    [self ch_setAttribute:NSKernAttributeName value:kern];
}

- (void)ch_addKern:(NSNumber *)kern range:(NSRange)range {
    [self addAttribute:NSKernAttributeName value:kern range:range];
}

- (void)ch_addKern:(NSNumber *)kern {
    [self ch_addAttribute:NSKernAttributeName value:kern];
}

- (void)ch_removeKernInRange:(NSRange)range {
    [self removeAttribute:NSKernAttributeName range:range];
}

- (void)ch_removeKern {
    [self ch_removeAttribute:NSKernAttributeName];
}

#pragma mark - Strikethrough Style
- (void)ch_setStrikethroughStyle:(NSNumber *)strikethroughStyle range:(NSRange)range {
    [self ch_setAttribute:NSStrikethroughStyleAttributeName value:strikethroughStyle range:range];
}

- (void)ch_setStrikethroughStyle:(NSNumber *)strikethroughStyle {
    [self ch_setAttribute:NSStrikethroughStyleAttributeName value:strikethroughStyle];
}

- (void)ch_addStrikethroughStyle:(NSNumber *)strikethroughStyle range:(NSRange)range {
    [self addAttribute:NSStrikethroughStyleAttributeName value:strikethroughStyle range:range];
}

- (void)ch_addStrikethroughStyle:(NSNumber *)strikethroughStyle {
    [self ch_addAttribute:NSStrikethroughStyleAttributeName value:strikethroughStyle];
}

- (void)ch_removeStrikethroughStyleInRange:(NSRange)range {
    [self removeAttribute:NSStrikethroughStyleAttributeName range:range];
}

- (void)ch_removeStrikethroughStyle {
    [self ch_removeAttribute:NSStrikethroughStyleAttributeName];
}

#pragma mark - Underline Style
- (void)ch_setUnderlineStyle:(NSNumber *)underlineStyle range:(NSRange)range {
    [self ch_setAttribute:NSUnderlineStyleAttributeName value:underlineStyle range:range];
}

- (void)ch_setUnderlineStyle:(NSNumber *)underlineStyle {
    [self ch_setAttribute:NSUnderlineStyleAttributeName value:underlineStyle];
}

- (void)ch_addUnderlineStyle:(NSNumber *)underlineStyle range:(NSRange)range {
    [self addAttribute:NSUnderlineStyleAttributeName value:underlineStyle range:range];
}

- (void)ch_addUnderlineStyle:(NSNumber *)underlineStyle {
    [self ch_addAttribute:NSUnderlineStyleAttributeName value:underlineStyle];
}

- (void)ch_removeUnderlineStyleInRange:(NSRange)range {
    [self removeAttribute:NSUnderlineStyleAttributeName range:range];
}

- (void)ch_removeUnderlineStyle {
    [self ch_removeAttribute:NSUnderlineStyleAttributeName];
}

#pragma mark - Stroke Color
- (void)ch_setStrokeColor:(UIColor *)color range:(NSRange)range {
    [self ch_setAttribute:NSStrokeColorAttributeName value:color range:range];
}

- (void)ch_setStrokeColor:(UIColor *)color {
    [self ch_setAttribute:NSStrokeColorAttributeName value:color];
}

- (void)ch_addStrokeColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSStrokeColorAttributeName value:color range:range];
}

- (void)ch_addStrokeColor:(UIColor *)color {
    [self ch_addAttribute:NSStrokeColorAttributeName value:color];
}

- (void)ch_removeStrokeColorInRange:(NSRange)range {
    [self removeAttribute:NSStrokeColorAttributeName range:range];
}

- (void)ch_removeStrokeColor {
    [self ch_removeAttribute:NSStrokeColorAttributeName];
}

#pragma mark - Stroke Width
- (void)ch_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self ch_setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)ch_setStrokeWidth:(NSNumber *)strokeWidth {
    [self ch_setAttribute:NSStrokeWidthAttributeName value:strokeWidth];
}

- (void)ch_addStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self addAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)ch_addStrokeWidth:(NSNumber *)strokeWidth {
    [self ch_addAttribute:NSStrokeWidthAttributeName value:strokeWidth];
}

- (void)ch_removeStrokeWidthInRange:(NSRange)range {
    [self removeAttribute:NSStrokeWidthAttributeName range:range];
}

- (void)ch_removeStrokeWidth {
    [self ch_removeAttribute:NSStrokeWidthAttributeName];
}

#pragma mark - Shadow
- (void)ch_setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self ch_setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)ch_setShadow:(NSShadow *)shadow {
    [self ch_setAttribute:NSShadowAttributeName value:shadow];
}

- (void)ch_addShadow:(NSShadow *)shadow range:(NSRange)range {
    [self addAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)ch_addShadow:(NSShadow *)shadow {
    [self ch_addAttribute:NSShadowAttributeName value:shadow];
}

- (void)ch_removeShadowInRange:(NSRange)range {
    [self removeAttribute:NSShadowAttributeName range:range];
}

- (void)ch_removeShadow {
    [self ch_removeAttribute:NSShadowAttributeName];
}

#pragma mark - Text Effect
- (void)ch_setTextEffect:(NSString *)textEffect range:(NSRange)range {
    [self ch_setAttribute:NSTextEffectAttributeName value:textEffect range:range];
}

- (void)ch_setTextEffect:(NSString *)textEffect {
    [self ch_setAttribute:NSTextEffectAttributeName value:textEffect];
}

- (void)ch_addTextEffect:(NSString *)textEffect range:(NSRange)range {
    [self addAttribute:NSTextEffectAttributeName value:textEffect range:range];
}

- (void)ch_addTextEffect:(NSString *)textEffect {
    [self ch_addAttribute:NSTextEffectAttributeName value:textEffect];
}

- (void)ch_removeTextEffectInRange:(NSRange)range {
    [self removeAttribute:NSTextEffectAttributeName range:range];
}

- (void)ch_removeTextEffect {
    [self ch_removeAttribute:NSTextEffectAttributeName];
}

#pragma mark - Attachment
- (void)ch_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range {
    [self ch_setAttribute:NSAttachmentAttributeName value:attachment range:range];
}

- (void)ch_setAttachment:(NSTextAttachment *)attachment {
    [self ch_setAttribute:NSAttachmentAttributeName value:attachment];
}

- (void)ch_addAttachment:(NSTextAttachment *)attachment range:(NSRange)range {
    [self addAttribute:NSAttachmentAttributeName value:attachment range:range];
}

- (void)ch_addAttachment:(NSTextAttachment *)attachment {
    [self ch_addAttribute:NSAttachmentAttributeName value:attachment];
}

- (void)ch_removeAttachmentInRange:(NSRange)range {
    [self removeAttribute:NSAttachmentAttributeName range:range];
}

- (void)ch_removeAttachment {
    [self ch_removeAttribute:NSAttachmentAttributeName];
}

#pragma mark - Link
- (void)ch_setLink:(id)link range:(NSRange)range {
    [self ch_setAttribute:NSLinkAttributeName value:link range:range];
}

- (void)ch_setLink:(id)link {
    [self ch_setAttribute:NSLinkAttributeName value:link];
}

- (void)ch_addLink:(id)link range:(NSRange)range {
    [self addAttribute:NSLinkAttributeName value:link range:range];
}

- (void)ch_addLink:(id)link {
    [self ch_addAttribute:NSLinkAttributeName value:link];
}

- (void)ch_removeLinkInRange:(NSRange)range {
    [self removeAttribute:NSLinkAttributeName range:range];
}

- (void)ch_removeLink {
    [self ch_removeAttribute:NSLinkAttributeName];
}

#pragma mark - Baseline Offset
- (void)ch_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    [self ch_setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
}

- (void)ch_setBaselineOffset:(NSNumber *)baselineOffset {
    [self ch_setAttribute:NSBaselineOffsetAttributeName value:baselineOffset];
}

- (void)ch_addBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    [self addAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
}

- (void)ch_addBaselineOffset:(NSNumber *)baselineOffset {
    [self ch_addAttribute:NSBaselineOffsetAttributeName value:baselineOffset];
}

- (void)ch_removeBaselineOffsetInRange:(NSRange)range {
    [self removeAttribute:NSBaselineOffsetAttributeName range:range];
}

- (void)ch_removeBaselineOffset {
    [self ch_removeAttribute:NSBaselineOffsetAttributeName];
}

#pragma mark - Underline Color
- (void)ch_setUnderlineColor:(UIColor *)color range:(NSRange)range {
    [self ch_setAttribute:NSUnderlineColorAttributeName value:color range:range];
}

- (void)ch_setUnderlineColor:(UIColor *)color {
    [self ch_setAttribute:NSUnderlineColorAttributeName value:color];
}

- (void)ch_addUnderlineColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSUnderlineColorAttributeName value:color range:range];
}

- (void)ch_addUnderlineColor:(UIColor *)color {
    [self ch_addAttribute:NSUnderlineColorAttributeName value:color];
}

- (void)ch_removeUnderlineColorInRange:(NSRange)range {
    [self removeAttribute:NSUnderlineColorAttributeName range:range];
}

- (void)ch_removeUnderlineColor {
    [self ch_removeAttribute:NSUnderlineColorAttributeName];
}

#pragma mark - Strikethrough Color
- (void)ch_setStrikethroughColor:(UIColor *)color range:(NSRange)range {
    [self ch_setAttribute:NSStrikethroughColorAttributeName value:color range:range];
}

- (void)ch_setStrikethroughColor:(UIColor *)color {
    [self ch_setAttribute:NSStrikethroughColorAttributeName value:color];
}

- (void)ch_addStrikethroughColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSStrikethroughColorAttributeName value:color range:range];
}

- (void)ch_addStrikethroughColor:(UIColor *)color {
    [self ch_addAttribute:NSStrikethroughColorAttributeName value:color];
}

- (void)ch_removeStrikethroughColorInRange:(NSRange)range {
    [self removeAttribute:NSStrikethroughColorAttributeName range:range];
}

- (void)ch_removeStrikethroughColor {
    [self ch_removeAttribute:NSStrikethroughColorAttributeName];
}

#pragma mark - Obliqueness
- (void)ch_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    [self ch_setAttribute:NSObliquenessAttributeName value:obliqueness range:range];
}

- (void)ch_setObliqueness:(NSNumber *)obliqueness {
    [self ch_setAttribute:NSObliquenessAttributeName value:obliqueness];
}

- (void)ch_addObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    [self addAttribute:NSObliquenessAttributeName value:obliqueness range:range];
}

- (void)ch_addObliqueness:(NSNumber *)obliqueness {
    [self ch_addAttribute:NSObliquenessAttributeName value:obliqueness];
}

- (void)ch_removeObliquenessInRange:(NSRange)range {
    [self removeAttribute:NSObliquenessAttributeName range:range];
}

- (void)ch_removeObliqueness {
    [self ch_removeAttribute:NSObliquenessAttributeName];
}

#pragma mark - Expansion
- (void)ch_setExpansion:(NSNumber *)expansion range:(NSRange)range {
    [self ch_setAttribute:NSExpansionAttributeName value:expansion range:range];
}

- (void)ch_setExpansion:(NSNumber *)expansion {
    [self ch_setAttribute:NSExpansionAttributeName value:expansion];
}

- (void)ch_addExpansion:(NSNumber *)expansion range:(NSRange)range {
    [self addAttribute:NSExpansionAttributeName value:expansion range:range];
}

- (void)ch_addExpansion:(NSNumber *)expansion {
    [self ch_addAttribute:NSExpansionAttributeName value:expansion];
}

- (void)ch_removeExpansionInRange:(NSRange)range {
    [self removeAttribute:NSExpansionAttributeName range:range];
}

- (void)ch_removeExpansion {
    [self ch_removeAttribute:NSExpansionAttributeName];
}

#pragma mark - Writing Direction
- (void)ch_setWritingDirection:(NSArray<NSNumber *> *)writingDirection range:(NSRange)range {
    [self ch_setAttribute:NSWritingDirectionAttributeName value:writingDirection range:range];
}

- (void)ch_setWritingDirection:(NSArray<NSNumber *> *)writingDirection {
    [self ch_setAttribute:NSWritingDirectionAttributeName value:writingDirection];
}

- (void)ch_addWritingDirection:(NSArray<NSNumber *> *)writingDirection range:(NSRange)range {
    [self addAttribute:NSWritingDirectionAttributeName value:writingDirection range:range];
}

- (void)ch_addWritingDirection:(NSArray<NSNumber *> *)writingDirection {
    [self ch_addAttribute:NSWritingDirectionAttributeName value:writingDirection];
}

- (void)ch_removeWritingDirectionInRange:(NSRange)range {
    [self removeAttribute:NSWritingDirectionAttributeName range:range];
}

- (void)ch_removeWritingDirection {
    [self ch_removeAttribute:NSWritingDirectionAttributeName];
}

#pragma mark - Vertical Glyph Form
- (void)ch_setVerticalGlyphForm:(NSNumber *)verticalGlyphForm range:(NSRange)range {
    [self ch_setAttribute:NSVerticalGlyphFormAttributeName value:verticalGlyphForm range:range];
}

- (void)ch_setVerticalGlyphForm:(NSNumber *)verticalGlyphForm {
    [self ch_setAttribute:NSVerticalGlyphFormAttributeName value:verticalGlyphForm];
}

- (void)ch_addVerticalGlyphForm:(NSNumber *)verticalGlyphForm range:(NSRange)range {
    [self addAttribute:NSVerticalGlyphFormAttributeName value:verticalGlyphForm range:range];
}

- (void)ch_addVerticalGlyphForm:(NSNumber *)verticalGlyphForm {
    [self ch_addAttribute:NSVerticalGlyphFormAttributeName value:verticalGlyphForm];
}

- (void)ch_removeVerticalGlyphFormInRange:(NSRange)range {
    [self removeAttribute:NSVerticalGlyphFormAttributeName range:range];
}

- (void)ch_removeVerticalGlyphForm {
    [self ch_removeAttribute:NSVerticalGlyphFormAttributeName];
}

@end
