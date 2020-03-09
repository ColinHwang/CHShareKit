//
//  NSAttributedString+CHParagraphStyleAttributes.m
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//

#import "NSAttributedString+CHParagraphStyleAttributes.h"
#import "NSAttributedString+CHBase.h"

@implementation NSAttributedString (CHParagraphStyleAttributes)

#define CHParagraphStyleAttributeAtIndex(_attr_) \
NSParagraphStyle *paragraphstyle = [self ch_paragraphStyleAtIndex:index]; \
if (!paragraphstyle) paragraphstyle = [NSParagraphStyle defaultParagraphStyle]; \
return paragraphstyle. _attr_; \

#pragma mark - Line Spacing
- (CGFloat)ch_lineSpacingAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(lineSpacing);
}

#pragma mark - Paragraph Spacing
- (CGFloat)ch_paragraphSpacingAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(paragraphSpacing);
}

#pragma mark - Alignment
- (NSTextAlignment)ch_alignmentAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(alignment);
}

#pragma mark - Head Indent
- (CGFloat)ch_headIndentAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(headIndent);
}

#pragma mark - Tail Indent
- (CGFloat)ch_tailIndentAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(tailIndent);
}

#pragma mark - First Line Head Indent
- (CGFloat)ch_firstLineHeadIndentAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(firstLineHeadIndent);
}

#pragma mark - MinimumLine Height
- (CGFloat)ch_minimumLineHeightAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(minimumLineHeight);
}

#pragma mark - MaximumLine Height
- (CGFloat)ch_maximumLineHeightAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(maximumLineHeight);
}

#pragma mark - Line Break Mode
- (NSLineBreakMode)ch_lineBreakModeAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(lineBreakMode);
}

#pragma mark - Base Writing Direction
- (NSWritingDirection)ch_baseWritingDirectionAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(baseWritingDirection);
}

#pragma mark - Line Height Multiple
- (CGFloat)ch_lineHeightMultipleAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(lineHeightMultiple);
}

#pragma mark - Paragraph Spacing Before
- (CGFloat)ch_paragraphSpacingBeforeAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(paragraphSpacingBefore);
}

#pragma mark - Hyphenation Factor
- (float)ch_hyphenationFactorAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(hyphenationFactor);
}

#pragma mark - Tab Stops
- (NSArray<NSTextTab *> *)ch_tabStopsAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(tabStops);
}

#pragma mark - Default Tab Interval
- (CGFloat)ch_defaultTabIntervalAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(defaultTabInterval);
}

#pragma mark - Allows Default Tightening For Truncation
- (BOOL)ch_allowsDefaultTighteningForTruncationAtIndex:(NSUInteger)index {
    CHParagraphStyleAttributeAtIndex(allowsDefaultTighteningForTruncation);
}

#undef CHParagraphStyleAttributeAtIndex

@end


@implementation NSMutableAttributedString (CHParagraphStyleAttributes)

#define CHParagraphStyleSetAttributeInRange(_attr_) \
NSParagraphStyle *paragraphStyle = [self ch_paragraphStyleInRange:range]; \
NSMutableParagraphStyle *mutableParagraphStyle = nil; \
if (paragraphStyle) { \
if ([paragraphStyle isKindOfClass:[NSMutableParagraphStyle class]]) { \
mutableParagraphStyle = (id)paragraphStyle; \
} else { \
mutableParagraphStyle = paragraphStyle.mutableCopy; \
} \
} else { \
mutableParagraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
} \
if (mutableParagraphStyle. _attr_ != _attr_) mutableParagraphStyle. _attr_ = _attr_; \
[self ch_setParagraphStyle:mutableParagraphStyle range:range];

#define CHParagraphStyleAddAttributeInRange(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
inRange:range \
options:kNilOptions usingBlock:^(NSParagraphStyle *paragraphStyle, NSRange subRange, BOOL * _Nonnull stop) { \
NSMutableParagraphStyle *mutableParagraphStyle = nil; \
if (paragraphStyle) { \
if ([paragraphStyle isKindOfClass:[NSMutableParagraphStyle class]]) { \
mutableParagraphStyle = (id)paragraphStyle; \
} else { \
mutableParagraphStyle = paragraphStyle.mutableCopy; \
} \
} else { \
mutableParagraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
} \
if (mutableParagraphStyle. _attr_ != _attr_) mutableParagraphStyle. _attr_ = _attr_; \
[self addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle range:range]; \
}];

