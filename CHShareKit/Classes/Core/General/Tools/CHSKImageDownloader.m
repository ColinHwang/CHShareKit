//
//  CHSKImageDownloader.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKImageDownloader.h"
#import <SDWebImage/SDWebImageDownloader.h>

@implementation CHSKImageDownloader

+ (instancetype)sharedDownloader {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)downloadImageWithURL:(NSURL *)URL completionHandler:(CHSKImageDownloadCompletionHandler)completionHandler {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        !completionHandler ?: completionHandler(image, data, error, finished);
    }];
}

@end
