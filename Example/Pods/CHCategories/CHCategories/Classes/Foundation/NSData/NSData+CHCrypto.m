//
//  NSData+CHCrypto.m
//  CHCategories
//
//  Created by CHwang on 2020/1/24.
//

#import "NSData+CHCrypto.h"
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h> // libz.1.2.5.tbd

@implementation NSData (CHCrypto)

#pragma mark - Base64
static const char ch_base64EncodingTable[64] // char -> 1字节
= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const short ch_base64DecodingTable[256] = // short -> 2字节(32位/64位机器)
{
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2,  -1,  -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62,  -2,  -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2,  -2,  -2, -2, -2,
    -2, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10,  11,  12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2,  -2,  -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,  37,  38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2
};

- (NSString *)ch_base64EncodedString {
    NSUInteger length = self.length;
    if (length == 0) return @"";
    
    NSUInteger out_length = ((length + 2) / 3) * 4;
    uint8_t *output = malloc(((out_length + 2) / 3) * 4);
    if (output == NULL) return nil;
    
    const char *input = self.bytes;
    NSInteger i, value;
    for (i = 0; i < length; i += 3) {
        value = 0;
        for (NSInteger j = i; j < i + 3; j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = ch_base64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] = ch_base64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = ((i + 1) < length)
        ? ch_base64EncodingTable[(value >> 6) & 0x3F]
        : '=';
        output[index + 3] = ((i + 2) < length)
        ? ch_base64EncodingTable[(value >> 0) & 0x3F]
        : '=';
    }
    
    NSString *base64 = [[NSString alloc] initWithBytes:output
                                                length:out_length
                                              encoding:NSASCIIStringEncoding];
    free(output);
    return base64;
}

+ (NSData *)ch_dataWithBase64EncodedString:(NSString *)base64EncodedString {
    NSInteger length = base64EncodedString.length;
    const char *string = [base64EncodedString cStringUsingEncoding:NSASCIIStringEncoding];
    if (string  == NULL) return nil;
    
    while (length > 0 && string[length - 1] == '=')
        length--;
    
    NSInteger outputLength = length * 3 / 4;
    NSMutableData *data = [NSMutableData dataWithLength:outputLength];
    if (data == nil) return nil;
    if (length == 0)  return data;
    
    uint8_t *output = data.mutableBytes;
    NSInteger inputPoint = 0;
    NSInteger outputPoint = 0;
    while (inputPoint < length) {
        char i0 = string[inputPoint++];
        char i1 = string[inputPoint++];
        char i2 = inputPoint < length ? string[inputPoint++] : 'A';
        char i3 = inputPoint < length ? string[inputPoint++] : 'A';
        
        output[outputPoint++] = (ch_base64DecodingTable[i0] << 2)
        | (ch_base64DecodingTable[i1] >> 4);
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((ch_base64DecodingTable[i1] & 0xf) << 4)
            | (ch_base64DecodingTable[i2] >> 2);
        }
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((ch_base64DecodingTable[i2] & 0x3) << 6)
            | ch_base64DecodingTable[i3];
        }
    }
    return data;
}


#pragma mark - Hash
/**
 根据加密算法和密钥, 生成加密后的data字符串
 
 @param algorithm 加密算法
 @param key       密钥
 @return 加密后的data字符串
 */
- (NSString *)_ch_hmacStringUsingAlgorithm:(CCHmacAlgorithm)algorithm withKey:(NSString *)key {
    size_t size;
    switch (algorithm) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(algorithm, cKey, strlen(cKey), self.bytes, self.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash.copy;
}

/**
 根据加密算法和密钥, 生成加密后的data
 
 @param algorithm 加密算法
 @param key       密钥
 @return 加密后的data
 */
- (NSData *)_ch_hmacDataUsingAlgorithm:(CCHmacAlgorithm)algorithm withKey:(NSData *)key {
    size_t size;
    switch (algorithm) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    CCHmac(algorithm, [key bytes], key.length, self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:size];
}

#pragma mark - MD2
- (NSString *)ch_MD2String {
    unsigned char result[CC_MD2_DIGEST_LENGTH]; // MD2信息长度
    CC_MD2(self.bytes, (CC_LONG)self.length, result); // 将输入信息的长度(bit)进行填充, 记录信息长度, 装入标准的幻数
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_MD2_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD2_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]]; // %02x -> 16进制形式两位输出(不足补0)
    }
    return hash.copy;
}