#define CHParagraphStyleRemoveAttributeInRange(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
inRange:range \
options:kNilOptions usingBlock:^(NSParagraphStyle *paragraphStyle, NSRange subRange, BOOL * _Nonnull stop) { \
NSMutableParagraphStyle *mutableParagraphStyle = nil; \
if (paragraphStyle) { \
if ([paragraphStyle isKindOfClass:[NSMutableParagraphStyle class]]) { \
mutableParagraphStyle = (id)paragraphStyle; \
} else { \
mutableParagraphStyle = paragraphStyle.mutableCopy; \
} \
} \
if (mutableParagraphStyle. _attr_ != [NSParagraphStyle defaultParagraphStyle]. _attr_) mutableParagraphStyle. _attr_ = [NSParagraphStyle defaultParagraphStyle]. _attr_; \
[self ch_setParagraphStyle:mutableParagraphStyle range:range]; \
}];

#pragma mark - Line Spacing
- (void)ch_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(lineSpacing);
}

- (void)ch_setLineSpacing:(CGFloat)lineSpacing {
    [self ch_setLineSpacing:lineSpacing range:self.ch_rangeOfAll];
}

- (void)ch_addLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(lineSpacing);
}

- (void)ch_addLineSpacing:(CGFloat)lineSpacing {
    [self ch_addLineSpacing:lineSpacing range:self.ch_rangeOfAll];
}

- (void)ch_removeLineSpacingInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(lineSpacing);
}

- (void)ch_removeLineSpacing {
    [self ch_removeLineSpacingInRange:self.ch_rangeOfAll];
}

#pragma mark - Paragraph Spacing
- (void)ch_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(paragraphSpacing);
}

- (void)ch_setParagraphSpacing:(CGFloat)paragraphSpacing {
    [self ch_setParagraphSpacing:paragraphSpacing range:self.ch_rangeOfAll];
}

- (void)ch_addParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(paragraphSpacing);
}

- (void)ch_addParagraphSpacing:(CGFloat)paragraphSpacing {
    [self ch_addParagraphSpacing:paragraphSpacing range:self.ch_rangeOfAll];
}

- (void)ch_removeParagraphSpacingInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(paragraphSpacing);
}

- (void)ch_removeParagraphSpacing {
    [self ch_removeParagraphSpacingInRange:self.ch_rangeOfAll];
}

#pragma mark - Alignment
- (void)ch_setAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(alignment);
}

- (void)ch_setAlignment:(NSTextAlignment)alignment {
    [self ch_setAlignment:alignment range:self.ch_rangeOfAll];
}

- (void)ch_addAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(alignment);
}

- (void)ch_addAlignment:(NSTextAlignment)alignment {
    [self ch_addAlignment:alignment range:self.ch_rangeOfAll];
}

- (void)ch_removeAlignmentInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(alignment);
}

- (void)ch_removeAlignment {
    [self ch_removeAlignmentInRange:self.ch_rangeOfAll];
}

#pragma mark - Head Indent
- (void)ch_setHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(headIndent);
}

- (void)ch_setHeadIndent:(CGFloat)headIndent {
    [self ch_setHeadIndent:headIndent range:self.ch_rangeOfAll];
}

- (void)ch_addHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(headIndent);
}

- (void)ch_addHeadIndent:(CGFloat)headIndent {
    [self ch_addHeadIndent:headIndent range:self.ch_rangeOfAll];
}

- (void)ch_removeHeadIndentInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(headIndent);
}

- (void)ch_removeHeadIndent {
    [self ch_removeHeadIndentInRange:self.ch_rangeOfAll];
}

#pragma mark - Tail Indent
- (void)ch_setTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(tailIndent);
}

- (void)ch_setTailIndent:(CGFloat)tailIndent {
    [self ch_setTailIndent:tailIndent range:self.ch_rangeOfAll];
}

- (void)ch_addTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(tailIndent);
}

- (void)ch_addTailIndent:(CGFloat)tailIndent {
    [self ch_addTailIndent:tailIndent range:self.ch_rangeOfAll];
}

- (void)ch_removeTailIndentInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(tailIndent);
}

