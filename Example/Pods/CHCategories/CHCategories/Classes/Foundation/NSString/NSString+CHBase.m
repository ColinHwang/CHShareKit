//
//  NSString+CHBase.m
//  CHCategories
//
//  Created by CHwang on 16/12/31.
//

#import "NSString+CHBase.h"
#import "NSCharacterSet+CHBase.h"
#import "NSData+CHBase.h"
#import "NSDecimalNumber+CHBase.h"
#import "NSNumber+CHBase.h"

@implementation NSString (CHBase)

#pragma mark - Base
- (NSRange)ch_rangeOfAll {
    return NSMakeRange(0, self.length);
}

+ (NSString *)ch_stringNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!str) {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
        str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    }
    return str;
}

- (NSUInteger)ch_lengthOfUsingNonASCIICharacterAsTwoEncoding {
    NSUInteger length = 0;
    for (NSUInteger i = 0, l = self.length; i < l; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            length += 1;
        } else {
            length += 2;
        }
    }
    return length;
}

+ (NSString *)ch_stringByConcat:(id)obj, ... {
    if (obj) {
        NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@", obj];

        va_list argumentList;
        va_start(argumentList, obj);
        id argument;
        while ((argument = va_arg(argumentList, id))) {
            [result appendFormat:@"%@", argument];
        }
        va_end(argumentList);

        return [result copy];
    }
    return @"";
}

#pragma mark - Substring
- (NSArray<NSValue *> *)ch_rangesOfSubstring:(NSString *)substring {
    return [self ch_rangesOfSubstring:substring inRange:self.ch_rangeOfAll];
}

- (NSArray<NSValue *> *)ch_rangesOfSubstring:(NSString *)substring inRange:(NSRange)range {
    __block NSMutableArray<NSValue *> *buffer = @[].mutableCopy;
    if (!substring.length) return buffer.copy;
    
    [self enumerateSubstringsInRange:range options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable aSubstring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if ([aSubstring isEqualToString:substring]) {
            [buffer addObject:[NSValue valueWithRange:substringRange]];
        }
    }];
    return buffer.copy;
}

- (NSArray<NSString *> *)ch_substrings {
    return [self ch_substringsInRange:self.ch_rangeOfAll];
}

- (NSArray<NSString *> *)ch_substringsInRange:(NSRange)range {
    NSMutableArray<NSString *> *buffer = @[].mutableCopy;
    for (NSInteger i = range.location; i < range.length; i++) {
        NSString *substring = [self substringWithRange:NSMakeRange(i, 1)];
        [buffer addObject:substring];
    }
    return buffer.copy;
}

- (NSArray<NSString *> *)ch_substringsInRange:(NSRange)range usingBlock:(BOOL (^)(NSString * _Nullable substring, NSRange substringRange, BOOL *stop))block {
    NSMutableArray<NSString *> *buffer = @[].mutableCopy;
    BOOL contains = YES;
    BOOL stop = NO;
    
    for (NSInteger i = range.location; i < range.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *substring = [self substringWithRange:range];
        if (block) {
            contains = block(substring, range, &stop);
        }
        
        if (contains) {
            [buffer addObject:substring];
        }
        
        if (stop) break;
    }
    return buffer.copy;
}

- (NSArray<NSString *> *)ch_substringsInRange:(NSRange)range options:(NSStringEnumerationOptions)opts {
    return [self ch_substringsInRange:range options:opts usingBlock:^BOOL(NSString * _Nonnull substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        return YES;
    }];
}

- (NSArray<NSString *> *)ch_substringsInRange:(NSRange)range options:(NSStringEnumerationOptions)opts usingBlock:(BOOL (^)(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop))block {
    __block NSMutableArray<NSString *> *buffer = @[].mutableCopy;
    __block BOOL shoudAdd = YES;
    [self enumerateSubstringsInRange:range options:opts usingBlock:^(NSString * _Nullable aSubstring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (block) {
            shoudAdd = block(aSubstring, substringRange, enclosingRange, stop);
        }
        
        if (shoudAdd) {
            [buffer addObject:aSubstring];
        }
    }];
    return buffer.copy;
}

- (NSRange)_ch_rangeOfComposedCharacterSequencesForRange:(NSRange)range roundDown:(BOOL)roundDown {
    if (!roundDown) {
        return [self rangeOfComposedCharacterSequencesForRange:range];
    }
    
    if (range.length == 0) {
        return range;
    }
    
    NSRange buffer = [self rangeOfComposedCharacterSequencesForRange:range];
    if (NSMaxRange(buffer) > NSMaxRange(range)) {
        return [self _ch_rangeOfComposedCharacterSequencesForRange:NSMakeRange(range.location, range.length - 1) roundDown:YES];
    }
    return buffer;
}