- (NSData *)ch_MD2Data {
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD2_DIGEST_LENGTH];
}

#pragma mark - MD4
- (NSString *)ch_MD4String {
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_MD4_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD4_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash.copy;
}

- (NSData *)ch_MD4Data {
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD4_DIGEST_LENGTH];
}

#pragma mark - MD5
- (NSString *)ch_MD5String {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_MD5_DIGEST_LENGTH  * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash.copy;
}

- (NSData *)ch_MD5Data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)ch_MD5StringWithKey:(NSString *)key {
    return [self _ch_hmacStringUsingAlgorithm:kCCHmacAlgMD5 withKey:key];
}

- (NSData *)ch_MD5DataWithKey:(NSData *)key {
    return [self _ch_hmacDataUsingAlgorithm:kCCHmacAlgMD5 withKey:key];
}

#pragma mark - SHA1
- (NSString *)ch_SHA1String {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash.copy;
}

- (NSData *)ch_SHA1Data {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)ch_SHA1StringWithKey:(NSString *)key {
    return [self _ch_hmacStringUsingAlgorithm:kCCHmacAlgSHA1 withKey:key];
}

- (NSData *)ch_SHA1DataWithKey:(NSData *)key {
    return [self _ch_hmacDataUsingAlgorithm:kCCHmacAlgSHA1 withKey:key];
}

#pragma mark - SHA224
- (NSString *)ch_SHA224String {
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash.copy;
}

- (NSData *)ch_SHA224Data {
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA224_DIGEST_LENGTH];
}

- (NSString *)ch_SHA224StringWithKey:(NSString *)key {
    return [self _ch_hmacStringUsingAlgorithm:kCCHmacAlgSHA224 withKey:key];
}

- (NSData *)ch_SHA224DataWithKey:(NSData *)key {
    return [self _ch_hmacDataUsingAlgorithm:kCCHmacAlgSHA224 withKey:key];
}

#pragma mark - SHA256
- (NSString *)ch_SHA256String {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash.copy;
}

- (NSData *)ch_SHA256Data {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)ch_SHA256StringWithKey:(NSString *)key {
    return [self _ch_hmacStringUsingAlgorithm:kCCHmacAlgSHA256 withKey:key];
}

- (NSData *)ch_SHA256DataWithKey:(NSData *)key {
    return [self _ch_hmacDataUsingAlgorithm:kCCHmacAlgSHA256 withKey:key];
}

#pragma mark - SHA384
- (NSString *)ch_SHA384String {
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash.copy;
}

- (NSData *)ch_SHA384Data {
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA384_DIGEST_LENGTH];
}

- (NSString *)ch_SHA384StringWithKey:(NSString *)key {
    return [self _ch_hmacStringUsingAlgorithm:kCCHmacAlgSHA384 withKey:key];
}

- (NSData *)ch_SHA384DataWithKey:(NSData *)key {
    return [self _ch_hmacDataUsingAlgorithm:kCCHmacAlgSHA384 withKey:key];
}

#pragma mark - SHA512
- (NSString *)ch_SHA512String {
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash.copy;
}

- (NSData *)ch_SHA512Data {
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)ch_SHA512StringWithKey:(NSString *)key {
    return [self _ch_hmacStringUsingAlgorithm:kCCHmacAlgSHA512 withKey:key];
}

- (NSData *)ch_SHA512DataWithKey:(NSData *)key {
    return [self _ch_hmacDataUsingAlgorithm:kCCHmacAlgSHA512 withKey:key];
}

#pragma mark - CRC32
- (NSString *)ch_CRC32String {
    uLong result = crc32(0, self.bytes, (uInt)self.length);
    return [NSString stringWithFormat:@"%08x", (uint32_t)result]; // %08x -> 16进制形式八位输出(不足补0)
}

