//
//  NSString+CHBase.h
//  CHCategories
//
//  Created by CHwang on 16/12/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, CHNSStringSubstringConversionOptions) { ///< 子字符串转化处理方式
    CHNSStringSubstringConversionByAvoidBreakingUpCharacterSequences = 1, ///< 避免将合成字符序列(A一1️⃣)拆散
    /**
     合成字符序列长度固定(例: 字符串"😊😞", 长度为4，在该模式下，(0, 1)得到的是空字符串，(0, 2)得到的是"😊". 否则, (0, 1)或(0, 2), 得到的都是"😊", CHNSStringSubstringConversionByAvoidBreakingUpCharacterSequences下启用)
     */
    CHNSStringSubstringConversionByCharacterSequencesLengthRequired = 1 << 1,
    /**
     按照ASCII字符为1个字节, 非ASCII字符为2个字节的编码方式来处理(CHNSStringSubstringConversionByAvoidBreakingUpCharacterSequences下启用)
     */
    CHNSStringSubstringConversionByUsingNonASCIICharacterAsTwoEncoding = 1 << 2,
};

@interface NSString (CHBase)

#pragma mark - Base
/**
 获取字符串的全范围(NSMakeRange(0, string.length))
 
 @return 字符串的全范围
 */
- (NSRange)ch_rangeOfAll;

/**
 根据MainBundle内的文件名, 获取路径下文本包含的字符串(a.txt, 或为nil)
 
 @param name 文件名
 @return 文本包含的字符串(或为nil)
 */
+ (NSString *)ch_stringNamed:(NSString *)name;

/**
 获取ASCII字符为1个字节, 非ASCII字符为2个字节的编码方式下的字符串长度
 */
@property (nonatomic, readonly) NSUInteger ch_lengthOfUsingNonASCIICharacterAsTwoEncoding;

/**
 获取参数列表拼接成的字符串

 @param obj 参数集
 @return 字符串
 */
+ (NSString *)ch_stringByConcat:(id)obj, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Substring
/**
 获取指定子字符串的所有范围集(NSValue -> NSRange)

 @param substring 指定子字符串
 @return 指定子字符串的所有范围集(NSValue -> NSRange)
 */
- (NSArray<NSValue *> *)ch_rangesOfSubstring:(NSString *)substring;

/**
 根据范围, 获取指定子字符串的范围集(NSValue -> NSRange)

 @param substring 指定子字符串
 @param range     范围
 @return 指定子字符串的范围集(NSValue -> NSRange)
 */
- (NSArray<NSValue *> *)ch_rangesOfSubstring:(NSString *)substring inRange:(NSRange)range;

/**
 获取所有子字符串集(使用substringWithRange:)

 @return 所有子字符串集
 */
- (NSArray<NSString *> *)ch_substrings;

/**
 获取指定范围内的所有子字符串集(使用substringWithRange:)

 @param range 指定范围
 @return 指定范围内的所有子字符串集
 */
- (NSArray<NSString *> *)ch_substringsInRange:(NSRange)range;

/**
  根据字符串过滤回调处理, 获取指定范围内的所有子字符串集(使用substringWithRange:)

 @param range 指定范围
 @param block 过滤回调处理(返回YES, 子字符串加入数组, 否则不添加, substring:子字符串, substringRange:子字符串范围, *stop:是否停止添加)
 @return 指定范围内的所有子字符串集
 */
- (NSArray<NSString *> *)ch_substringsInRange:(NSRange)range usingBlock:(BOOL (^)(NSString *substring, NSRange substringRange, BOOL *stop))block;

/**
 根据字符串遍历方式, 获取指定范围内的所有子字符串集

 @param range 指定范围
 @param opts  字符串遍历方式
 @return 指定范围内的所有子字符串集
 */
- (NSArray<NSString *> *)ch_substringsInRange:(NSRange)range options:(NSStringEnumerationOptions)opts;

