//
//  UICollectionViewFlowLayout+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/11.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewFlowLayout (CHBase)

#pragma mark - Base
@property (nonatomic) CGFloat ch_itemSizeWidth;             ///< itemSize的宽度值 -> self.itemSize.width
@property (nonatomic) CGFloat ch_itemSizeHeight;            ///< itemSize的高度值 -> self.itemSize.height
@property (nonatomic) CGFloat ch_estimatedItemSizeWidth;    ///< estimatedItemSize的宽度值 -> self.estimatedItemSize.width
@property (nonatomic) CGFloat ch_estimatedItemSizeHeight;   ///< estimatedItemSize的高度值 -> self.estimatedItemSize.height
@property (nonatomic) CGFloat ch_headerReferenceSizeWidth;  ///< headerReferenceSize的宽度值 -> self.headerReferenceSize.width
@property (nonatomic) CGFloat ch_headerReferenceSizeHeight; ///< headerReferenceSize的高度值 -> self.headerReferenceSize.height
@property (nonatomic) CGFloat ch_footerReferenceSizeWidth;  ///< footerReferenceSize的宽度值 -> self.footerReferenceSize.width
@property (nonatomic) CGFloat ch_footerReferenceSizeHeight; ///< footerReferenceSize的高度值 -> self.footerReferenceSize.height
@property (nonatomic) CGFloat ch_sectionInsetTop;           ///< sectionInset的上部值 -> self.sectonInset.top
@property (nonatomic) CGFloat ch_sectionInsetLeft;          ///< sectionInset的左部值 -> self.sectonInset.left
@property (nonatomic) CGFloat ch_sectionInsetBottom;        ///< sectionInset的下部值 -> self.sectonInset.bottom
@property (nonatomic) CGFloat ch_sectionInsetRight;         ///< sectionInset的右部值 -> self.sectonInset.right

@end

NS_ASSUME_NONNULL_END
