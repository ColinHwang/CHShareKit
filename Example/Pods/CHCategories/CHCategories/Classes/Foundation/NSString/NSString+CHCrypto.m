//
//  NSString+CHCrypto.m
//  CHCategories
//
//  Created by CHwang on 2019/1/25.
//

#import "NSString+CHCrypto.h"
#import "NSData+CHCrypto.h"

@implementation NSString (CHCrypto)

#pragma mark - Base64
- (NSString *)ch_base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_base64EncodedString];
}

+ (NSString *)ch_stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData ch_dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - MD2
- (NSString *)ch_MD2String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_MD2String];
}

#pragma mark - MD4
- (NSString *)ch_MD4String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_MD4String];
}

#pragma mark - MD5
- (NSString *)ch_MD5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_MD5String];
}

- (NSString *)ch_MD5StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            ch_MD5StringWithKey:key];
}

#pragma mark - SHA1
- (NSString *)ch_SHA1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_SHA1String];
}

- (NSString *)ch_SHA1StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            ch_SHA1StringWithKey:key];
}

#pragma mark - SHA224
- (NSString *)ch_SHA224String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_SHA224String];
}

- (NSString *)ch_SHA224StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            ch_SHA224StringWithKey:key];
}

#pragma mark - SHA256
- (NSString *)ch_SHA256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_SHA256String];
}

- (NSString *)ch_SHA256StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            ch_SHA256StringWithKey:key];
}

#pragma mark - SHA384
- (NSString *)ch_SHA384String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_SHA384String];
}

- (NSString *)ch_SHA384StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            ch_SHA384StringWithKey:key];
}

#pragma mark - SHA512
- (NSString *)ch_SHA512String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_SHA512String];
}

- (NSString *)ch_SHA512StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            ch_SHA512StringWithKey:key];
}

#pragma mark - CRC32
- (NSString *)ch_CRC32String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ch_CRC32String];
}

@end
