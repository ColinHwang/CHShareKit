//
//  NSData+CHCrypto.h
//  CHCategories
//
//  Created by CHwang on 2020/1/24.
//  加密和解密

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CHCrypto)

#pragma mark - Base64
/**
 获取data对应的Base64编码的data字符串
 
 @return data对应的Base64编码的data字符串
 */
- (nullable NSString *)ch_base64EncodedString;

/**
 根据Base64字符串, 获取字符串解码后对应的data
 
 @param base64EncodedString Base64字符串
 @return 字符串解码后对应的data
 */
+ (nullable NSData *)ch_dataWithBase64EncodedString:(NSString *)base64EncodedString;

#pragma mark - MD2
/**
 获取data对应的MD2字符串(小写)
 
 @return data对应的MD2字符串(小写)
 */
- (NSString *)ch_MD2String;

/**
 获取data对应的MD2Data
 
 @return MD2Data
 */
- (NSData *)ch_MD2Data;

#pragma mark - MD4
/**
 获取data对应的MD4字符串(小写)
 
 @return data对应的MD4字符串(小写)
 */
- (NSString *)ch_MD4String;

/**
 获取data对应的MD4Data
 
 @return MD4Data
 */
- (NSData *)ch_MD4Data;

#pragma mark - MD5
/**
 获取data对应的MD5字符串(小写)
 
 @return data对应的MD5字符串(小写)
 */
- (NSString *)ch_MD5String;

/**
 获取data对应的MD5Data
 
 @return MD5Data
 */
- (NSData *)ch_MD5Data;

/**
 根据密钥, 生成MD5加密后的data字符串
 
 @param key 密钥
 @return MD5加密后的data字符串
 */
- (nullable NSString *)ch_MD5StringWithKey:(NSString *)key;

/**
 根据密钥, 生成MD5加密后的data
 
 @param key 密钥
 @return MD5加密后的data
 */
- (nullable NSData *)ch_MD5DataWithKey:(NSData *)key;

#pragma mark - SHA1
/**
 获取data对应的SHA1字符串(小写)
 
 @return data对应的SHA1字符串(小写)
 */
- (NSString *)ch_SHA1String;

/**
 获取data对应的SHA1Data
 
 @return SHA1Data
 */
- (NSData *)ch_SHA1Data;

/**
 根据密钥, 生成SHA1加密后的data字符串
 
 @param key 密钥
 @return SHA1加密后的data字符串
 */
- (nullable NSString *)ch_SHA1StringWithKey:(NSString *)key;

/**
 根据密钥, 生成SHA1加密后的data
 
 @param key 密钥
 @return SHA1加密后的data
 */
- (nullable NSData *)ch_SHA1DataWithKey:(NSData *)key;

#pragma mark - SHA224
/**
 获取data对应的SHA224字符串(小写)
 
 @return data对应的SHA224字符串(小写)
 */
- (NSString *)ch_SHA224String;

/**
 获取data对应的SHA224Data
 
 @return SHA224Data
 */
- (NSData *)ch_SHA224Data;

/**
 根据密钥, 生成SHA224加密后的data字符串
 
 @param key 密钥
 @return SHA224加密后的data字符串
 */
- (nullable NSString *)ch_SHA224StringWithKey:(NSString *)key;

/**
 根据密钥, 生成SHA224加密后的data
 
 @param key 密钥
 @return SHA224加密后的data
 */
- (nullable NSData *)ch_SHA224DataWithKey:(NSData *)key;

#pragma mark - SHA256
/**
 获取data对应的SHA256字符串(小写)
 
 @return data对应的SHA256字符串(小写)
 */
- (NSString *)ch_SHA256String;

/**
 获取data对应的SHA256Data
 
 @return SHA256Data
 */
- (NSData *)ch_SHA256Data;

/**
 根据密钥, 生成SHA256加密后的data字符串
 
 @param key 密钥
 @return SHA256加密后的data字符串
 */
- (nullable NSString *)ch_SHA256StringWithKey:(NSString *)key;

/**
 根据密钥, 生成SHA256加密后的data
 
 @param key 密钥
 @return SHA256加密后的data
 */
- (nullable NSData *)ch_SHA256DataWithKey:(NSData *)key;

#pragma mark - SHA384
/**
 获取data对应的SHA384字符串(小写)
 
 @return data对应的SHA384字符串(小写)
 */
- (NSString *)ch_SHA384String;

/**
 获取data对应的SHA384Data
 
 @return SHA384Data
 */
- (NSData *)ch_SHA384Data;

/**
 根据密钥, 生成SHA384加密后的data字符串
 
 @param key 密钥
 @return SHA384加密后的data字符串
 */
- (nullable NSString *)ch_SHA384StringWithKey:(NSString *)key;

/**
 根据密钥, 生成SHA384加密后的data
 
 @param key 密钥
 @return SHA384加密后的data
 */
- (nullable NSData *)ch_SHA384DataWithKey:(NSData *)key;

