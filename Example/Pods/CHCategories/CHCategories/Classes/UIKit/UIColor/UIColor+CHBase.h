//
//  UIColor+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/9.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CHBase)

#pragma mark - Base
@property (nonatomic, readonly) CGFloat ch_alpha; ///< 获取颜色的Alpha值[0,1]

@property (nonatomic, readonly) CGFloat ch_redOfRGBA;   ///< 获取RGB/RGBA中的R值[0,1]
@property (nonatomic, readonly) CGFloat ch_greenOfRGBA; ///< 获取RGB/RGBA中的G值[0,1]
@property (nonatomic, readonly) CGFloat ch_blueOfRGBA;  ///< 获取RGB/RGBA中的B值[0,1]

/**
 获取颜色的RGB值(以Hex表示:0x66ccff)

 @return 颜色的RGB值(以Hex表示:0x66ccff)
 */
- (uint32_t)ch_RGBValue;

/**
  获取颜色的RGBA值(以Hex表示:0x66ccffff)

 @return 颜色的RGBA值(以Hex表示:0x66ccffff)
 */
- (uint32_t)ch_RGBAValue;

/**
 获取表示RGB颜色的Hex值字符串(@"0066cc")

 @return RGB颜色的Hex值字符串(@"0066cc")
 */
- (NSString *)ch_hexString;

/**
 获取表示RGBA颜色的HEX值字符串(@"0066ccff")

 @return 表示RGBA颜色的HEX值字符串(@"0066ccff")
 */
- (NSString *)ch_hexStringWithAlpha;

#pragma mark - Check
/**
 判断两个颜色的RGBA值是否一致

 @param otherColor 其他颜色
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isEqualToColor:(UIColor *)otherColor;

/**
 当前颜色是否为iOS系统的默认Tint Color
 */
@property (nonatomic, readonly) BOOL ch_isiOSDefaultTintColor;

@property (nonatomic, readonly) BOOL ch_isDarkColor;  ///< 当前颜色是否为深色
@property (nonatomic, readonly) BOOL ch_isLightColor; ///< 当前颜色是否为浅色

#pragma mark - Create
/**
 获取RGB随机颜色
 
 @return RGB随机颜色
 */
+ (UIColor *)ch_randomColor;

/**
 获取iOS系统的默认Tint Color

 @return iOS系统的默认Tint Color
 */
+ (UIColor *)ch_iOSDefaultTintColor;

/**
 获取RGB随机R值的颜色
 
 @return RGB随机R值的颜色
 */
+ (UIColor *)ch_colorWithRandomRed;

/**
 获取RGB随机G值的颜色
 
 @return RGB随机G值的颜色;
 */
+ (UIColor *)ch_colorWithRandomGreen;

/**
 获取RGB随机B值的颜色
 
 @return RGB随机B值的颜色
 */
+ (UIColor *)ch_colorWithRandomBlue;

/**
 根据颜色的RGB值(以Hex表示:0x66cc), 获取颜色

 @param RGBValue 颜色的RGB值(以Hex表示:0x66cc)
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithRGB:(uint32_t)RGBValue;

/**
 根据颜色的RGBA值(以Hex表示:0x66ccff), 获取颜色

 @param RGBAValue 颜色的RGBA值(以Hex表示:0x66ccff)
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithRGBA:(uint32_t)RGBAValue;

/**
 根据颜色的RGB值(以Hex表示:0x66cc)和Alpha值, 获取颜色

 @param RGBValue 颜色的RGB值(以Hex表示:0x66cc)
 @param alpha    Alpha值
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithRGB:(uint32_t)RGBValue alpha:(CGFloat)alpha;

/**
 根据Hex字符串(#000||#0000||#00000||#00000000||0X000||0X0000||0X00000||0X00000000), 获取颜色

 @param hexString Hex字符串
 @return 对应的颜色
 */
+ (nullable UIColor *)ch_colorWithHexString:(NSString *)hexString;

/**
 根据Hex(#000||#0000||#00000||#00000000||0X000||0X0000||0X00000||0X00000000)和Alpha值, 获取颜色

 @param hexString Hex字符串
 @param alpha     Alpha值
 @return 对应的颜色
 */
+ (nullable UIColor *)ch_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 根据前置颜色, 目标颜色及变化程度, 创建颜色

 @param fromColor 前置颜色
 @param toColor 目标颜色
 @param delta 变化程度[0,1]
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithColor:(UIColor *)fromColor
                       toColor:(UIColor *)toColor
                         delta:(CGFloat)delta;