- (void)ch_removeTailIndent {
    [self ch_removeTailIndentInRange:self.ch_rangeOfAll];
}

#pragma mark - First Line Head Indent
- (void)ch_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(firstLineHeadIndent);
}

- (void)ch_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self ch_setFirstLineHeadIndent:firstLineHeadIndent range:self.ch_rangeOfAll];
}

- (void)ch_addFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(firstLineHeadIndent);
}

- (void)ch_addFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self ch_addFirstLineHeadIndent:firstLineHeadIndent range:self.ch_rangeOfAll];
}

- (void)ch_removeFirstLineHeadIndentInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(firstLineHeadIndent);
}

- (void)ch_removeFirstLineHeadIndent {
    [self ch_removeFirstLineHeadIndentInRange:self.ch_rangeOfAll];
}

#pragma mark - Minimum Line Height
- (void)ch_setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(minimumLineHeight);
}

- (void)ch_setMinimumLineHeight:(CGFloat)minimumLineHeight {
    [self ch_setMinimumLineHeight:minimumLineHeight range:self.ch_rangeOfAll];
}

- (void)ch_addMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(minimumLineHeight);
}

- (void)ch_addMinimumLineHeight:(CGFloat)minimumLineHeight {
    [self ch_addMinimumLineHeight:minimumLineHeight range:self.ch_rangeOfAll];
}

- (void)ch_removeMinimumLineHeightInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(minimumLineHeight);
}

- (void)ch_removeMinimumLineHeight {
    [self ch_removeMinimumLineHeightInRange:self.ch_rangeOfAll];
}

#pragma mark - Maximum Line Height
- (void)ch_setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(maximumLineHeight);
}

- (void)ch_setMaximumLineHeight:(CGFloat)maximumLineHeight {
    [self ch_setMaximumLineHeight:maximumLineHeight range:self.ch_rangeOfAll];
}

- (void)ch_addMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(maximumLineHeight);
}

- (void)ch_addMaximumLineHeight:(CGFloat)maximumLineHeight {
    [self ch_addMaximumLineHeight:maximumLineHeight range:self.ch_rangeOfAll];
}

- (void)ch_removeMaximumLineHeightInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(maximumLineHeight);
}

- (void)ch_removeMaximumLineHeight {
    [self ch_removeMaximumLineHeightInRange:self.ch_rangeOfAll];
}

#pragma mark - Line Break Mode
- (void)ch_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(lineBreakMode);
}

- (void)ch_setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self ch_setLineBreakMode:lineBreakMode range:self.ch_rangeOfAll];
}

- (void)ch_addLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(lineBreakMode);
}

- (void)ch_addLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self ch_addLineBreakMode:lineBreakMode range:self.ch_rangeOfAll];
}

- (void)ch_removeLineBreakModeInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(lineBreakMode);
}

- (void)ch_removeLineBreakMode {
    [self ch_removeLineBreakModeInRange:self.ch_rangeOfAll];
}

#pragma mark - Base Writing Direction
- (void)ch_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(baseWritingDirection);
}

- (void)ch_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [self ch_setBaseWritingDirection:baseWritingDirection range:self.ch_rangeOfAll];
}

- (void)ch_addBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(baseWritingDirection);
}

- (void)ch_addBaseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [self ch_addBaseWritingDirection:baseWritingDirection range:self.ch_rangeOfAll];
}

- (void)ch_removeBaseWritingDirectionInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(baseWritingDirection);
}

- (void)ch_removeBaseWritingDirection {
    [self ch_removeBaseWritingDirectionInRange:self.ch_rangeOfAll];
}

#pragma mark - Line Height Multiple
- (void)ch_setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(lineHeightMultiple);
}

- (void)ch_setLineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self ch_setLineHeightMultiple:lineHeightMultiple range:self.ch_rangeOfAll];
}

- (void)ch_addLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(lineHeightMultiple);
}

- (void)ch_addLineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self ch_addLineHeightMultiple:lineHeightMultiple range:self.ch_rangeOfAll];
}

- (void)ch_removeLineHeightMultipleInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(lineHeightMultiple);
}

- (void)ch_removeLineHeightMultiple {
    [self ch_removeLineHeightMultipleInRange:self.ch_rangeOfAll];
}

#pragma mark - Paragraph Spacing Before
- (void)ch_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(paragraphSpacingBefore);
}

