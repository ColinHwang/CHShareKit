//
//  CHSKPrivateDefines.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKPrivateDefines.h"

// Message Regular
// Share Message Code
const NSInteger CHSKShareMessageValidCode = 200;
// Share Title Length
const NSInteger CHSKWXShareTitleMaxLength = 512;
// Share Desc Length
const NSInteger CHSKWXShareDescMaxLength = 1024;
// Share URL Length
const NSInteger CHSKWXShareURLStringMaxLength = 10240;
// Share Image Size
const CGSize CHSKShareThumbnailImageSize = {100, 100}; // 100x100
const NSInteger CHSKWXShareImageMaxFileSize          = 10000000; // 10485760 -> 10M
const NSInteger CHSKWXShareThumbnailImageMaxFileSize = 32000;    // 32768 -> 32KB
const NSInteger CHSKQQShareImageMaxFileSize          = 5000000;  // 5242880 -> 5M
const NSInteger CHSKQQShareThumbnailImageMaxFileSize = 1000000;  // 1048576 -> 1M
const CGFloat CHSKShareImageCompressionFactor        = 1e-5;

// Share Error
NSString * const CHSKErrorDomin = @"CHSKErrorDomin";