/**
 根据字符串遍历方式及过滤回调处理, 获取指定范围内的所有子字符串集

 @param range 指定范围
 @param opts 字符串遍历方式
 @param block 过滤回调处理(返回YES, 子字符串加入数组, 否则不添加, substring:子字符串, substringRange:子字符串范围, enclosingRange:嵌套字符串范围, *stop:是否停止添加)
 @return 指定范围内的所有子字符串集
 */
- (NSArray<NSString *> *)ch_substringsInRange:(NSRange)range
                                      options:(NSStringEnumerationOptions)opts
                                   usingBlock:(BOOL (^)(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop))block;

/**
 根据子字符串转化处理方式, 获取从当前索引位置至结尾的子字符

 @param from 当前索引
 @param option 子字符串转化处理方式
 @return 子字符
 */
- (NSString *)ch_substringFromIndex:(NSUInteger)from option:(CHNSStringSubstringConversionOptions)option;

/**
 根据子字符串转化处理方式, 获取首端至指定索引位置的子字符

 @param to 指定索引
 @param option 子字符串转化处理方式
 @return 子字符
 */
- (NSString *)ch_substringToIndex:(NSUInteger)to option:(CHNSStringSubstringConversionOptions)option;

/**
 根据子字符串转化处理方式, 获取指定范围内的子字符

 @param range 指定范围
 @param option 子字符串转化处理方式
 @return 子字符
 */
- (NSString *)ch_substringWithRange:(NSRange)range option:(CHNSStringSubstringConversionOptions)option;

#pragma mark - Composed Character Sequences
/**
 获取字符串的合成字符序列的长度(@"A一1️⃣".length -> 5, "A一1️⃣".lengthOfComposedCharacterSequences -> 3)
 */
@property (nonatomic, readonly) NSUInteger ch_lengthOfComposedCharacterSequences;

/**
 获取字符串的首个合成字符序列(或为nil)

 @return 合成字符序列
 */
- (NSString *)ch_firstComposedCharacterSequences;

/**
 获取字符串的最末的合成字符序列(或为nil)

 @return 合成字符序列
 */
- (NSString *)ch_lastComposedCharacterSequences;

/**
 根据索引, 获取索引指向位置的合成字符序列(或为nil, 索引范围在[0, string.length-1]内)

 @param index 索引
 @return 合成字符序列
 */
- (NSString *)ch_composedCharacterSequencesAtIndex:(NSUInteger)index;

/**
 根据索引, 获取索引指向位置起到字符串末尾的合成字符序列(或为nil)

 @param index 索引
 @return 合成字符序列
 */
- (NSString *)ch_composedCharacterSequencesFromIndex:(NSUInteger)index;

/**
 根据索引, 获取字符串起点至索引指向位置的合成字符序列(或为nil)

 @param index 索引
 @return 合成字符序列
 */
- (NSString *)ch_composedCharacterSequencesToIndex:(NSUInteger)index;

/**
 根据范围, 获取范围内的合成字符序列(或为nil)

 @param range 范围
 @return 合成字符序列
 */
- (NSString *)ch_composedCharacterSequencesWithRange:(NSRange)range;

/**
 获取字符串的合成字符序列数组

 @return 字符串的合成字符序列数组
 */
- (NSArray<NSString *> *)ch_composedCharacterSequences;

/**
 将字符串的合成字符序列(A/一/1️⃣)替换为指定字符串

 @param replacement 指定字符串
 @return 新字符串
 */
- (NSString *)ch_stringByReplacingComposedCharacterSequencesWithString:(NSString *)replacement;

/**
 获取移除首个合成字符序列(A/一/1️⃣)的字符串

 @return 新字符串
 */
- (NSString *)ch_stringByRemovingFirstComposedCharacterSequence;

/**
 获取移除最后一个合成字符序列(A/一/1️⃣)的字符串
 
 @return 新字符串
 */
- (NSString *)ch_stringByRemovingLastComposedCharacterSequence;

/**
 获取移除索引指向的合成字符序列(A/一/1️⃣)的字符串

 @param index 索引
 @return 新字符串
 */
- (NSString *)ch_stringByRemovingComposedCharacterSequenceAtIndex:(NSUInteger)index;