- (void)ch_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self ch_setParagraphSpacingBefore:paragraphSpacingBefore range:self.ch_rangeOfAll];
}

- (void)ch_addParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(paragraphSpacingBefore);
}

- (void)ch_addParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self ch_addParagraphSpacingBefore:paragraphSpacingBefore range:self.ch_rangeOfAll];
}

- (void)ch_removeParagraphSpacingBeforeInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(paragraphSpacingBefore);
}

- (void)ch_removeParagraphSpacingBefore {
    [self ch_removeParagraphSpacingBeforeInRange:self.ch_rangeOfAll];
}

#pragma mark - Hyphenation Factor
- (void)ch_setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(hyphenationFactor);
}

- (void)ch_setHyphenationFactor:(float)hyphenationFactor {
    [self ch_setHyphenationFactor:hyphenationFactor range:self.ch_rangeOfAll];
}

- (void)ch_addHyphenationFactor:(float)hyphenationFactor range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(hyphenationFactor);
}

- (void)ch_addHyphenationFactor:(float)hyphenationFactor {
    [self ch_addHyphenationFactor:hyphenationFactor range:self.ch_rangeOfAll];
}

- (void)ch_removeHyphenationFactorInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(hyphenationFactor);
}

- (void)ch_removeHyphenationFactor {
    [self ch_removeHyphenationFactorInRange:self.ch_rangeOfAll];
}

#pragma mark - Tab Stops
- (void)ch_setTabStops:(NSArray<NSTextTab *> *)tabStops range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(tabStops);
}

- (void)ch_setTabStops:(NSArray<NSTextTab *> *)tabStops {
    [self ch_setTabStops:tabStops range:self.ch_rangeOfAll];
}

- (void)ch_addTabStops:(NSArray<NSTextTab *> *)tabStops range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(tabStops);
}

- (void)ch_addTabStops:(NSArray<NSTextTab *> *)tabStops {
    [self ch_addTabStops:tabStops range:self.ch_rangeOfAll];
}

- (void)ch_removeTabStopsInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(tabStops);
}

- (void)ch_removeTabStops {
    [self ch_removeTabStopsInRange:self.ch_rangeOfAll];
}

#pragma mark - Default Tab Interval
- (void)ch_setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(defaultTabInterval);
}

- (void)ch_setDefaultTabInterval:(CGFloat)defaultTabInterval {
    [self ch_setDefaultTabInterval:defaultTabInterval range:self.ch_rangeOfAll];
}

- (void)ch_addDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(defaultTabInterval);
}

- (void)ch_addDefaultTabInterval:(CGFloat)defaultTabInterval {
    [self ch_addDefaultTabInterval:defaultTabInterval range:self.ch_rangeOfAll];
}

- (void)ch_removeDefaultTabIntervalInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(defaultTabInterval);
}

- (void)ch_removeDefaultTabInterval {
    [self ch_removeDefaultTabIntervalInRange:self.ch_rangeOfAll];
}

#pragma mark - Allows Default Tightening For Truncation
- (void)ch_setAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation range:(NSRange)range {
    CHParagraphStyleSetAttributeInRange(allowsDefaultTighteningForTruncation);
}

- (void)ch_setAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation {
    [self ch_setAllowsDefaultTighteningForTruncation:allowsDefaultTighteningForTruncation range:self.ch_rangeOfAll];
}

- (void)ch_addAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation range:(NSRange)range {
    CHParagraphStyleAddAttributeInRange(allowsDefaultTighteningForTruncation);
}

- (void)ch_addAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation {
    [self ch_addAllowsDefaultTighteningForTruncation:allowsDefaultTighteningForTruncation range:self.ch_rangeOfAll];
}

- (void)ch_removeAllowsDefaultTighteningForTruncationInRange:(NSRange)range {
    CHParagraphStyleRemoveAttributeInRange(allowsDefaultTighteningForTruncation);
}

- (void)ch_removeAllowsDefaultTighteningForTruncation {
    [self ch_removeAllowsDefaultTighteningForTruncationInRange:self.ch_rangeOfAll];
}

#undef CHParagraphStyleSetAttributeInRange
#undef CHParagraphStyleAddAttributeInRange
#undef CHParagraphStyleRemoveAttributeInRange

@end
