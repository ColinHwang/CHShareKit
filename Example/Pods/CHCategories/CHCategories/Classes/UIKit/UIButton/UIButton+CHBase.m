//
//  UIButton+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/12.
//
//

#import "UIButton+CHBase.h"
#import "UIView+CHBase.h"

@implementation UIButton (CHBase)

#pragma mark - Base
- (instancetype)ch_initWithImage:(UIImage *)image title:(NSString *)title {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [self init];
#pragma clang diagnostic pop
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    return self;
}

#pragma mark - Count Down
- (void)ch_changeWithCountDown:(NSInteger)seconds title:(NSString *)title backgroundColor:(UIColor *)backgroundColor finishedTitle:(NSString *)finishedTitle finishedBackgroundColor:(UIColor *)finishedBackgroundColor {
    [self ch_changeWithCountDown:seconds countDownHandler:^(UIButton *sender, NSInteger second, BOOL finished) {
        if (finished) {
            sender.backgroundColor = finishedBackgroundColor;
            [sender setTitle:finishedTitle forState:UIControlStateNormal];
            sender.enabled = YES;
        } else {
            sender.backgroundColor = backgroundColor;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2ld", (long)second];
            [sender setTitle:[NSString stringWithFormat:@"%@(%@S)",title, timeStr] forState:UIControlStateDisabled];
            sender.enabled = NO;
        }
    }];
}

@end