- (NSUInteger)_ch_indexByUsingNonASCIICharacterAsTwoEncodingForIndex:(NSUInteger)index {
    CGFloat strlength = 0.f;
    NSUInteger i = 0;
    for (i = 0; i < self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if (strlength >= index + 1) return i;
    }
    return 0;
}

- (NSRange)_ch_rangeByUsingNonASCIICharacterAsTwoEncodingForRange:(NSRange)range {
    CGFloat strlength = 0.f;
    NSRange resultRange = NSMakeRange(NSNotFound, 0);
    NSUInteger i = 0;
    for (i = 0; i < self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if (strlength >= range.location + 1) {
            if (resultRange.location == NSNotFound) {
                resultRange.location = i;
            }
            
            if (range.length > 0 && strlength >= NSMaxRange(range)) {
                resultRange.length = i - resultRange.location + (strlength == NSMaxRange(range) ? 1 : 0);
                return resultRange;
            }
        }
    }
    return resultRange;
}

- (NSString *)ch_substringFromIndex:(NSUInteger)from option:(CHNSStringSubstringConversionOptions)option {
    if (!option) {
        return [self substringFromIndex:from];
    }
    
    if (option & CHNSStringSubstringConversionByAvoidBreakingUpCharacterSequences) {
        NSUInteger aIndex = (option & CHNSStringSubstringConversionByUsingNonASCIICharacterAsTwoEncoding) ? [self _ch_indexByUsingNonASCIICharacterAsTwoEncodingForIndex:from] : from;
        
        NSRange buffer = [self rangeOfComposedCharacterSequenceAtIndex:aIndex];
        aIndex = (option & CHNSStringSubstringConversionByCharacterSequencesLengthRequired) ? NSMaxRange(buffer) : buffer.location;
        
        return [self substringFromIndex:aIndex];
    }
    return @"";
}

- (NSString *)ch_substringToIndex:(NSUInteger)to option:(CHNSStringSubstringConversionOptions)option {
    if (!option) {
        return [self substringToIndex:to];
    }
    
    if (option & CHNSStringSubstringConversionByAvoidBreakingUpCharacterSequences) {
        NSUInteger aIndex = (option & CHNSStringSubstringConversionByUsingNonASCIICharacterAsTwoEncoding) ? [self _ch_indexByUsingNonASCIICharacterAsTwoEncodingForIndex:to] : to;
        
        NSRange buffer = [self rangeOfComposedCharacterSequenceAtIndex:aIndex];
        aIndex = (option & CHNSStringSubstringConversionByCharacterSequencesLengthRequired) ? buffer.location : NSMaxRange(buffer);
        
        return [self substringToIndex:aIndex];
    }
    return @"";
}

- (NSString *)ch_substringWithRange:(NSRange)range option:(CHNSStringSubstringConversionOptions)option {
    if (!option) {
        return [self substringWithRange:range];
    }
    
    if (option & CHNSStringSubstringConversionByAvoidBreakingUpCharacterSequences) {
        NSRange aRange = range;
        if (option & CHNSStringSubstringConversionByUsingNonASCIICharacterAsTwoEncoding) {
            aRange = [self _ch_rangeByUsingNonASCIICharacterAsTwoEncodingForRange:aRange];
        }
        
        aRange = (option & CHNSStringSubstringConversionByCharacterSequencesLengthRequired) ? [self _ch_rangeOfComposedCharacterSequencesForRange:aRange roundDown:YES] : [self rangeOfComposedCharacterSequencesForRange:aRange];

        return [self substringWithRange:aRange];
    }
    return @"";
}

#pragma mark - Composed Character Sequences
- (NSUInteger)ch_lengthOfComposedCharacterSequences {
    if (!self.length) return 0;
    
    __block NSUInteger length = 0;
    [self enumerateSubstringsInRange:self.ch_rangeOfAll options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (substring) {
            length++;
        }
    }];
    return length;
}

- (NSString *)ch_firstComposedCharacterSequences {
    return [self ch_composedCharacterSequencesAtIndex:0];
}

- (NSString *)ch_lastComposedCharacterSequences {
    return [self ch_composedCharacterSequencesAtIndex:self.length-1];
}

- (NSString *)ch_composedCharacterSequencesAtIndex:(NSUInteger)index {
    if (!self.length) return @"";

    return [self substringWithRange:[self rangeOfComposedCharacterSequenceAtIndex:index]];
}

