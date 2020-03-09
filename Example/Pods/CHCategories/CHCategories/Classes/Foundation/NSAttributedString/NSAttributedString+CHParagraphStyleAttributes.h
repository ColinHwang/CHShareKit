//
//  NSAttributedString+CHParagraphStyleAttributes.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (CHParagraphStyleAttributes)

#pragma mark - Line Spacing
/**
 获取索引位置NSAttributedString的ParagraphStyle的行间距, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的行间距, 若无返回默认值
 */
- (CGFloat)ch_lineSpacingAtIndex:(NSUInteger)index;

#pragma mark - Paragraph Spacing
/**
 获取索引位置NSAttributedString的ParagraphStyle的段落间距, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的段落间距, 若无返回默认值
 */
- (CGFloat)ch_paragraphSpacingAtIndex:(NSUInteger)index;

#pragma mark - Alignment
/**
 获取索引位置NSAttributedString的ParagraphStyle的对齐方式, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的对齐方式, 若无返回默认值
 */
- (NSTextAlignment)ch_alignmentAtIndex:(NSUInteger)index;

#pragma mark - Head Indent
/**
 获取索引位置NSAttributedString的ParagraphStyle的整体首部缩进值, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的整体首部缩进值, 若无返回默认值
 */
- (CGFloat)ch_headIndentAtIndex:(NSUInteger)index;

#pragma mark - Tail Indent
/**
 获取索引位置NSAttributedString的ParagraphStyle的整体尾部缩进值, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的整体尾部缩进值, 若无返回默认值
 */
- (CGFloat)ch_tailIndentAtIndex:(NSUInteger)index;

#pragma mark - First Line Head Indent
/**
 获取索引位置NSAttributedString的ParagraphStyle的首行缩进值, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的首行缩进值, 若无返回默认值
 */
- (CGFloat)ch_firstLineHeadIndentAtIndex:(NSUInteger)index;

#pragma mark - MinimumLine Height
/**
 获取索引位置NSAttributedString的ParagraphStyle的最小行高, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的最小行高, 若无返回默认值
 */
- (CGFloat)ch_minimumLineHeightAtIndex:(NSUInteger)index;

#pragma mark - MaximumLine Height
/**
 获取索引位置NSAttributedString的ParagraphStyle的最大行高, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的最大行高, 若无返回默认值
 */
- (CGFloat)ch_maximumLineHeightAtIndex:(NSUInteger)index;

#pragma mark - Line Break Mode
/**
 获取索引位置NSAttributedString的ParagraphStyle的分割模式, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的分割模式, 若无返回默认值
 */
- (NSLineBreakMode)ch_lineBreakModeAtIndex:(NSUInteger)index;

#pragma mark - Base Writing Direction
/**
 获取索引位置NSAttributedString的ParagraphStyle的基础书写方向, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的基础书写方向, 若无返回默认值
 */
- (NSWritingDirection)ch_baseWritingDirectionAtIndex:(NSUInteger)index;

#pragma mark - Line Height Multiple
/**
 获取索引位置NSAttributedString的ParagraphStyle的行高倍数, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的行高倍数, 若无返回默认值
 */
- (CGFloat)ch_lineHeightMultipleAtIndex:(NSUInteger)index;

#pragma mark - Paragraph Spacing Before
/**
 获取索引位置NSAttributedString的ParagraphStyle的段落头部空白, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的段落头部空白, 若无返回默认值
 */
- (CGFloat)ch_paragraphSpacingBeforeAtIndex:(NSUInteger)index;

#pragma mark - Hyphenation Factor
/**
 获取索引位置NSAttributedString的ParagraphStyle的连字系数(0.0/1.0), 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的连字系数(0.0/1.0), 若无返回默认值
 */
- (float)ch_hyphenationFactorAtIndex:(NSUInteger)index;

#pragma mark - Tab Stops
/**
 获取索引位置NSAttributedString的ParagraphStyle的TabStops, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的TabStops, 若无返回默认值
 */
- (NSArray<NSTextTab *> *)ch_tabStopsAtIndex:(NSUInteger)index;

#pragma mark - Default Tab Interval
/**
 获取索引位置NSAttributedString的ParagraphStyle的默认Tab宽度, 若无返回默认值
 
 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的默认Tab宽度, 若无返回默认值
 */
- (CGFloat)ch_defaultTabIntervalAtIndex:(NSUInteger)index;

#pragma mark - Allows Default Tightening For Truncation
/**
 获取索引位置NSAttributedString的ParagraphStyle的默认收缩字符间距允许截断值

 @param index 索引位置(从0开始)
 @return 索引位置NSAttributedString的ParagraphStyle的默认收缩字符间距允许截断值, 若无返回默认值
 */
- (BOOL)ch_allowsDefaultTighteningForTruncationAtIndex:(NSUInteger)index NS_AVAILABLE(10_11, 9_0);

