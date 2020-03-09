//
//  UITextField+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/10.
//
//

#import "UITextField+CHBase.h"
#import "NSObject+CHBase.h"

static const int CH_UI_TEXT_FIELD_LIMIT_MAX_LENGTH_KEY;

@interface UITextField ()

@property (nonatomic, strong) UILabel *_ch_ui_placeholderLabel;

@end

@implementation UITextField (CHBase)

#pragma mark - Base
- (UIButton *)ch_clearButton {
    return [self valueForKey:@"clearButton"];
}

- (void)setCh_clearButtonImage:(UIImage *)ch_clearButtonImage {
    [self.ch_clearButton setImage:ch_clearButtonImage forState:UIControlStateNormal];
}

- (UIImage *)ch_clearButtonImage {
    return [self.ch_clearButton imageForState:UIControlStateNormal];
}

- (void)setCh_selectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument; // (0-3)
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location]; // (0-1)
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)]; // (0-2)
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition]; // (1-2)
    [self setSelectedTextRange:selectionRange];
}

- (NSRange)ch_selectedRange {
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];
    return NSMakeRange(location, length);
}

- (void)ch_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (UILabel *)_ch_placeholderLabel {
    return [self valueForKey:@"_placeholderLabel"];
}

- (void)setCh_adjustsPlaceholderFontSizeToFitWidth:(BOOL)ch_adjustsPlaceholderFontSizeToFitWidth {
    self._ch_placeholderLabel.adjustsFontSizeToFitWidth = ch_adjustsPlaceholderFontSizeToFitWidth;
}

- (BOOL)ch_adjustsPlaceholderFontSizeToFitWidth {
    return self._ch_placeholderLabel.adjustsFontSizeToFitWidth;
}

- (void)ch_setLimitMaxLength:(NSUInteger)length {
    [self ch_setAssociatedValue:[NSNumber numberWithUnsignedInteger:length] withKey:&CH_UI_TEXT_FIELD_LIMIT_MAX_LENGTH_KEY];
    [self addTarget:self action:@selector(_ch_textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)_ch_textFieldTextLengthLimit:(id)sender {
    NSNumber *lengthNumber = [self ch_getAssociatedValueForKey:&CH_UI_TEXT_FIELD_LIMIT_MAX_LENGTH_KEY];
    NSUInteger maxLength = [lengthNumber unsignedIntValue];
    NSString *toBeString = self.text;
    NSString *lang = self.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"zh-Hant"]) { // 简繁体中文
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){// || location >= maxLength) {
            if (toBeString.length > maxLength) {
                self.text = [toBeString substringToIndex:maxLength];
            }
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > maxLength && self.markedTextRange == nil) {
            //用字符串的字符编码指定索引查找位置
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1) {
                self.text = [toBeString substringToIndex:maxLength];
            } else {
                //用字符串的字符编码指定区域段查找位置
                self.text = [toBeString substringWithRange:NSMakeRange(0, toBeString.length - rangeIndex.length)];
            }
        }
    }
}

# pragma mark - <UITextInput>
- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text {
    [self _ch_textFieldTextLengthLimit:nil];
    return YES;
}

@end