- (NSString *)ch_composedCharacterSequencesFromIndex:(NSUInteger)index {
    if (!self.length) return @"";
    
    return [self substringFromIndex:[self rangeOfComposedCharacterSequenceAtIndex:index].location];
}

- (NSString *)ch_composedCharacterSequencesToIndex:(NSUInteger)index {
    if (!self.length) return @"";
    
    return [self substringToIndex:NSMaxRange([self rangeOfComposedCharacterSequenceAtIndex:index])];
}

- (NSString *)ch_composedCharacterSequencesWithRange:(NSRange)range {
    if (!self.length) return @"";
    
    return [self substringWithRange:[self rangeOfComposedCharacterSequencesForRange:range]];
}

- (NSArray<NSString *> *)ch_composedCharacterSequences {
    return [self ch_substringsInRange:self.ch_rangeOfAll options:NSStringEnumerationByComposedCharacterSequences];
}

- (NSString *)ch_stringByReplacingComposedCharacterSequencesWithString:(NSString *)replacement {
    __block NSString *tempString = [NSString stringWithString:self];
    [self enumerateSubstringsInRange:self.ch_rangeOfAll options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (![substring isEqualToString:replacement]) {
            tempString = [tempString stringByReplacingOccurrencesOfString:substring withString:replacement];
        }
    }];
    return tempString;
}

- (NSString *)ch_stringByRemovingFirstComposedCharacterSequence {
    NSMutableString *string = [[NSMutableString alloc] initWithString:self];
    [string ch_deleteFirstComposedCharacterSequence];
    return string.copy;
}

- (NSString *)ch_stringByRemovingLastComposedCharacterSequence {
    NSMutableString *string = [[NSMutableString alloc] initWithString:self];
    [string ch_deleteLastComposedCharacterSequence];
    return string.copy;
}

- (NSString *)ch_stringByRemovingComposedCharacterSequenceAtIndex:(NSUInteger)index {
    NSMutableString *string = [[NSMutableString alloc] initWithString:self];
    [string ch_deleteComposedCharacterSequenceAtIndex:index];
    return string.copy;
}

- (NSString *)ch_stringByRemovingComposedCharacterSequenceInRange:(NSRange)range {
    NSMutableString *string = [[NSMutableString alloc] initWithString:self];
    [string ch_deleteComposedCharacterSequenceInRange:range];
    return string.copy;
}

#pragma mark - Check
- (BOOL)ch_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)ch_isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)ch_isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)ch_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

- (BOOL)ch_containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

#pragma mark - Hex String
- (NSString *)ch_hexString {
    NSData *data = self.ch_dataValue;
    return data.ch_hexString;
}

+ (NSString *)ch_stringWithHexString:(NSString *)hexString {
    NSData *data = [NSData ch_dataWithHexString:hexString];
    return data.ch_utf8String;
}

#pragma mark - URL String
- (NSString *)ch_stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped.copy;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)ch_stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)ch_stringByURLQueryUserInputEncode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet ch_URLQueryUserInputAllowedCharacterSet]];
}

- (NSString *)ch_stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return self;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result.copy;
}

#pragma mark - UTF32 String
+ (NSString *)ch_stringWithUTF32Char:(UTF32Char)char32 {
    char32 = NSSwapHostIntToLittle(char32);
    return [[NSString alloc] initWithBytes:&char32 length:4 encoding:NSUTF32LittleEndianStringEncoding];
}

+ (NSString *)ch_stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length {
    return [[NSString alloc] initWithBytes:(const void *)char32
                                    length:length * 4
                                  encoding:NSUTF32LittleEndianStringEncoding];
}

- (void)ch_enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block {
    NSString *str = self;
    if (range.location != 0 || range.length != self.length) {
        str = [self substringWithRange:range];
    }
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    UTF32Char *char32 = (UTF32Char *)[str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding];
    if (len == 0 || char32 == NULL) return;
    
    NSUInteger location = 0;
    BOOL stop = NO;
    NSRange subRange;
    UTF32Char oneChar;
    
    for (NSUInteger i = 0; i < len; i++) {
        oneChar = char32[i];
        subRange = NSMakeRange(location, oneChar > 0xFFFF ? 2 : 1);
        if (block) {
            block(oneChar, subRange, &stop);
        }
        if (stop) return;
        location += subRange.length;
    }
}

#pragma mark - Security String
- (NSString *)ch_securityString {
    NSUInteger length = self.ch_lengthOfComposedCharacterSequences;
    NSString *asteriskString = @"";
    while (length--) {
        asteriskString = [asteriskString stringByAppendingString:@"*"];
    }
    return asteriskString;
}