/**
 根据前景色及后景色, 创建颜色

 @param frontColor 前景色
 @param backendColor 后景色
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithFrontColor:(UIColor *)frontColor backendColor:(UIColor *)backendColor;

#pragma mark - Modify
/**
 根据添加的颜色及混合模式, 获取修改后的颜色

 @param addColor  添加的颜色
 @param blendMode 混合模式
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByAddColor:(UIColor *)addColor blendMode:(CGBlendMode)blendMode;

/**
 根据颜色Alpha值的变化, 获取修改后的颜色

 @param alphaDelta  Alpha的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByChangeAlpha:(CGFloat)alphaDelta;

/**
 根据颜色Red值的变化, 获取修改后的颜色

 @param redDelta Red(RGB/RGBA)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeRed:(CGFloat)redDelta;

/**
 根据颜色Green值的变化, 获取修改后的颜色

 @param greenDelta Green(RGB/RGBA)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeGreen:(CGFloat)greenDelta;

/**
 根据颜色Blue值的变化, 获取修改后的颜色

 @param blueDelta Blue(RGB/RGBA)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeBlue:(CGFloat)blueDelta;

/**
 根据颜色Red, Green, Blue和Alpha值的变化, 获取修改后的颜色

 @param redDelta   Red(RGB/RGBA)的变化值[-1,1](0, 不变)
 @param greenDelta Green(RGB/RGBA)的变化值[-1,1](0, 不变)
 @param blueDelta  Blue(RGB/RGBA)的变化值[-1,1](0, 不变)
 @param alphaDelta Alpha的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeRed:(CGFloat)redDelta
                                    green:(CGFloat)greenDelta
                                     blue:(CGFloat)blueDelta
                                    alpha:(CGFloat)alphaDelta;

/**
 根据目标颜色及变化程度, 获取修改后的颜色

 @param color 目标颜色
 @param delta 变化程度[0,1]
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByChangeToColor:(UIColor *)color delta:(CGFloat)delta;

/**
 获取无Alpha通道的颜色

 @return 修改后的颜色
 */
- (UIColor *)ch_colorByChangeWithoutAlpha;

/**
 根据Alpha值, 获取叠加Alpha后放在白色背景颜色上的颜色

 @param alpha Alpha值
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByAddToWhiteBackgroundColorWithAlpha:(CGFloat)alpha;

/**
 根据指定背景颜色及Alpha值, 获取叠加Alpha后放在指定背景颜色上的颜色

 @param backgroundColor 指定背景颜色
 @param alpha Alpha值
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByAddToBackgroundColor:(UIColor *)backgroundColor alpha:(CGFloat)alpha;

/**
 获取颜色的反色

 @return 修改后的颜色
 */
- (UIColor *)ch_colorByInverted;

#pragma mark - Color Space Info
@property (nonatomic, readonly) CGColorSpaceModel ch_colorSpaceModel; ///< 获取颜色的颜色空间
@property (nonatomic, readonly) NSString *ch_colorSpaceString;        ///< 获取颜色的颜色空间(字符串)

#pragma mark - Convert
/**
 RGB颜色转换为HSL颜色
 */
UIKIT_EXTERN void CHRGB2HSL(CGFloat red, CGFloat green, CGFloat blue,
                            CGFloat *hue, CGFloat *saturation, CGFloat *lightness);

/**
 HSL颜色转换为RGB颜色
 */
UIKIT_EXTERN void CHHSL2RGB(CGFloat hue, CGFloat saturation, CGFloat lightness,
                            CGFloat *red, CGFloat *green, CGFloat *blue);

/**
 RGB颜色转换为HSB颜色
 */
UIKIT_EXTERN void CHRGB2HSB(CGFloat red, CGFloat green, CGFloat blue,
                            CGFloat *hue, CGFloat *saturation, CGFloat *value);

/**
 HSB颜色转换为RGB颜色
 */
UIKIT_EXTERN void CHHSB2RGB(CGFloat hue, CGFloat saturation, CGFloat value,
                            CGFloat *red, CGFloat *green, CGFloat *blue);

/**
 RGB颜色转换为CMYK颜色
 */
UIKIT_EXTERN void CHRGB2CMYK(CGFloat red, CGFloat green, CGFloat blue,
                             CGFloat *cyan, CGFloat *magenta, CGFloat *yellow, CGFloat *key);

/**
 CMYK颜色转换为RGB颜色
 */
UIKIT_EXTERN void CHCMYK2RGB(CGFloat cyan, CGFloat magenta, CGFloat yellow, CGFloat key,
                             CGFloat *red, CGFloat *green, CGFloat *blue);