@end


@interface NSMutableAttributedString (CHParagraphStyleAttributes)

#pragma mark - Line Spacing
/**
 根据行间距及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param lineSpacing 行间距
 @param range 设置范围
 */
- (void)ch_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;

/**
 根据行间距, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param lineSpacing 行间距
 */
- (void)ch_setLineSpacing:(CGFloat)lineSpacing;

/**
 根据行间距及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param lineSpacing 行间距
 @param range 设置范围
 */
- (void)ch_addLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;

/**
 根据行间距, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param lineSpacing 行间距
 */
- (void)ch_addLineSpacing:(CGFloat)lineSpacing;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的行间距属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeLineSpacingInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的行间距属性(默认值)
 */
- (void)ch_removeLineSpacing;

#pragma mark - Paragraph Spacing
/**
 根据段落间距及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param paragraphSpacing 段落间距
 @param range 设置范围
 */
- (void)ch_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;

/**
 根据段落间距, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param paragraphSpacing 段落间距
 */
- (void)ch_setParagraphSpacing:(CGFloat)paragraphSpacing;

/**
 根据段落间距及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param paragraphSpacing 段落间距
 @param range 设置范围
 */
- (void)ch_addParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;

/**
 根据段落间距, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param paragraphSpacing 段落间距
 */
- (void)ch_addParagraphSpacing:(CGFloat)paragraphSpacing;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的段落间距属性(默认值)
 
 @param range 设置范围
 */
- (void)ch_removeParagraphSpacingInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的段落间距属性(默认值)
 */
- (void)ch_removeParagraphSpacing;

#pragma mark - Alignment
/**
 根据对齐方式及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param alignment 对齐方式
 @param range 设置范围
 */
- (void)ch_setAlignment:(NSTextAlignment)alignment range:(NSRange)range;

/**
 根据对齐方式, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param alignment 对齐方式
 */
- (void)ch_setAlignment:(NSTextAlignment)alignment;

/**
 根据对齐方式及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param alignment 对齐方式
 @param range 设置范围
 */
- (void)ch_addAlignment:(NSTextAlignment)alignment range:(NSRange)range;

/**
 根据对齐方式, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param alignment 对齐方式
 */
- (void)ch_addAlignment:(NSTextAlignment)alignment;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的对齐方式属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeAlignmentInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的对齐方式属性(默认值)
 */
- (void)ch_removeAlignment;

#pragma mark - Head Indent
/**
 根据整体首部缩进值及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param headIndent 整体首部缩进值
 @param range 设置范围
 */
- (void)ch_setHeadIndent:(CGFloat)headIndent range:(NSRange)range;

/**
 根据整体首部缩进值, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param headIndent 整体首部缩进值
 */
- (void)ch_setHeadIndent:(CGFloat)headIndent;

/**
 根据整体首部缩进值及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param headIndent 整体首部缩进值
 @param range 设置范围
 */
- (void)ch_addHeadIndent:(CGFloat)headIndent range:(NSRange)range;

/**
 根据整体首部缩进值, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param headIndent 整体首部缩进值
 */
- (void)ch_addHeadIndent:(CGFloat)headIndent;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的整体首部缩进属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeHeadIndentInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的整体首部缩进属性(默认值)
 */
- (void)ch_removeHeadIndent;

#pragma mark - Tail Indent
/**
 根据整体尾部缩进值及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param tailIndent 整体尾部缩进值
 @param range 设置范围
 */
- (void)ch_setTailIndent:(CGFloat)tailIndent range:(NSRange)range;

/**
 根据整体尾部缩进值, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param tailIndent 整体尾部缩进值
 */
- (void)ch_setTailIndent:(CGFloat)tailIndent;

/**
 根据整体尾部缩进值及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param tailIndent 整体尾部缩进值
 @param range 设置范围
 */
- (void)ch_addTailIndent:(CGFloat)tailIndent range:(NSRange)range;

/**
 根据整体尾部缩进值, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param tailIndent 整体尾部缩进值
 */
- (void)ch_addTailIndent:(CGFloat)tailIndent;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的整体尾部缩进属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeTailIndentInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的整体尾部缩进属性(默认值)
 */
- (void)ch_removeTailIndent;

#pragma mark - First Line Head Indent
/**
 根据首行缩进值及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param firstLineHeadIndent 首行缩进值
 @param range 设置范围
 */
- (void)ch_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range;

/**
 根据首行缩进值, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param firstLineHeadIndent 首行缩进值
 */
- (void)ch_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent;

/**
 根据首行缩进值及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param firstLineHeadIndent 首行缩进值
 @param range 设置范围
 */
- (void)ch_addFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range;

/**
 根据首行缩进值, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param firstLineHeadIndent 首行缩进值
 */