- (NSString *)ch_stingByReplacingWithAsteriskInRange:(NSRange)range {
    return [self ch_stingByReplacingWithSecurityString:@"*" range:range];
}

- (NSString *)ch_stingByReplacingWithSecurityString:(NSString *)replacement range:(NSRange)range {
    NSString *tempString = [NSString stringWithString:self];
    NSString *securityString = @"";
    NSUInteger length = range.length;
    while (length--) {
        securityString = [securityString stringByAppendingString:replacement];
    }
    return [tempString stringByReplacingOccurrencesOfString:[tempString substringWithRange:range] withString:securityString];
}

#pragma mark - Data Value
- (NSData *)ch_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Case Changing
- (NSString *)ch_firstCharacterUppercaseString {
    NSMutableString *buffer = [NSMutableString stringWithString:self];
    if (!self.length) return buffer.copy;
    
    [buffer ch_replaceComposedCharacterSequenceAtIndex:0 withString:[buffer ch_firstComposedCharacterSequences].uppercaseString];
    return buffer.copy;
}

- (NSString *)ch_firstCharacterLowercaseString {
    NSMutableString *buffer = [NSMutableString stringWithString:self];
    if (!self.length) return buffer.copy;
    
    [buffer ch_replaceComposedCharacterSequenceAtIndex:0 withString:[buffer ch_firstComposedCharacterSequences].lowercaseString];
    return buffer.copy;
}

#pragma mark - Pinyin
- (NSString *)ch_pinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL,
                      kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL,
                      kCFStringTransformStripDiacritics, false);
    return mutableString.copy;
}

#pragma mark - UUID
+ (NSString *)ch_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

#pragma mark - Number Value
- (NSNumber *)ch_numberValue {
    return [NSNumber ch_numberWithString:self];
}

- (char)ch_charValue {
    return self.ch_numberValue.charValue;
}

- (unsigned char)ch_unsignedCharValue {
    return self.ch_numberValue.unsignedCharValue;
}

- (short)ch_shortValue {
    return self.ch_numberValue.shortValue;
}

- (unsigned short)ch_unsignedShortValue {
    return self.ch_numberValue.unsignedShortValue;
}

- (int)ch_intValue {
    return self.intValue;
}

- (unsigned int)ch_unsignedIntValue {
    return self.ch_numberValue.unsignedIntValue;
}

- (long)ch_longValue {
    return self.ch_numberValue.longValue;
}

- (unsigned long)ch_unsignedLongValue {
    return self.ch_numberValue.unsignedLongValue;
}

- (long long)ch_longLongValue {
    return self.longLongValue;
}

- (unsigned long long)ch_unsignedLongLongValue {
    return self.ch_numberValue.unsignedLongLongValue;
}

- (float)ch_floatValue {
    return self.floatValue;
}

- (double)ch_doubleValue {
    return self.doubleValue;
}

- (BOOL)ch_boolValue {
    return self.boolValue;
}

- (NSInteger)ch_integerValue {
    return self.integerValue;
}

- (NSUInteger)ch_unsignedIntegerValue {
    return self.ch_numberValue.unsignedIntegerValue;
}

- (CGFloat)ch_CGFloatValue {
    return self.ch_numberValue.ch_CGFloatValue;
}

