//
//  NSFileManager+CHBase.h
//  CHCategories
//
//  Created by CHwang on 17/1/4.
//  Base

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (CHBase)

#pragma mark - Base
/**
 获取路径下所有文件或文件夹的大小(字节, error -> -1)

 @param path 文件或文件夹路径
 @return 文件或文件夹的大小(字节, error -> -1)
 */
- (int64_t)ch_fileSizeWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
