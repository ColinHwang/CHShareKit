//
//  NSString+CHCrypto.h
//  CHCategories
//
//  Created by CHwang on 2019/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CHCrypto)

#pragma mark - Base64
/**
 获取string对应的Base64编码的字符串
 
 @return string对应的Base64编码的字符串
 */
- (nullable NSString *)ch_base64EncodedString;

/**
 根据Base64字符串, 获取字符串解码后对应的string
 
 @param base64EncodedString Base64字符串
 @return 解码后对应的string
 */
+ (nullable NSString *)ch_stringWithBase64EncodedString:(NSString *)base64EncodedString;

#pragma mark - MD2
/**
 获取string对应的MD2字符串(小写)
 
 @return string对应的MD2字符串(小写)
 */
- (nullable NSString *)ch_MD2String;

#pragma mark - MD4
/**
 获取string对应的MD4字符串(小写)
 
 @return string对应的MD4字符串(小写)
 */
- (nullable NSString *)ch_MD4String;

#pragma mark - MD5
/**
 获取string对应的MD5字符串(小写)
 
 @return string对应的MD5字符串(小写)
 */
- (nullable NSString *)ch_MD5String;

/**
 根据密钥, 生成MD5加密后的字符串
 
 @param key 密钥
 @return MD5加密后的字符串
 */
- (nullable NSString *)ch_MD5StringWithKey:(NSString *)key;

#pragma mark - SHA1
/**
 获取string对应的SHA1字符串(小写)
 
 @return string对应的SHA1字符串(小写)
 */
- (nullable NSString *)ch_SHA1String;

/**
 根据密钥, 生成SHA1加密后的字符串
 
 @param key 密钥
 @return SHA1加密后的字符串
 */
- (nullable NSString *)ch_SHA1StringWithKey:(NSString *)key;

#pragma mark - SHA224
/**
 获取string对应的SHA224字符串(小写)
 
 @return string对应的SHA224字符串(小写)
 */
- (nullable NSString *)ch_SHA224String;

/**
 根据密钥, 生成SHA224加密后的字符串
 
 @param key 密钥
 @return SHA224加密后的字符串
 */
- (nullable NSString *)ch_SHA224StringWithKey:(NSString *)key;

#pragma mark - SHA256
/**
 获取string对应的SHA256字符串(小写)
 
 @return string对应的SHA256字符串(小写)
 */
- (nullable NSString *)ch_SHA256String;

/**
 根据密钥, 生成SHA256加密后的字符串
 
 @param key 密钥
 @return SHA256加密后的字符串
 */
- (nullable NSString *)ch_SHA256StringWithKey:(NSString *)key;

#pragma mark - SHA384
/**
 获取string对应的SHA384字符串(小写)
 
 @return string对应的SHA384字符串(小写)
 */
- (nullable NSString *)ch_SHA384String;

/**
 根据密钥, 生成SHA384加密后的字符串
 
 @param key 密钥
 @return SHA384加密后的字符串
 */
- (nullable NSString *)ch_SHA384StringWithKey:(NSString *)key;

#pragma mark - SHA512
/**
 获取string对应的SHA512字符串(小写)
 
 @return string对应的SHA512字符串(小写)
 */
- (nullable NSString *)ch_SHA512String;

/**
 根据密钥, 生成SHA512加密后的字符串
 
 @param key 密钥
 @return SHA512加密后的字符串
 */
- (nullable NSString *)ch_SHA512StringWithKey:(NSString *)key;

#pragma mark - CRC32
/**
 获取string对应的CRC32字符串(小写)
 
 @return string对应的CRC32字符串(小写)
 */
- (nullable NSString *)ch_CRC32String;

@end

NS_ASSUME_NONNULL_END