/**
 RGB颜色转换为CMY颜色
 */
UIKIT_EXTERN void CHRGB2CMY(CGFloat red, CGFloat green, CGFloat blue,
                            CGFloat *cyan, CGFloat *magenta, CGFloat *yellow);

/**
 CMY颜色转换为RGB颜色
 */
UIKIT_EXTERN void CHCMY2RGB(CGFloat cyan, CGFloat magenta, CGFloat yellow,
                            CGFloat *red, CGFloat *green, CGFloat *blue);

/**
 CMY颜色转换为CMYK颜色
 */
UIKIT_EXTERN void CHCMY2CMYK(CGFloat cyan, CGFloat magenta, CGFloat yellow,
                             CGFloat *cCyan, CGFloat *mMagenta, CGFloat *yYellow, CGFloat *kKey);

/**
 CMYK颜色转换为CMY颜色
 */
UIKIT_EXTERN void CHCMYK2CMY(CGFloat cyan, CGFloat magenta, CGFloat yellow, CGFloat key,
                             CGFloat *cCyan, CGFloat *mMagenta, CGFloat *yYellow);

/**
 HSB颜色转换为HSL颜色
 */
UIKIT_EXTERN void CHHSB2HSL(CGFloat hue, CGFloat saturation, CGFloat brightness,
                            CGFloat *hHue, CGFloat *sSaturation, CGFloat *lLightness);

/**
 HSL颜色转换为HSB颜色
 */
UIKIT_EXTERN void CHHSL2HSB(CGFloat hue, CGFloat saturation, CGFloat lightness,
                            CGFloat *hHue, CGFloat *sSaturation, CGFloat *bBrightness);

#pragma mark - CMYK
@property (nonatomic, readonly) CGFloat ch_cyanOfCMYK;    ///< 获取CMYK/CMY的Cyan值[0,1]
@property (nonatomic, readonly) CGFloat ch_magentaOfCMYK; ///< 获取CMYK/CMY的Magenta值[0,1]
@property (nonatomic, readonly) CGFloat ch_yellowOfCMYK;  ///< 获取CMYK/CMY的Yellow值[0,1]
@property (nonatomic, readonly) CGFloat ch_keyOfCMYK;     ///< 获取CMYK的Key(Black)值[0,1]

/**
 获取根据CMY颜色空间调配的各颜色部分
 
 @param cyan    CMYK的Cyan部分[0,1]
 @param magenta CMYK的Magenta部分[0,1]
 @param yellow  CMYK的Yellow部分[0,1]
 @param alpha   Alpha部分[0,1]
 @return 颜色成功转化返回YES, 否则返回NO
 */
- (BOOL)ch_getCyan:(CGFloat *)cyan
           magenta:(CGFloat *)magenta
            yellow:(CGFloat *)yellow
             alpha:(CGFloat *)alpha;

/**
 获取根据CMYK颜色空间调配的各颜色部分
 
 @param cyan    CMYK的Cyan部分[0,1]
 @param magenta CMYK的Magenta部分[0,1]
 @param yellow  CMYK的Yellow部分[0,1]
 @param key     CMYK的Key(Black)部分[0,1]
 @param alpha   Alpha部分[0,1]
 @return 颜色成功转化返回YES, 否则返回NO
 */
- (BOOL)ch_getCyan:(CGFloat *)cyan
           magenta:(CGFloat *)magenta
            yellow:(CGFloat *)yellow
               key:(CGFloat *)key
             alpha:(CGFloat *)alpha;

