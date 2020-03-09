//
//  UIFont+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/10.
//  
//

#import "UIFont+CHBase.h"
#import <CoreText/CoreText.h>
#import "UIDevice+CHMachineInfo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"

#ifndef CH_FONT_CLAMP_FONT_VALUES
#define CH_FONT_CLAMP_VALUES(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

@implementation UIFont (CHBase)

#pragma mark - Base
- (CGFloat)ch_fontWeight {
    NSDictionary *traits = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    return [traits[UIFontWeightTrait] floatValue];
}

- (UIFont *)ch_fontWithBold {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:self.pointSize];
}

- (UIFont *)ch_fontWithItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)ch_fontWithBoldItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)ch_fontWithNormal {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:0] size:self.pointSize];
}

+ (UIFont *)ch_fontWithCTFont:(CTFontRef)CTFont {
    if (!CTFont) return nil;
    CFStringRef name = CTFontCopyPostScriptName(CTFont);
    if (!name) return nil;
    CGFloat size = CTFontGetSize(CTFont);
    UIFont *font = [self fontWithName:(__bridge NSString *)(name) size:size];
    CFRelease(name);
    return font;
}

+ (UIFont *)ch_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size {
    if (!CGFont) return nil;
    CFStringRef name = CGFontCopyPostScriptName(CGFont);
    if (!name) return nil;
    UIFont *font = [self fontWithName:(__bridge NSString *)(name) size:size];
    CFRelease(name);
    return font;
}

- (CTFontRef)ch_CTFontRef CF_RETURNS_RETAINED  { // Name CTFontRef <-> CTFontRef
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.pointSize, NULL);
    return font;
}

- (CGFontRef)ch_CGFontRef CF_RETURNS_RETAINED {
    CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)self.fontName);
    return font;
}

#pragma mark - Create
+ (UIFont *)ch_lightSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@".SFUIText-Light" size:fontSize];
}

+ (UIFont *)ch_systemFontOfSize:(CGFloat)pointSize weightType:(CHUIFontWeightType)weightType italic:(BOOL)italic {
    BOOL isLight = weightType == CHUIFontWeightTypeLight;
    BOOL isBold = weightType == CHUIFontWeightTypeBold;
    
    // UIFontDescriptor在iOS 10以下无法获取到 Light + Italic 的字体, 须写死
    if (![UIDevice currentDevice].ch_isiOS10Later) {
        NSString *name = @".SFUIText";
        NSString *fontSuffix = [NSString stringWithFormat:@"%@%@", isLight ? @"Light" : (isBold ? @"Bold" : @""), italic ? @"Italic" : @""];
        NSString *fontName = [NSString stringWithFormat:@"%@%@%@", name, fontSuffix.length > 0 ? @"-" : @"", fontSuffix];
        UIFont *font = [UIFont fontWithName:fontName size:pointSize];
        return font;
    }
    
    UIFont *font = nil;
    if (@available(iOS 8.2, *)) {
        font = [UIFont systemFontOfSize:pointSize weight:isLight ? UIFontWeightLight : (isBold ? UIFontWeightBold : UIFontWeightRegular)];
        
        if (!italic) return font;
    } else {
        font = [UIFont systemFontOfSize:pointSize];
    }
    
    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
    NSMutableDictionary<NSString *, id> *traitsAttribute = [NSMutableDictionary dictionaryWithDictionary:fontDescriptor.fontAttributes[UIFontDescriptorTraitsAttribute]];
    if (![UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        traitsAttribute[UIFontWeightTrait] = isLight ? @-1.0 : (isBold ? @1.0 : @0.0);
    }
    if (italic) {
        traitsAttribute[UIFontSlantTrait] = @1.0;
    } else {
        traitsAttribute[UIFontSlantTrait] = @0.0;
    }
    fontDescriptor = [fontDescriptor fontDescriptorByAddingAttributes:@{UIFontDescriptorTraitsAttribute: traitsAttribute}];
    font = [UIFont fontWithDescriptor:fontDescriptor size:0];
    return font;
}

+ (UIFont *)ch_dynamicSystemFontOfSize:(CGFloat)pointSize weightType:(CHUIFontWeightType)weightType italic:(BOOL)italic {
    return [self ch_dynamicSystemFontOfSize:pointSize minimumPointSize:0 maximumPointSize:pointSize + 5 weightType:weightType italic:italic];
}

+ (UIFont *)ch_dynamicSystemFontOfSize:(CGFloat)pointSize minimumPointSize:(CGFloat)minimumPointSize maximumPointSize:(CGFloat)maximumPointSize weightType:(CHUIFontWeightType)weightType italic:(BOOL)italic {
    // 根据UIFontTextStyleBody类型与默认大小的变化程度, 推算整体变化
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGFloat offsetPointSize = font.pointSize - 17;// default UIFontTextStyleBody fontSize is 17
    CGFloat finalPointSize = pointSize + offsetPointSize;
    CH_FONT_CLAMP_VALUES(finalPointSize, minimumPointSize, maximumPointSize);
    return [UIFont ch_systemFontOfSize:finalPointSize weightType:weightType italic:NO];
}

#pragma mark - Check
- (BOOL)ch_isBold {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO; // fontDescriptor:文字描述符
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0; 
}

- (BOOL)ch_isItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
}

