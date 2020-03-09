//
//  UICollectionViewFlowLayout+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import "UICollectionViewFlowLayout+CHBase.h"

@implementation UICollectionViewFlowLayout (CHBase)

#pragma mark - Base
- (CGFloat)ch_itemSizeWidth {
    return self.itemSize.width;
}

- (void)setCh_itemSizeWidth:(CGFloat)itemSizeWidth {
    CGSize itemSize = self.itemSize;
    itemSize.width = itemSizeWidth;
    self.itemSize = itemSize;
}

- (CGFloat)ch_itemSizeHeight {
    return self.itemSize.height;
}

- (void)setCh_itemSizeHeight:(CGFloat)itemSizeHeight {
    CGSize itemSize = self.itemSize;
    itemSize.height = itemSizeHeight;
    self.itemSize = itemSize;
}

- (CGFloat)ch_estimatedItemSizeWidth {
    return self.estimatedItemSize.width;
}

- (void)setCh_estimatedItemSizeWidth:(CGFloat)estimatedItemSizeWidth {
    CGSize estimatedItemSize = self.estimatedItemSize;
    estimatedItemSize.width = estimatedItemSizeWidth;
    self.estimatedItemSize = estimatedItemSize;
}

- (CGFloat)ch_estimatedItemSizeHeight {
    return self.estimatedItemSize.height;
}

- (void)setCh_estimatedItemSizeHeight:(CGFloat)estimatedItemSizeHeight {
    CGSize estimatedItemSize = self.estimatedItemSize;
    estimatedItemSize.height = estimatedItemSizeHeight;
    self.estimatedItemSize = estimatedItemSize;
}

- (CGFloat)ch_headerReferenceSizeWidth {
    return self.headerReferenceSize.width;
}

- (void)setCh_headerReferenceSizeWidth:(CGFloat)headerReferenceSizeWidth {
    CGSize headerReferenceSize = self.headerReferenceSize;
    headerReferenceSize.width = headerReferenceSizeWidth;
    self.headerReferenceSize = headerReferenceSize;
}

- (CGFloat)ch_headerReferenceSizeHeight {
    return self.headerReferenceSize.height;
}

- (void)setCh_headerReferenceSizeHeight:(CGFloat)headerReferenceSizeHeight {
    CGSize headerReferenceSize = self.headerReferenceSize;
    headerReferenceSize.height = headerReferenceSizeHeight;
    self.headerReferenceSize = headerReferenceSize;
}

- (CGFloat)ch_footerReferenceSizeWidth {
    return self.footerReferenceSize.width;
}

- (void)setCh_footerReferenceSizeWidth:(CGFloat)footerReferenceSizeWidth {
    CGSize footerReferenceSize = self.footerReferenceSize;
    footerReferenceSize.width = footerReferenceSizeWidth;
    self.footerReferenceSize = footerReferenceSize;
}

- (CGFloat)ch_footerReferenceSizeHeight {
    return self.footerReferenceSize.height;
}

- (void)setCh_footerReferenceSizeHeight:(CGFloat)footerReferenceSizeHeight {
    CGSize footerReferenceSize = self.footerReferenceSize;
    footerReferenceSize.height = footerReferenceSizeHeight;
    self.footerReferenceSize = footerReferenceSize;
}

- (CGFloat)ch_sectionInsetTop {
    return self.sectionInset.top;
}

- (void)setCh_sectionInsetTop:(CGFloat)sectionInsetTop {
    UIEdgeInsets sectionInset = self.sectionInset;
    sectionInset.top = sectionInsetTop;
    self.sectionInset = sectionInset;
}

- (CGFloat)ch_sectionInsetLeft
{
    return self.sectionInset.left;
}

- (void)setCh_sectionInsetLeft:(CGFloat)sectionInsetLeft
{
    UIEdgeInsets sectionInset = self.sectionInset;
    sectionInset.left = sectionInsetLeft;
    self.sectionInset = sectionInset;
}

- (CGFloat)ch_sectionInsetBottom
{
    return self.sectionInset.bottom;
}

- (void)setCh_sectionInsetBottom:(CGFloat)sectionInsetBottom
{
    UIEdgeInsets sectionInset = self.sectionInset;
    sectionInset.bottom = sectionInsetBottom;
    self.sectionInset = sectionInset;
}

- (CGFloat)ch_sectionInsetRight
{
    return self.sectionInset.right;
}

- (void)setCh_sectionInsetRight:(CGFloat)sectionInsetRight
{
    UIEdgeInsets sectionInset = self.sectionInset;
    sectionInset.right = sectionInsetRight;
    self.sectionInset = sectionInset;
}

@end