#pragma mark - SHA512
/**
 获取data对应的SHA512字符串(小写)
 
 @return data对应的SHA512字符串(小写)
 */
- (NSString *)ch_SHA512String;

/**
 获取data对应的SHA512Data
 
 @return SHA512Data
 */
- (NSData *)ch_SHA512Data;

/**
 根据密钥, 生成SHA512加密后的data字符串
 
 @param key 密钥
 @return SHA512加密后的data字符串
 */
- (nullable NSString *)ch_SHA512StringWithKey:(NSString *)key;

/**
 根据密钥, 生成SHA512加密后的data
 
 @param key 密钥
 @return SHA512加密后的data
 */
- (nullable NSData *)ch_SHA512DataWithKey:(NSData *)key;

#pragma mark - CRC32
/**
 获取data对应的CRC32字符串
 
 @return data对应的CRC32字符串
 */
- (NSString *)ch_CRC32String;

/**
 获取data对应的CRC32值
 
 @return data对应的CRC32值
 */
- (uint32_t)ch_CRC32;

#pragma mark - AES256
/**
 获取AES256加密后的data(key长度非法, 返回nil)
 
 @param key 密钥(16, 24, 32字节 <128, 192, 256位>)
 @return AES256加密后的data(key长度非法, 返回nil)
 */
- (nullable NSData *)ch_AES256EncryptWithKey:(NSString *)key;

/**
 获取AES256加密后的data(key或iv长度非法, 返回nil)
 
 @param key 密钥(16, 24, 32字节 <128, 192, 256位>)
 @param iv  初始化向量(16字节<128位>, 可传nil)
 @return AES256加密后的data(key或iv长度非法, 返回nil)
 */
- (nullable NSData *)ch_AES256EncryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

/**
 获取AES256解密后的data(key长度非法, 返回nil)
 
 @param key 密钥(16, 24, 32字节 <128, 192, 256位>)
 @return AES256解密后的data(key长度非法, 返回nil)
 */
- (nullable NSData *)ch_AES256DecryptWithKey:(NSString *)key;

/**
 获取AES256解密后的data(key或iv长度非法, 返回nil)
 
 @param key 密钥(16, 24, 32字节 <128, 192, 256位>)
 @param iv  初始化向量(16字节<128位>, 可传nil)
 @return AES256解密后的data(key或iv长度非法, 返回nil)
 */
- (nullable NSData *)ch_AES256DecryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

#pragma mark - DES
/**
 获取DES加密后的data(key长度非法, 返回nil)
 
 @param key 密钥(8字节 <64位>)
 @return DES加密后的data(key长度非法, 返回nil)
 */
- (nullable NSData *)ch_DESEncryptWithKey:(NSString *)key;

/**
 获取DES加密后的data(key或iv长度非法, 返回nil)
 
 @param key 密钥(8字节 <64位>)
 @param iv  初始化向量(8字节 <64位>, 可传nil)
 @return DES加密后的data(key或iv长度非法, 返回nil)
 */
- (nullable NSData *)ch_DESEncryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

/**
 获取DES解密后的data(key长度非法, 返回nil)
 
 @param key 密钥(8字节 <64位>)
 @return DES解密后的data(key长度非法, 返回nil)
 */
- (nullable NSData *)ch_DESDecryptWithKey:(NSString *)key;

/**
 获取DES解密后的data(key或iv长度非法, 返回nil)
 
 @param key 密钥(8字节 <64位>)
 @param iv  初始化向量(8字节 <64位>, 可传nil)
 @return DES解密后的data(key或iv长度非法, 返回nil)
 */
- (nullable NSData *)ch_DESDecryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

#pragma mark - 3DES
/**
 获取3DES加密后的data(key长度非法, 返回nil)
 
 @param key 密钥(8字节 <64位>)
 @return 3DES加密后的data(key长度非法, 返回nil)
 */
- (nullable NSData *)ch_3DESEncryptWithKey:(NSString *)key;

/**
 获取3DES加密后的data(key或iv长度非法, 返回nil)
 
 @param key 密钥(8字节 <64位>)
 @param iv  初始化向量(8字节 <64位>, 可传nil)
 @return 3DES加密后的data(key或iv长度非法, 返回nil)
 */
- (nullable NSData *)ch_3DESEncryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

/**
 获取3DES解密后的data(key长度非法, 返回nil)
 
 @param key 密钥(8字节 <64位>)
 @return 3DES解密后的data(key长度非法, 返回nil)
 */
- (nullable NSData *)ch_3DESDecryptWithKey:(NSString *)key;

/**
 获取3DES解密后的data(key或iv长度非法, 返回nil)
 
 @param key 密钥(8字节 <64位>)
 @param iv  初始化向量(8字节 <64位>, 可传nil)
 @return 3DES解密后的data(key或iv长度非法, 返回nil)
 */
- (nullable NSData *)ch_3DESDecryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

@end

NS_ASSUME_NONNULL_END