- (uint32_t)ch_CRC32 {
    uLong result = crc32(0, self.bytes, (uInt)self.length);
    return (uint32_t)result;
}

#pragma mark - Encrypt && Decrypt
- (NSData *)_ch_crypt:(CCOperation)operation usingAlgorithm:(CCAlgorithm)algorithm withKey:(NSData *)key iv:(NSData *)iv {
    NSInteger blockSize = 0;
    CCOptions options = 0;
    switch (algorithm) {
        case kCCAlgorithmAES128:
        {
            if (key.length != kCCKeySizeAES128 && key.length != kCCKeySizeAES192 && key.length != kCCKeySizeAES256) return nil;
            if (iv.length != kCCBlockSizeAES128 && iv.length != 0) return nil;
            
            blockSize = kCCBlockSizeAES128;
            options = kCCOptionPKCS7Padding;
        }
            break;
        case kCCAlgorithmDES:
        {
            if (key.length != kCCKeySizeDES) return nil;
            if (iv.length != kCCBlockSizeDES && iv.length != 0) return nil;
            
            blockSize = kCCBlockSizeDES;
            options = kCCOptionPKCS7Padding|kCCOptionECBMode;
        }
            break;
        case kCCAlgorithm3DES:
        {
            if (key.length != kCCKeySize3DES) return nil;
            if (iv.length != kCCBlockSize3DES && iv.length != 0) return nil;
            
            blockSize = kCCBlockSize3DES;
            options = kCCOptionPKCS7Padding;
        }
            break;
            
        default:
            return nil;
            break;
    }

    NSData *result = nil;
    size_t bufferSize = self.length + blockSize;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t cryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          algorithm,
                                          options,
                                          key.bytes,
                                          key.length,
                                          iv.bytes,
                                          self.bytes,
                                          self.length,
                                          buffer,
                                          bufferSize,
                                          &cryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc] initWithBytes:buffer length:cryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }

    return nil;
}

#pragma mark - AES256
- (NSData *)ch_AES256EncryptWithKey:(NSString *)key {
    return [self ch_AES256EncryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
}

- (NSData *)ch_AES256EncryptWithKey:(NSData *)key iv:(NSData *)iv {
    return [self _ch_crypt:kCCEncrypt usingAlgorithm:kCCAlgorithmAES128 withKey:key iv:iv];
}

- (NSData *)ch_AES256DecryptWithKey:(NSString *)key {
    return [self ch_AES256DecryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
}

- (NSData *)ch_AES256DecryptWithKey:(NSData *)key iv:(NSData *)iv {
    return [self _ch_crypt:kCCDecrypt usingAlgorithm:kCCAlgorithmAES128 withKey:key iv:iv];
}

#pragma mark - DES
- (NSData *)ch_DESEncryptWithKey:(NSString *)key {
    return [self ch_DESEncryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
}

- (NSData *)ch_DESEncryptWithKey:(NSData *)key iv:(NSData *)iv {
    return [self _ch_crypt:kCCEncrypt usingAlgorithm:kCCAlgorithmDES withKey:key iv:iv];
}

- (NSData *)ch_DESDecryptWithKey:(NSString *)key {
    return [self ch_DESDecryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
}

- (NSData *)ch_DESDecryptWithKey:(NSData *)key iv:(NSData *)iv {
    return [self _ch_crypt:kCCDecrypt usingAlgorithm:kCCAlgorithmDES withKey:key iv:iv];
}

#pragma mark - 3DES
- (NSData *)ch_3DESEncryptWithKey:(NSString *)key {
    return [self ch_3DESEncryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
}

- (NSData *)ch_3DESEncryptWithKey:(NSData *)key iv:(NSData *)iv {
    return [self _ch_crypt:kCCEncrypt usingAlgorithm:kCCAlgorithmDES withKey:key iv:iv];
}

- (NSData *)ch_3DESDecryptWithKey:(NSString *)key {
    return [self ch_3DESDecryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
}

- (NSData *)ch_3DESDecryptWithKey:(NSData *)key iv:(NSData *)iv {
    return [self _ch_crypt:kCCDecrypt usingAlgorithm:kCCAlgorithm3DES withKey:key iv:iv];
}

@end