#pragma mark - Path String
NSString *CHNSDocumentsDirectory(void) {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *CHNSCachesDirectory(void) {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *CHNSLibraryDirectory(void) {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *CHNSTemporaryDirectory(void) {
    return NSTemporaryDirectory();
}

+ (NSString *)ch_documentsPathWithComponents:(NSArray<NSString *> *)components {
    NSString *componentsString = [NSString pathWithComponents:components];
    return [CHNSDocumentsDirectory() stringByAppendingPathComponent:componentsString];
}

+ (NSString *)ch_documentsPathWithComponent:(NSString *)component {
    return [CHNSDocumentsDirectory() stringByAppendingPathComponent:component];
}

+ (NSString *)ch_documentsPathWithLastPathComponent:(NSString *)lastPathComponent {
    return [CHNSDocumentsDirectory() stringByAppendingPathComponent:[lastPathComponent lastPathComponent]];
}

+ (NSString *)ch_cachesPathWithComponents:(NSArray<NSString *> *)components {
    NSString *componentsString = [NSString pathWithComponents:components];
    return [CHNSCachesDirectory() stringByAppendingPathComponent:componentsString];
}

+ (NSString *)ch_cachesPathWithComponent:(NSString *)component {
    return [CHNSCachesDirectory() stringByAppendingPathComponent:component];
}

+ (NSString *)ch_cachesPathWithLastPathComponent:(NSString *)lastPathComponent {
    return [CHNSCachesDirectory() stringByAppendingPathComponent:[lastPathComponent lastPathComponent]];
}

+ (NSString *)ch_libraryPathWithComponents:(NSArray<NSString *> *)components {
    NSString *componentsString = [NSString pathWithComponents:components];
    return [CHNSLibraryDirectory() stringByAppendingPathComponent:componentsString];
}

+ (NSString *)ch_libraryPathWithComponent:(NSString *)component {
    return [CHNSLibraryDirectory() stringByAppendingPathComponent:component];
}

+ (NSString *)ch_libraryPathWithLastPathComponent:(NSString *)lastPathComponent {
    return [CHNSLibraryDirectory() stringByAppendingPathComponent:[lastPathComponent lastPathComponent]];
}

+ (NSString *)ch_temporaryPathWithComponents:(NSArray<NSString *> *)components {
    NSString *componentsString = [NSString pathWithComponents:components];
    return [NSTemporaryDirectory() stringByAppendingPathComponent:componentsString];
}

+ (NSString *)ch_temporaryPathWithComponent:(NSString *)component {
    return [CHNSTemporaryDirectory() stringByAppendingPathComponent:component];
}

+ (NSString *)ch_temporaryPathWithLastPathComponent:(NSString *)lastPathComponent {
    return [CHNSTemporaryDirectory() stringByAppendingPathComponent:[lastPathComponent lastPathComponent]];
}

#pragma mark - File Size String
+ (NSString *)ch_stringFromFileSize:(int64_t)byte {
    if (byte < 0) return @"";
    // Byte
    if (byte < pow(10, 3)) return [NSString stringWithFormat:@"%lldByte", byte];
    
    NSDecimalNumber *number = nil;
    // KB
    if (byte < pow(10, 6)) {
        number = [NSDecimalNumber ch_decimalNumberWithDouble:byte/pow(10, 3) roundingScale:1];
        return [NSString stringWithFormat:@"%@KB", number];
    }
    // MB
    if (byte < pow(10, 9)) {
        number = [NSDecimalNumber ch_decimalNumberWithDouble:byte/pow(10, 6) roundingScale:1];
        return [NSString stringWithFormat:@"%@MB", number];
    }
    // GB
    number = [NSDecimalNumber ch_decimalNumberWithDouble:byte/pow(10, 9) roundingScale:1];
    return [NSString stringWithFormat:@"%@GB", number];
}

#pragma mark - Time String
+ (NSString *)ch_stringForStopWatchFormatWithSeconds:(NSTimeInterval)seconds {
    if (seconds < 0) return @"";
    
    NSUInteger minute = floor(seconds / 60);
    NSUInteger second = floor(seconds - minute * 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
}

@end


@implementation NSMutableString (CHBase)

#pragma mark - Base

#pragma mark - Composed Character Sequences
- (void)ch_replaceComposedCharacterSequenceInRange:(NSRange)range withString:(NSString *)aString {
    if (!self.length) return;
    if (!range.length) return;
    if (!aString) return;
    
    NSRange aRange = [self rangeOfComposedCharacterSequencesForRange:range];
    if (!aRange.length) return;
    
    [self replaceCharactersInRange:aRange withString:aString];
}

- (void)ch_replaceComposedCharacterSequenceAtIndex:(NSUInteger)index withString:(NSString *)aString {
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:index];
    if (!range.length) return;
    
    [self ch_replaceComposedCharacterSequenceInRange:range withString:aString];
}

- (void)ch_deleteFirstComposedCharacterSequence {
    return [self ch_deleteComposedCharacterSequenceAtIndex:0];
}

- (void)ch_deleteLastComposedCharacterSequence {
    return [self ch_deleteComposedCharacterSequenceAtIndex:self.length-1];
}

- (void)ch_deleteComposedCharacterSequenceAtIndex:(NSUInteger)index {
    if (!self.length) return;
    if (!index) return;
    
    NSRange aRange = [self rangeOfComposedCharacterSequenceAtIndex:index];
    if (!aRange.length) return;
    
    [self deleteCharactersInRange:aRange];
}

- (void)ch_deleteComposedCharacterSequenceInRange:(NSRange)range {
    if (!self.length) return;
    if (!range.length) return;
    
    NSRange aRange = [self rangeOfComposedCharacterSequencesForRange:range];
    if (!aRange.length) return;
    
    [self deleteCharactersInRange:aRange];
}

@end