/**
 获取移除字符串中指定范围内的合成字符序列(A/一/1️⃣)的字符串

 @param range 指定范围
 @return 新字符串
 */
- (NSString *)ch_stringByRemovingComposedCharacterSequenceInRange:(NSRange)range;

#pragma mark - Check
/**
 字符串是否不为空(nil, @"", @"  ", @"\n")

 @return 不为空返回YES, 否则返回NO
 */
- (BOOL)ch_isNotBlank;

/**
 字符串数值是否为int类型

 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isPureInt;

/**
 字符串数值是否为float类型

 @return 是返回YES, 否则返回NOå
 */
- (BOOL)ch_isPureFloat;

/**
 是否包含指定字符串

 @param string 指定字符串
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsString:(NSString *)string;

/**
 是否包含指定Character字符集内字符

 @param set 指定Character字符集
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsCharacterSet:(NSCharacterSet *)set;

#pragma mark - Hex String
/**
 获取字符串的十六进制字符串

 @return 十六进制字符串
 */
- (NSString *)ch_hexString;

/**
 根据十六进制字符串, 获取新字符串

 @param hexString 十六进制字符串
 @return 新字符串
 */
+ (NSString *)ch_stringWithHexString:(NSString *)hexString;

#pragma mark - URL String
/**
 获取URL编码后(UTF-8)的string
 
 @return URL编码后(UTF-8)的string
 */
- (NSString *)ch_stringByURLEncode;

/**
 获取URL解码后(UTF-8)的string
 
 @return 解码后(UTF-8)的string
 */
- (NSString *)ch_stringByURLDecode;

/**
  获取URL Query User Input编码后的string(在URLQueryAllowedCharacterSet基础上去除“#&=“字符, 用于URL Query里来源于用户输入的Value，避免服务器解析出现异常)

 @return URL Query User Input编码后的string
 */
- (NSString *)ch_stringByURLQueryUserInputEncode;

/**
 获取一般HTML转义后的string ("a>b" -> "a&gt;b")
 
 @return HTML转义后的string
 */
- (NSString *)ch_stringByEscapingHTML;

#pragma mark - UTF32 String
/**
 根据UTF32字符, 获取新字符串
 
 @param char32 UTF32字符
 @return 新字符串
 */
+ (NSString *)ch_stringWithUTF32Char:(UTF32Char)char32;

/**
 根据UTF32字符组, 获取新字符串
 
 @param char32 UTF32字符组,
 @param length 需获取的字符组长度
 @return 新字符串
 */
+ (NSString *)ch_stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length;

/**
 根据范围, 遍历UTF32字符
 
 @param range 遍历范围
 @param block 处理遍历回调(char32:字符, range:当前遍历范围, *stop:是否停止遍历)
 */
- (void)ch_enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block;

#pragma mark - Security String
/**
 将字符串的所有合成字符序列替换为*
 
 @return 新字符串
 */
- (NSString *)ch_securityString;

/**
 根据替换范围, 将替换范围内的字符串替换为*(混合字符串<@"1😀🇺🇸">或有问题)
 
 @param range 替换范围
 @return 新字符串
 */
- (NSString *)ch_stingByReplacingWithAsteriskInRange:(NSRange)range;

/**
 根据替换范围, 将替换范围内的字符串替换为指定字符(混合字符串<@"1😀🇺🇸">或有问题)
 
 @param replacement 指定替换字符
 @param range       替换范围
 @return 新字符串
 */
- (NSString *)ch_stingByReplacingWithSecurityString:(NSString *)replacement range:(NSRange)range;

#pragma mark - Data Value
/**
 根据字符串, 获取UTF-8编码的NSData对象(NSString -> NSData)
 
 @return NSData对象
 */
- (NSData *)ch_dataValue;

#pragma mark - Case Changing
/**
 获取首字母大写的字符串
 */
@property (readonly, copy) NSString *ch_firstCharacterUppercaseString;

/**
 获取首字母小写的字符串
 */
@property (readonly, copy) NSString *ch_firstCharacterLowercaseString;

#pragma mark - Pinyin
/**
 获取字符串的拼音字符(罗马音)
 
 @return 新字符串
 */