/**
 根据Cyan, Magenta, Yellow值, 获取颜色(基于设备RGB颜色空间调配)
 
 @param cyan    CMY的Cyan值[0,1]
 @param magenta CMY的Magenta值[0,1]
 @param yellow  CMY的Yellow值[0,1]
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithCyan:(CGFloat)cyan
                      magenta:(CGFloat)magenta
                       yellow:(CGFloat)yellow;

/**
 根据Cyan, Magenta, Yellow和Alpha值, 获取颜色(基于设备RGB颜色空间调配)
 
 @param cyan    CMY的Cyan值[0,1]
 @param magenta CMY的Magenta值[0,1]
 @param yellow  CMY的Yellow值[0,1]
 @param alpha   Alpha值[0,1]
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithCyan:(CGFloat)cyan
                      magenta:(CGFloat)magenta
                       yellow:(CGFloat)yellow
                        alpha:(CGFloat)alpha;

/**
 根据Cyan, Magenta, Yellow, Key(Black)值, 获取颜色(基于设备RGB颜色空间调配)
 
 @param cyan    CMYK的Cyan值[0,1]
 @param magenta CMYK的Magenta值[0,1]
 @param yellow  CMYK的Yellow值[0,1]
 @param key     CMYK的Key(Balck)值[0,1]
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithCyan:(CGFloat)cyan
                      magenta:(CGFloat)magenta
                       yellow:(CGFloat)yellow
                          key:(CGFloat)key;

/**
 根据Cyan, Magenta, Yellow, Key(Black)和Alpha值, 获取颜色(基于设备RGB颜色空间调配)
 
 @param cyan CMYK的Cyan值[0,1]
 @param magenta CMYK的Magenta值[0,1]
 @param yellow CMYK的Yellow值[0,1]
 @param key CMYK的Key(Balck)值[0,1]
 @param alpha Alpha值[0,1]
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithCyan:(CGFloat)cyan
                      magenta:(CGFloat)magenta
                       yellow:(CGFloat)yellow
                          key:(CGFloat)key
                        alpha:(CGFloat)alpha;

/**
 根据CMYK/CMY颜色Cyan值的变化, 获取修改后的颜色
 
 @param CyanDelta Cyan(CMYK/CMY)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeCyanOfCMYK:(CGFloat)CyanDelta;

/**
 根据CMYK/CMY颜色Magenta值的变化, 获取修改后的颜色
 
 @param magentaDelta Magenta(CMYK/CMY)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeMagentaOfCMYK:(CGFloat)magentaDelta;

/**
 根据CMYK/CMY颜色Yellow值的变化, 获取修改后的颜色
 
 @param yellowDelta Yellow(CMYK/CMY)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeYellowOfCMYK:(CGFloat)yellowDelta;

/**
 根据CMYK颜色Key(Black)值的变化, 获取修改后的颜色
 
 @param keyDelta keyDelta Key<Black>(CMYK)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeKeyOfCMYK:(CGFloat)keyDelta;

/**
 根据CMYK/CMY颜色Cyan, Magenta, Yellow和Alpha值的变化, 获取修改后的颜色
 
 @param cyanDelta    Cyan(CMYK/CMY)的变化值[-1,1](0, 不变)
 @param magentaDelta Magenta(CMYK/CMY)的变化值[-1,1](0, 不变)
 @param yellowDelta  Yellow(CMYK/CMY)的变化值[-1,1](0, 不变)
 @param alphaDelta   Alpha的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeCyan:(CGFloat)cyanDelta
                                   magenta:(CGFloat)magentaDelta
                                    yellow:(CGFloat)yellowDelta
                                     alpha:(CGFloat)alphaDelta;

/**
 根据CMYK颜色Cyan, Magenta, Yellow, Key(Black)和Alpha值的变化, 获取修改后的颜色
 
 @param cyanDelta    Cyan(CMYK)的变化值[-1,1](0, 不变)
 @param magentaDelta Magenta(CMYK)的变化值[-1,1](0, 不变)
 @param yellowDelta  Yellow(CMYK)的变化值[-1,1](0, 不变)
 @param keyDelta     Key<Black>(CMYK)的变化值[-1,1](0, 不变)
 @param alphaDelta   Alpha的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeCyan:(CGFloat)cyanDelta
                                   magenta:(CGFloat)magentaDelta
                                    yellow:(CGFloat)yellowDelta
                                       key:(CGFloat)keyDelta
                                     alpha:(CGFloat)alphaDelta;

#pragma mark - HSB
@property (nonatomic, readonly) CGFloat ch_hueOfHSB;        ///< 获取HSB(HSV)的色相(H)值[0,1]
@property (nonatomic, readonly) CGFloat ch_saturationOfHSB; ///< 获取HSB(HSV)的饱和度(S)值[0,1]
@property (nonatomic, readonly) CGFloat ch_brightnessOfHSB; ///< 获取HSB(HSV)的明度(B)值[0,1]

/**
 根据色相, 饱和度, 明度, 获取颜色(基于设备RGB颜色空间调配)
 
 @param hue         HSB的色相(H)值[0,1]
 @param saturation  HSB的饱和度(S)值[0,1]
 @param brightness  HSB的明度(B)值[0,1]
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithHue:(CGFloat)hue
                  saturation:(CGFloat)saturation
                  brightness:(CGFloat)brightness;

/**
 根据颜色HSB中色相的变化, 获取修改后的颜色
 
 @param hueDelta 色相(HSB<HSV>)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByChangeHueOfHSB:(CGFloat)hueDelta;

/**
 根据颜色HSB中饱和度的变化, 获取修改后的颜色
 
 @param saturationDelta 饱和度(HSB<HSV>)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByChangeSaturationOfHSB:(CGFloat)saturationDelta;

/**
 根据颜色HSB中明度的变化, 获取修改后的颜色
 
 @param brightnessDelta 明度(HSB<HSV>)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByChangeBrightnessOfHSB:(CGFloat)brightnessDelta;

/**
 根据颜色HSB中色相, 饱和度, 明度和Alpha值的变化, 获取修改后的颜色
 
 @param hueDelta        色相(HSB<HSV>)的变化值[-1,1](0, 不变)
 @param saturationDelta 饱和度(HSB<HSV>)的变化值[-1,1](0, 不变)
 @param brightnessDelta 明度(HSB<HSV>)的变化值[-1,1](0, 不变)
 @param alphaDelta      Alpha的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (UIColor *)ch_colorByChangeHue:(CGFloat)hueDelta
                      saturation:(CGFloat)saturationDelta
                      brightness:(CGFloat)brightnessDelta
                           alpha:(CGFloat)alphaDelta;

#pragma mark - HSL
@property (nonatomic, readonly) CGFloat ch_hueOfHSL;        ///< 获取HSL的色相(H)值[0,1]
@property (nonatomic, readonly) CGFloat ch_saturationOfHSL; ///< 获取HSL的饱和度(S)值[0,1]
@property (nonatomic, readonly) CGFloat ch_lightnessOfHSL;  ///< 获取HSL的亮度(L)值[0,1]

/**
 获取根据HSL颜色空间调配的各颜色部分
 
 @param hue        HSL的色相(H)部分[0,1]
 @param saturation HSL的饱和度(S)部分[0,1]
 @param lightness  HSL的亮度(L)部分[0,1]
 @param alpha      Alpha部分[0,1]
 @return 颜色成功转化返回YES, 否则返回NO
 */