- (BOOL)ch_isMonoSpace {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitMonoSpace) > 0;
}

- (BOOL)ch_isColorGlyphs {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (CTFontGetSymbolicTraits((__bridge CTFontRef)self) & kCTFontTraitColorGlyphs) != 0;
}

#pragma mark - Load & Unload 
+ (BOOL)ch_loadFontFromPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CFErrorRef error;
    BOOL suc = CTFontManagerRegisterFontsForURL((__bridge CFTypeRef)url, kCTFontManagerScopeNone, &error); // 加载字体
    if (!suc) {
        NSLog(@"Failed to load font: %@", error);
    }
    return suc;
}

+ (void)ch_unloadFontFromPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CTFontManagerUnregisterFontsForURL((__bridge CFTypeRef)url, kCTFontManagerScopeNone, NULL);
}

+ (UIFont *)ch_loadFontFromData:(NSData *)data {
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    if (!provider) return nil;
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    CGDataProviderRelease(provider);
    if (!fontRef) return nil;
    
    CFErrorRef errorRef;
    BOOL suc = CTFontManagerRegisterGraphicsFont(fontRef, &errorRef);
    if (!suc) {
        CFRelease(fontRef);
        NSLog(@"%@", errorRef);
        return nil;
    } else {
        CFStringRef fontName = CGFontCopyPostScriptName(fontRef);
        UIFont *font = [UIFont fontWithName:(__bridge NSString *)(fontName) size:[UIFont systemFontSize]];
        if (fontName) CFRelease(fontName);
        CGFontRelease(fontRef);
        return font;
    }
}

+ (BOOL)ch_unloadFontFromData:(UIFont *)font {
    CGFontRef fontRef = CGFontCreateWithFontName((__bridge CFStringRef)font.fontName);
    if (!fontRef) return NO;
    CFErrorRef errorRef;
    BOOL suc = CTFontManagerUnregisterGraphicsFont(fontRef, &errorRef);
    CFRelease(fontRef);
    if (!suc) NSLog(@"%@", errorRef);
    return suc;
}

#pragma mark - Font Data
+ (NSData *)ch_dataFromFont:(UIFont *)font {
    CGFontRef cgFont = font.ch_CGFontRef;
    NSData *data = [self ch_dataFromCGFont:cgFont];
    CGFontRelease(cgFont);
    return data;
}

typedef struct CHFontHeader {
    int32_t fVersion;
    uint16_t fNumTables;
    uint16_t fSearchRange;
    uint16_t fEntrySelector;
    uint16_t fRangeShift;
} CHFontHeader;

typedef struct CHTableEntry {
    uint32_t fTag;
    uint32_t fCheckSum;
    uint32_t fOffset;
    uint32_t fLength;
} CHTableEntry;

static uint32_t CHCalcTableCheckSum(const uint32_t *table, uint32_t numberOfBytesInTable)
{
    uint32_t sum = 0;
    uint32_t nLongs = (numberOfBytesInTable + 3) / 4;
    while (nLongs-- > 0) {
        sum += CFSwapInt32HostToBig(*table++);
    }
    return sum;
}