- (NSString *)ch_pinyin;

#pragma mark - UUID
/**
 获取新的UUID字符串
 
 @return 新的UUID字符串
 */
+ (NSString *)ch_stringWithUUID;

#pragma mark - Number Value
/**
 根据字符串, 获取NSNumber数值(@"1" -> @1, 或为nil)
 
 @return 字符串对应的NSNumber对象(或为nil)
 */
- (NSNumber *)ch_numberValue;

@property (readonly) char ch_charValue;                           ///< 字符串对应的NSNumber对象的char值
@property (readonly) unsigned char ch_unsignedCharValue;          ///< 字符串对应的NSNumber对象的unsignedChar值
@property (readonly) short ch_shortValue;                         ///< 字符串对应的NSNumber对象的short值
@property (readonly) unsigned short ch_unsignedShortValue;        ///< 字符串对应的NSNumber对象的unsignedShort值
@property (readonly) int ch_intValue;                             ///< 字符串对应的NSNumber对象的int值
@property (readonly) unsigned int ch_unsignedIntValue;            ///< 字符串对应的NSNumber对象的unsignedInt值
@property (readonly) long ch_longValue;                           ///< 字符串对应的NSNumber对象的long值
@property (readonly) unsigned long ch_unsignedLongValue;          ///< 字符串对应的NSNumber对象的unsignedLong值
@property (readonly) long long ch_longLongValue;                  ///< 字符串对应的NSNumber对象的longLong值
@property (readonly) unsigned long long ch_unsignedLongLongValue; ///< 字符串对应的NSNumber对象的unsignedLongLong值
@property (readonly) float ch_floatValue;                         ///< 字符串对应的NSNumber对象的float值
@property (readonly) double ch_doubleValue;                       ///< 字符串对应的NSNumber对象的double值
@property (readonly) BOOL ch_boolValue;                           ///< 字符串对应的NSNumber对象的bool值
@property (readonly) NSInteger ch_integerValue;                   ///< 字符串对应的NSNumber对象的integer值
@property (readonly) NSUInteger ch_unsignedIntegerValue;          ///< 字符串对应的NSNumber对象的unsignedInteger值
@property (readonly) CGFloat ch_CGFloatValue;                     ///< 字符串对应的NSNumber对象的CGFloat值

#pragma mark - Path String
/**
 获取当前用户Documents文件夹路径
 
 @return 当前用户Documents文件夹路径
 */
FOUNDATION_EXPORT NSString *CHNSDocumentsDirectory(void);

/**
 获取当前用户Caches文件夹路径
 
 @return 获取当前用户Caches文件夹路径
 */
FOUNDATION_EXPORT NSString *CHNSCachesDirectory(void);

/**
 获取当前用户Library文件夹路径
 
 @return 当前用户Library文件夹路径
 */
FOUNDATION_EXPORT NSString *CHNSLibraryDirectory(void);

/**
 获取当前用户Temp文件夹路径
 
 @return 当前用户Temp文件夹路径
 */
FOUNDATION_EXPORT NSString *CHNSTemporaryDirectory(void);

/**
 根据路径子节点集, 获取应用documents文件夹路径拼接后的新路径
 
 @param components 路径子节点集
 @return 新路径
 */
+ (NSString *)ch_documentsPathWithComponents:(NSArray<NSString *> *)components;

/**
 根据路径子节点, 获取应用documents文件夹路径拼接后的新路径
 
 @param component 路径子节点
 @return 新路径
 */
+ (NSString *)ch_documentsPathWithComponent:(NSString *)component;

/**
 根据路径最末子节点, 获取应用documents文件夹路径拼接后的新路径
 
 @param lastPathComponent 路径最末子节点
 @return 新路径
 */
+ (NSString *)ch_documentsPathWithLastPathComponent:(NSString *)lastPathComponent;

/**
 根据路径子节点集, 获取应用caches文件夹路径拼接后的新路径
 
 @param components 路径子节点集
 @return 新路径
 */
+ (NSString *)ch_cachesPathWithComponents:(NSArray<NSString *> *)components;

