//
//  NSData+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2020/1/3.
//  Base

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CHBase)

#pragma mark - Base
/**
 根据MainBundle内的文件名, 获取路径下data

 @param name 文件名
 @return data(无法找到返回nil)
 */
+ (nullable NSData *)ch_dataNamed:(NSString *)name;

/**
 获取data对应的UTF-8解码字符串

 @return data对应的UTF-8解码字符串
 */
- (NSString *)ch_utf8String;

/**
 获取data对应的Hex字符串(大写)

 @return data对应的Hex字符串(大写)
 */
- (NSString *)ch_hexString;

/**
 根据Hex字符串, 创建data

 @param hexStr Hex字符串
 @return NSData对象
 */
+ (nullable NSData *)ch_dataWithHexString:(NSString *)hexStr;

#pragma mark - JSON Value
/**
 获取JSON解析后, data对应的数据(NSDictionary, NSArray, NSData...)
 
 @return data对应的数据(NSDictionary, NSArray, NSData...)
 */
- (id)ch_JSONValueDecoded;

#pragma mark - Pack && Unpack
/**
 将data压缩成gzip格式data
 
 @return gzip格式data
 */
- (nullable NSData *)ch_gzipPack;

/**
 将gzip格式data解压成data
 
 @return NSData对象
 */
- (nullable NSData *)ch_gzipUnpack;

/**
 将data压缩成zlib格式data
 
 @return zlib格式data
 */
- (nullable NSData *)ch_zlibPack;

/**
 将zlib格式data解压成data
 
 @return NSData对象
 */
- (nullable NSData *)ch_zlibUnpack;

@end

NS_ASSUME_NONNULL_END