//Reference:
//https://github.com/google/skia/blob/master/src%2Fports%2FSkFontHost_mac.cpp
+ (NSData *)ch_dataFromCGFont:(CGFontRef)cgFont {
    if (!cgFont) return nil;
    
    CFRetain(cgFont);
    
    CFArrayRef tags = CGFontCopyTableTags(cgFont);
    if (!tags) {
        CFRelease(cgFont);
        return nil;
    }
    CFIndex tableCount = CFArrayGetCount(tags);
    
    size_t *tableSizes = malloc(sizeof(size_t) * tableCount);
    memset(tableSizes, 0, sizeof(size_t) * tableCount);
    
    BOOL containsCFFTable = NO;
    
    size_t totalSize = sizeof(CHFontHeader) + sizeof(CHTableEntry) * tableCount;
    
    for (CFIndex index = 0; index < tableCount; index++) {
        size_t tableSize = 0;
        uint32_t aTag = (uint32_t)CFArrayGetValueAtIndex(tags, index);
        if (aTag == kCTFontTableCFF && !containsCFFTable) {
            containsCFFTable = YES;
        }
        CFDataRef tableDataRef = CGFontCopyTableForTag(cgFont, aTag);
        if (tableDataRef) {
            tableSize = CFDataGetLength(tableDataRef);
            CFRelease(tableDataRef);
        }
        totalSize += (tableSize + 3) & ~3;
        tableSizes[index] = tableSize;
    }
    
    unsigned char *stream = malloc(totalSize);
    memset(stream, 0, totalSize);
    char *dataStart = (char *)stream;
    char *dataPtr = dataStart;
    
    // compute font header entries
    uint16_t entrySelector = 0;
    uint16_t searchRange = 1;
    while (searchRange < tableCount >> 1) {
        entrySelector++;
        searchRange <<= 1;
    }
    searchRange <<= 4;
    
    uint16_t rangeShift = (tableCount << 4) - searchRange;
    
    // write font header (also called sfnt header, offset subtable)
    CHFontHeader *offsetTable = (CHFontHeader *)dataPtr;
    
    //OpenType Font contains CFF Table use 'OTTO' as version, and with .otf extension
    //otherwise 0001 0000
    offsetTable->fVersion = containsCFFTable ? 'OTTO' : CFSwapInt16HostToBig(1);
    offsetTable->fNumTables = CFSwapInt16HostToBig((uint16_t)tableCount);
    offsetTable->fSearchRange = CFSwapInt16HostToBig((uint16_t)searchRange);
    offsetTable->fEntrySelector = CFSwapInt16HostToBig((uint16_t)entrySelector);
    offsetTable->fRangeShift = CFSwapInt16HostToBig((uint16_t)rangeShift);
    
    dataPtr += sizeof(CHFontHeader);
    
    // write tables
    CHTableEntry *entry = (CHTableEntry *)dataPtr;
    dataPtr += sizeof(CHTableEntry) * tableCount;
    
    for (int index = 0; index < tableCount; ++index) {
        uint32_t aTag = (uint32_t)CFArrayGetValueAtIndex(tags, index);
        CFDataRef tableDataRef = CGFontCopyTableForTag(cgFont, aTag);
        size_t tableSize = CFDataGetLength(tableDataRef);
        
        memcpy(dataPtr, CFDataGetBytePtr(tableDataRef), tableSize);
        
        entry->fTag = CFSwapInt32HostToBig((uint32_t)aTag);
        entry->fCheckSum = CFSwapInt32HostToBig(CHCalcTableCheckSum((uint32_t *)dataPtr, (uint32_t)tableSize));
        
        uint32_t offset = (uint32_t)dataPtr - (uint32_t)dataStart;
        entry->fOffset = CFSwapInt32HostToBig((uint32_t)offset);
        entry->fLength = CFSwapInt32HostToBig((uint32_t)tableSize);
        dataPtr += (tableSize + 3) & ~3;
        ++entry;
        CFRelease(tableDataRef);
    }
    
    CFRelease(cgFont);
    CFRelease(tags);
    free(tableSizes);
    NSData *fontData = [NSData dataWithBytesNoCopy:stream length:totalSize freeWhenDone:YES];
    return fontData;
}

@end

#pragma clang diagnostic pop