- (BOOL)ch_getHue:(CGFloat *)hue
       saturation:(CGFloat *)saturation
        lightness:(CGFloat *)lightness
            alpha:(CGFloat *)alpha;

/**
 根据色相, 饱和度, 亮度值, 获取颜色(基于设备RGB颜色空间调配)
 
 @param hue        HSL的色相(H)值[0,1]
 @param saturation HSL的饱和度(S)值[0,1]
 @param lightness  HSL的亮度(L)值[0,1]
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithHue:(CGFloat)hue
                  saturation:(CGFloat)saturation
                   lightness:(CGFloat)lightness;

/**
 根据色相, 饱和度, 亮度和Alpha值, 获取颜色(基于设备RGB颜色空间调配)
 
 @param hue        HSL的色相(H)值[0,1]
 @param saturation HSL的饱和度(S)值[0,1]
 @param lightness  HSL的亮度(L)值[0,1]
 @param alpha      Alpha值[0,1]
 @return 对应的颜色
 */
+ (UIColor *)ch_colorWithHue:(CGFloat)hue
                  saturation:(CGFloat)saturation
                   lightness:(CGFloat)lightness
                       alpha:(CGFloat)alpha;

/**
 根据颜色HSL中色相的变化, 获取修改后的颜色
 
 @param hueDelta 色相(HSL)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeHueOfHSL:(CGFloat)hueDelta;

/**
 根据颜色HSL中饱和度的变化, 获取修改后的颜色
 
 @param saturationDelta 饱和度(HSL)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeSaturationOfHSL:(CGFloat)saturationDelta;

/**
 根据颜色HSL中亮度的变化, 获取修改后的颜色
 
 @param lightnessDelta 亮度(HSL)的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeLightnessOfHSL:(CGFloat)lightnessDelta;

/**
 根据颜色HSL中色相, 饱和度, 亮度和Alpha值的变化, 获取修改后的颜色
 
 @param hueDelta        色相(HSL)的变化值[-1,1](0, 不变)
 @param saturationDelta 饱和度(HSL)的变化值[-1,1](0, 不变)
 @param lightnessDelta  亮度(HSL)的变化值[-1,1](0, 不变)
 @param alphaDelta      Alpha的变化值[-1,1](0, 不变)
 @return 修改后的颜色
 */
- (nullable UIColor *)ch_colorByChangeHue:(CGFloat)hueDelta
                               saturation:(CGFloat)saturationDelta
                                lightness:(CGFloat)lightnessDelta
                                    alpha:(CGFloat)alphaDelta;

@end

NS_ASSUME_NONNULL_END
