//
//  UIScrollView+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UIScrollView+CHBase.h"
#import "CHCoreGraphicHelper.h"

@implementation UIScrollView (CHBase)

#pragma mark - Base
- (UIEdgeInsets)ch_contentInset {
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    }
    return self.contentInset;
}

- (void)setCh_showsScrollIndicator:(BOOL)ch_showsScrollIndicator {
    self.showsHorizontalScrollIndicator = ch_showsScrollIndicator;
    self.showsVerticalScrollIndicator = ch_showsScrollIndicator;
}

- (BOOL)ch_showsScrollIndicator {
    return self.showsHorizontalScrollIndicator || self.showsVerticalScrollIndicator;
}

- (BOOL)ch_isScrolledToTop {
    if (CHCGFloatEqualeToFloat(self.contentOffset.y, -self.ch_contentInset.top)) return YES;
    
    return NO;
}
        
- (BOOL)ch_isScrolledToLeft {
if (CHCGFloatEqualeToFloat(self.contentOffset.x, -self.ch_contentInset.left)) return YES;

    return NO;
}

- (BOOL)ch_isScrolledToBottom {
    if (!self.ch_canScroll) return YES;
    if (CHCGFloatEqualeToFloat(self.contentOffset.y, self.contentSize.height + self.ch_contentInset.bottom - CGRectGetHeight(self.bounds))) return YES;
    
    return NO;
}
    
- (BOOL)ch_isScrolledToRight {
    if (!self.ch_canScroll) return YES;
    if (CHCGFloatEqualeToFloat(self.contentOffset.x, self.contentSize.width + self.ch_contentInset.right - CGRectGetWidth(self.bounds))) return YES;
     
    return NO;
}

- (BOOL)ch_canScroll {
    return [self ch_canScroll:CHUIScrollViewScrollDirectionVertical] || [self ch_canScroll:CHUIScrollViewScrollDirectionHorizontal];
}

- (BOOL)ch_canScroll:(CHUIScrollViewScrollDirection)direction {
    if (CHCGSizeIsEmpty(self.bounds.size)) return NO;
   
    BOOL canScroll = NO;
    switch (direction) {
        case CHUIScrollViewScrollDirectionVertical:
        {
            canScroll = self.contentSize.height + CHUIEdgeInsetsGetValuesInVertical(self.ch_contentInset) > CGRectGetHeight(self.bounds);
        }
            break;
        case CHUIScrollViewScrollDirectionHorizontal:
        {
            canScroll = self.contentSize.width + CHUIEdgeInsetsGetValuesInHorizontal(self.ch_contentInset) > CGRectGetWidth(self.bounds);
        }
            break;
    }
    return NO;
}

- (void)ch_scrollToTop {
    [self ch_scrollToTop:YES];
}

- (void)ch_scrollToBottom {
    [self ch_scrollToBottom:YES];
}

- (void)ch_scrollToLeft {
    [self ch_scrollToLeft:YES];
}

- (void)ch_scrollToRight {
    [self ch_scrollToRight:YES];
}

- (void)ch_scrollToTop:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.ch_contentInset.top;
    [self ch_setContentOffset:off animated:animated];
}

- (void)ch_scrollToBottom:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.ch_contentInset.bottom;
    [self ch_setContentOffset:off animated:animated];
}

- (void)ch_scrollToLeft:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.ch_contentInset.left;
    [self ch_setContentOffset:off animated:animated];
}

- (void)ch_scrollToRight:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.ch_contentInset.right;
    [self ch_setContentOffset:off animated:animated];
}

- (void)ch_setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    if (CHCGFloatEqualeToFloat(self.contentOffset.x, contentOffset.x) && CHCGFloatEqualeToFloat(self.contentOffset.y, contentOffset.y)) return; // CGPointEqualToPoint Not Work
    [self setContentOffset:contentOffset animated:animated];
}

- (void)ch_endDecelerating {
    if (!self.decelerating) return;
    
    [self ch_setContentOffset:self.contentOffset animated:NO];
}

@end