/**
 根据路径子节点, 获取应用caches文件夹路径拼接后的新路径
 
 @param component 路径子节点
 @return 新路径
 */
+ (NSString *)ch_cachesPathWithComponent:(NSString *)component;

/**
 根据路径最末子节点, 获取应用caches文件夹路径拼接后的新路径
 
 @param lastPathComponent 路径最末子节点
 @return 新路径
 */
+ (NSString *)ch_cachesPathWithLastPathComponent:(NSString *)lastPathComponent;

/**
 根据路径子节点集, 获取应用library文件夹路径拼接后的新路径
 
 @param components 路径子节点集
 @return 新路径
 */
+ (NSString *)ch_libraryPathWithComponents:(NSArray<NSString *> *)components;

/**
 根据路径子节点, 获取应用library文件夹路径拼接后的新路径
 
 @param component 路径子节点
 @return 新路径
 */
+ (NSString *)ch_libraryPathWithComponent:(NSString *)component;

/**
 根据路径最末子节点, 获取应用library文件夹路径拼接后的新路径
 
 @param lastPathComponent 路径最末子节点
 @return 新路径
 */
+ (NSString *)ch_libraryPathWithLastPathComponent:(NSString *)lastPathComponent;

/**
 根据路径子节点集, 获取应用temp文件夹路径拼接后的新路径
 
 @param components 路径子节点集
 @return 新路径
 */
+ (NSString *)ch_temporaryPathWithComponents:(NSArray<NSString *> *)components;

/**
 根据路径子节点, 获取应用temp文件夹路径拼接后的新路径
 
 @param component 路径子节点
 @return 新路径
 */
+ (NSString *)ch_temporaryPathWithComponent:(NSString *)component;

/**
 根据路径最末子节点, 获取应用temp文件夹路径拼接后的新路径
 
 @param lastPathComponent 路径最末子节点
 @return 新路径
 */
+ (NSString *)ch_temporaryPathWithLastPathComponent:(NSString *)lastPathComponent;

#pragma mark - File Size String
/**
 根据文件大小(单位字节), 获取文件大小显示字符串(GB/MB/KB/Byte, 默认最大保留一位小数)
 
 @param byte 文件大小
 @return 文件大小显示字符串
 */
+ (NSString *)ch_stringFromFileSize:(int64_t)byte;

#pragma mark - Time String
/**
 根据秒数, 获取秒表计时格式的时间字符串(80->"01:20")

 @param seconds 秒数
 @return 秒表计时格式的时间字符串(80->"01:20", 秒数小于0则返回nil)
 */
+ (NSString *)ch_stringForStopWatchFormatWithSeconds:(NSTimeInterval)seconds;

@end


@interface NSMutableString (CHBase)

#pragma mark - Base

#pragma mark - Composed Character Sequences
/**
 将索引指向位置的合成字符序列(A/一/1️⃣)替换为指定字符串

 @param index   索引
 @param aString 指定字符串
 */
- (void)ch_replaceComposedCharacterSequenceAtIndex:(NSUInteger)index withString:(NSString *)aString;

/**
 将字符串指定范围内的合成字符序列(A/一/1️⃣)替换为指定字符串

 @param range   指定范围
 @param aString 指定字符串
 */
- (void)ch_replaceComposedCharacterSequenceInRange:(NSRange)range withString:(NSString *)aString;

/**
 移除字符串的首个合成字符序列(A/一/1️⃣)
 */
- (void)ch_deleteFirstComposedCharacterSequence;

/**
 移除字符串的最后一个合成字符序列(A/一/1️⃣)
 */
- (void)ch_deleteLastComposedCharacterSequence;

/**
 移除字符串中索引指向的合成字符序列(A/一/1️⃣)

 @param index 索引
 */
- (void)ch_deleteComposedCharacterSequenceAtIndex:(NSUInteger)index;

/**
 移除字符串中指定范围内的合成字符序列(A/一/1️⃣)

 @param range 指定范围
 */
- (void)ch_deleteComposedCharacterSequenceInRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
