//
//  CHSKImageDownloader.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>
#import "CHSKPrivateDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHSKImageDownloader : NSObject

+ (instancetype)sharedDownloader;

- (void)downloadImageWithURL:(NSURL *)URL completionHandler:(CHSKImageDownloadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