- (void)ch_addFirstLineHeadIndent:(CGFloat)firstLineHeadIndent;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的首行缩进属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeFirstLineHeadIndentInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的首行缩进属性(默认值)
 */
- (void)ch_removeFirstLineHeadIndent;

#pragma mark - Minimum Line Height
/**
 根据最小行高及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param minimumLineHeight 最小行高
 @param range 设置范围
 */
- (void)ch_setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range;

/**
 根据最小行高, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param minimumLineHeight 最小行高
 */
- (void)ch_setMinimumLineHeight:(CGFloat)minimumLineHeight;

/**
 根据最小行高及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param minimumLineHeight 最小行高
 @param range 设置范围
 */
- (void)ch_addMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range;

/**
 根据最小行高, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param minimumLineHeight 最小行高
 */
- (void)ch_addMinimumLineHeight:(CGFloat)minimumLineHeight;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的最小行高属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeMinimumLineHeightInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的最小行高属性(默认值)
 */
- (void)ch_removeMinimumLineHeight;

#pragma mark - Maximum Line Height
/**
 根据最大行高及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param maximumLineHeight 最大行高
 @param range 设置范围
 */
- (void)ch_setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range;

/**
 根据最大行高, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param maximumLineHeight 最大行高
 */
- (void)ch_setMaximumLineHeight:(CGFloat)maximumLineHeight;

/**
 根据最大行高及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param maximumLineHeight 最大行高
 @param range 设置范围
 */
- (void)ch_addMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range;

/**
 根据最大行高, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param maximumLineHeight 最大行高
 */
- (void)ch_addMaximumLineHeight:(CGFloat)maximumLineHeight;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的最大行高属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeMaximumLineHeightInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的最大行高属性(默认值)
 */
- (void)ch_removeMaximumLineHeight;

#pragma mark - Line Break Mode
/**
 根据分割模式及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param lineBreakMode 分割模式
 @param range 设置范围
 */
- (void)ch_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

/**
 根据分割模式, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param lineBreakMode 分割模式
 */
- (void)ch_setLineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 根据分割模式及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param lineBreakMode 分割模式
 @param range 设置范围
 */
- (void)ch_addLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

/**
 根据分割模式, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param lineBreakMode 分割模式
 */
- (void)ch_addLineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的分割模式属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeLineBreakModeInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的分割模式属性(默认值)
 */
- (void)ch_removeLineBreakMode;

#pragma mark - Base Writing Direction
/**
 根据基础书写方向及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param baseWritingDirection 基础书写方向
 @param range 设置范围
 */
- (void)ch_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range;

/**
 根据基础书写方向, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param baseWritingDirection 基础书写方向
 */
- (void)ch_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection;

/**
 根据基础书写方向及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param baseWritingDirection 基础书写方向
 @param range 设置范围
 */
- (void)ch_addBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range;

/**
 根据基础书写方向, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param baseWritingDirection 基础书写方向
 */
- (void)ch_addBaseWritingDirection:(NSWritingDirection)baseWritingDirection;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的基础书写方向属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeBaseWritingDirectionInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的基础书写方向属性(默认值)
 */
- (void)ch_removeBaseWritingDirection;

#pragma mark - Line Height Multiple
/**
 根据行高倍数及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param lineHeightMultiple 行高倍数
 @param range 设置范围
 */
- (void)ch_setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range;

/**
 根据行高倍数, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param lineHeightMultiple 行高倍数
 */
- (void)ch_setLineHeightMultiple:(CGFloat)lineHeightMultiple;

/**
 根据行高倍数及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param lineHeightMultiple 行高倍数
 @param range 设置范围
 */
- (void)ch_addLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range;

/**
 根据行高倍数, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param lineHeightMultiple 行高倍数
 */
- (void)ch_addLineHeightMultiple:(CGFloat)lineHeightMultiple;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的行高倍数属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeLineHeightMultipleInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的行高倍数属性(默认值)
 */
- (void)ch_removeLineHeightMultiple;

#pragma mark - Paragraph Spacing Before
/**
 根据段落头部空白及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param paragraphSpacingBefore 段落头部空白
 @param range 设置范围
 */
- (void)ch_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range;

/**
 根据段落头部空白, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param paragraphSpacingBefore 段落头部空白
 */
- (void)ch_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore;

/**
 根据段落头部空白及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param paragraphSpacingBefore 段落头部空白
 @param range 设置范围
 */
- (void)ch_addParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range;

/**
 根据段落头部空白, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param paragraphSpacingBefore 段落头部空白
 */
- (void)ch_addParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的段落头部空白属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeParagraphSpacingBeforeInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的段落头部空白属性(默认值)
 */
- (void)ch_removeParagraphSpacingBefore;

#pragma mark - Hyphenation Factor
/**
 根据连字系数(0.0/1.0)及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param hyphenationFactor 连字系数(0.0/1.0)
 @param range 设置范围
 */
- (void)ch_setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range;

/**
 根据连字系数(0.0/1.0), 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param hyphenationFactor 连字系数(0.0/1.0)
 */
- (void)ch_setHyphenationFactor:(float)hyphenationFactor;

/**
 根据连字系数(0.0/1.0)及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param hyphenationFactor 连字系数(0.0/1.0)
 @param range 设置范围
 */
- (void)ch_addHyphenationFactor:(float)hyphenationFactor range:(NSRange)range;

/**
 根据连字系数(0.0/1.0), 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param hyphenationFactor 连字系数(0.0/1.0)
 */
- (void)ch_addHyphenationFactor:(float)hyphenationFactor ;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的连字系数属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeHyphenationFactorInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的连字系数属性(默认值)
 */
- (void)ch_removeHyphenationFactor;

#pragma mark - Tab Stops
/**
 根据TabStops及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param tabStops TabStops
 @param range 设置范围
 */
- (void)ch_setTabStops:(NSArray<NSTextTab *> *)tabStops range:(NSRange)range;

/**
 根据TabStops, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param tabStops TabStops
 */
- (void)ch_setTabStops:(NSArray<NSTextTab *> *)tabStops;

/**
 根据TabStops及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param tabStops TabStops
 @param range 设置范围
 */
- (void)ch_addTabStops:(NSArray<NSTextTab *> *)tabStops range:(NSRange)range;

/**
 根据TabStops, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param tabStops TabStops
 */
- (void)ch_addTabStops:(NSArray<NSTextTab *> *)tabStops;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的TabStops属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeTabStopsInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的TabStops属性(默认值)
 */
- (void)ch_removeTabStops;

#pragma mark - Default Tab Interval
/**
 根据默认Tab宽度及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param defaultTabInterval 默认Tab宽度
 @param range 设置范围
 */
- (void)ch_setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range;

/**
 根据默认Tab宽度, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param defaultTabInterval 默认Tab宽度
 */
- (void)ch_setDefaultTabInterval:(CGFloat)defaultTabInterval;

/**
 根据默认Tab宽度及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param defaultTabInterval 默认Tab宽度
 @param range 设置范围
 */
- (void)ch_addDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range;

/**
 根据默认Tab宽度, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param defaultTabInterval 默认Tab宽度
 */
- (void)ch_addDefaultTabInterval:(CGFloat)defaultTabInterval;

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的默认Tab宽度属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeDefaultTabIntervalInRange:(NSRange)range;

/**
 移除NSMutableAttributedString的ParagraphStyle的默认Tab宽度属性(默认值)
 */
- (void)ch_removeDefaultTabInterval;

#pragma mark - Allows Default Tightening For Truncation
/**
 根据默认收缩字符间距允许截断值及设置范围, 设置NSMutableAttributedString的ParagraphStyle属性(替代编辑)
 
 @param allowsDefaultTighteningForTruncation 默认收缩字符间距允许截断值
 @param range 设置范围
 */
- (void)ch_setAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation range:(NSRange)range NS_AVAILABLE(10_11, 9_0);

/**
 根据默认收缩字符间距允许截断值, 设置NSMutableAttributedString的ParagraphStyle属性(全范围设置, 替代编辑)
 
 @param allowsDefaultTighteningForTruncation 默认收缩字符间距允许截断值
 */
- (void)ch_setAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation NS_AVAILABLE(10_11, 9_0);

/**
 根据默认收缩字符间距允许截断值及设置范围, 添加NSMutableAttributedString的ParagraphStyle属性(增量编辑)
 
 @param allowsDefaultTighteningForTruncation 默认收缩字符间距允许截断值
 @param range 设置范围
 */
- (void)ch_addAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation range:(NSRange)range NS_AVAILABLE(10_11, 9_0);

/**
 根据默认收缩字符间距允许截断值, 添加NSMutableAttributedString的ParagraphStyle属性(全范围设置, 增量编辑)
 
 @param allowsDefaultTighteningForTruncation 默认收缩字符间距允许截断值
 */
- (void)ch_addAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation NS_AVAILABLE(10_11, 9_0);

/**
 根据移除范围, 移除NSMutableAttributedString的ParagraphStyle的默认收缩字符间距允许截断属性(默认值)
 
 @param range 移除范围
 */
- (void)ch_removeAllowsDefaultTighteningForTruncationInRange:(NSRange)range NS_AVAILABLE(10_11, 9_0);

/**
 移除NSMutableAttributedString的ParagraphStyle的默认收缩字符间距允许截断属性(默认值)
 */
- (void)ch_removeAllowsDefaultTighteningForTruncation NS_AVAILABLE(10_11, 9_0);

@end

NS_ASSUME_NONNULL_END
