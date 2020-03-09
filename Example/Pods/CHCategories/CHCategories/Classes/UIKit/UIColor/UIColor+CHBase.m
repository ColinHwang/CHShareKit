//
//  UIColor+CHBase.m
//  Pods
//
//  Created by CHwang on 17/1/9.
//  
//

#import "UIColor+CHBase.h"

/**
 *  比较颜色value值, 若在0-1之间返回value，若大于1返回1, 小于0返回0
 */
#ifndef CH_CLAMP_COLOR_VALUE
#define CH_CLAMP_COLOR_VALUE(v) (v) = (v) < 0 ? 0 : (v) > 1 ? 1 : (v)
#endif

@implementation UIColor (CHBase)

#pragma mark - Base
- (CGFloat)ch_alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)ch_redOfRGBA {
    CGFloat red = 0, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    return red;
}

- (CGFloat)ch_greenOfRGBA {
    CGFloat red, green = 0, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    return green;
}

- (CGFloat)ch_blueOfRGBA {
    CGFloat red, green, blue = 0, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    return blue;
}

- (uint32_t)ch_RGBValue {
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    int8_t rRed = red * 255;
    uint8_t gGreen = green * 255;
    uint8_t bBlue = blue * 255;
    return (rRed << 16) + (gGreen << 8) + bBlue;
}

- (uint32_t)ch_RGBAValue {
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    int8_t rRed = red * 255;
    uint8_t gGreen = green * 255;
    uint8_t bBlue = blue * 255;
    uint8_t aAlpha = alpha * 255;
    return (rRed << 24) + (gGreen << 16) + (bBlue << 8) + aAlpha;
}

- (NSString *)ch_hexString {
    return [self _ch_hexStringWithAlpha:NO];
}

- (NSString *)ch_hexStringWithAlpha {
    return [self _ch_hexStringWithAlpha:YES];
}

- (NSString *)_ch_hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color); // CGColorGetNumberOfComponents() -> 获得CGColorRef的中包含的颜色组成部分的个数(包含Alpha)
    const CGFloat *components = CGColorGetComponents(color); //  CGColorGetComponents() -> 获取实际的颜色组成部分的数组(包含Alpha)
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hexString = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hexString = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hexString = [NSString stringWithFormat:stringFormat,
                     (NSUInteger)(components[0] * 255.0f), // R
                     (NSUInteger)(components[1] * 255.0f), // G
                     (NSUInteger)(components[2] * 255.0f)]; // B
    }
    
    if (hexString && withAlpha) {
        hexString = [hexString stringByAppendingFormat:@"%02lx",
                     (unsigned long)(self.ch_alpha * 255.0 + 0.5)];
    }
    return hexString;
}

#pragma mark - Check
- (BOOL)ch_isEqualToColor:(UIColor *)otherColor {
    if (!otherColor) return NO;
    if (![otherColor isKindOfClass:[UIColor class]]) return NO;
    if (self == otherColor) return YES;

    return self.ch_RGBAValue == otherColor.ch_RGBAValue;
}

- (BOOL)ch_isiOSDefaultTintColor {
    return [self ch_isEqualToColor:[UIColor ch_iOSDefaultTintColor]];
}

- (BOOL)ch_isDarkColor {
    /*
     http://stackoverflow.com/questions/19456288/text-color-based-on-background-image
     */
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        float referenceValue = 0.411;
        float colorDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
        return 1.0 - colorDelta > referenceValue;
    }
    return YES;
}

- (BOOL)ch_isLightColor {
    return !self.ch_isDarkColor;
}

#pragma mark - Create
+ (UIColor *)ch_randomColor {
    return [UIColor _ch_colorWithRandomRed:YES randomGreen:YES randomBlue:YES randomAlpha:NO];
}

+ (UIColor *)ch_iOSDefaultTintColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIView *view = [[UIView alloc] init];
        color = view.tintColor;
    });
    return color;
}

+ (UIColor *)ch_colorWithRandomRed {
    return [UIColor _ch_colorWithRandomRed:YES randomGreen:NO randomBlue:NO randomAlpha:NO];
}

+ (UIColor *)ch_colorWithRandomGreen {
    return [UIColor _ch_colorWithRandomRed:NO randomGreen:YES randomBlue:NO randomAlpha:NO];
}

+ (UIColor *)ch_colorWithRandomBlue {
    return [UIColor _ch_colorWithRandomRed:NO randomGreen:NO randomBlue:YES randomAlpha:NO];
}

+ (UIColor *)_ch_colorWithRandomRed:(BOOL)isRed randomGreen:(BOOL)isGreen randomBlue:(BOOL)isBlue randomAlpha:(BOOL)isAlpha {
    CGFloat red, green, blue, alpha;
    red = green = blue = alpha = 255.f;
    
    if (isRed) red = arc4random_uniform(256);
    if (isGreen) green = arc4random_uniform(256);
    if (isBlue) blue = arc4random_uniform(256);
    if (isAlpha) alpha = arc4random_uniform(256);
    
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha/255.f];
}

+ (UIColor *)ch_colorWithRGB:(uint32_t)RGBValue {
    return [UIColor colorWithRed:((RGBValue & 0xFF0000) >> 16) / 255.0f
                           green:((RGBValue & 0xFF00) >> 8) / 255.0f
                            blue:(RGBValue & 0xFF) / 255.0f
                           alpha:1];
}

+ (UIColor *)ch_colorWithRGBA:(uint32_t)RGBAValue {
    return [UIColor colorWithRed:((RGBAValue & 0xFF000000) >> 24) / 255.0f
                           green:((RGBAValue & 0xFF0000) >> 16) / 255.0f
                            blue:((RGBAValue & 0xFF00) >> 8) / 255.0f
                           alpha:(RGBAValue & 0xFF) / 255.0f];
}

+ (UIColor *)ch_colorWithRGB:(uint32_t)RGBValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((RGBValue & 0xFF0000) >> 16) / 255.0f
                           green:((RGBValue & 0xFF00) >> 8) / 255.0f
                            blue:(RGBValue & 0xFF) / 255.0f
                           alpha:alpha];
}

NS_INLINE NSUInteger CHHexStringToInt(NSString *hexString) {
    uint32_t result = 0;
    sscanf([hexString UTF8String], "%X", &result);
    return result;
}

static BOOL CHHexStringToRGBA(NSString *hexString,
                            CGFloat *red, CGFloat *green, CGFloat *blue, CGFloat *alpha) {
    hexString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; // 去空, 大写
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1]; // #00FFDD -> 00FFDD
    } else if ([hexString hasPrefix:@"0X"]) { // 0X00FFDD -> 00FFDD
        hexString = [hexString substringFromIndex:2];
    }
    
    NSUInteger length = [hexString length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    // RGB,RGBA,RRGGBB,RRGGBBAA
    // RGB||RGBA
    if (length < 5)  {
        *red = CHHexStringToInt([hexString substringWithRange:NSMakeRange(0, 1)]) / 255.0f; // R
        *green = CHHexStringToInt([hexString substringWithRange:NSMakeRange(1, 1)]) / 255.0f; // G
        *blue = CHHexStringToInt([hexString substringWithRange:NSMakeRange(2, 1)]) / 255.0f; // B
        if (length == 4)  *alpha = CHHexStringToInt([hexString substringWithRange:NSMakeRange(3, 1)]) / 255.0f; // A
        else *alpha = 1;
    } else {
        // RRGGBB||RRGGBBAA
        *red = CHHexStringToInt([hexString substringWithRange:NSMakeRange(0, 2)]) / 255.0f; // R
        *green = CHHexStringToInt([hexString substringWithRange:NSMakeRange(2, 2)]) / 255.0f; // G
        *blue = CHHexStringToInt([hexString substringWithRange:NSMakeRange(4, 2)]) / 255.0f; // B
        if (length == 8) *alpha = CHHexStringToInt([hexString substringWithRange:NSMakeRange(6, 2)]) / 255.0f; // A
        else *alpha = 1;
    }
    return YES;
}

+ (UIColor *)ch_colorWithHexString:(NSString *)hexString {
    CGFloat red, green, blue, alpha;
    if (CHHexStringToRGBA(hexString, &red, &green, &blue, &alpha)) {
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    return nil;
}

+ (UIColor *)ch_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    CGFloat red, green, blue, aAlpha;
    if (CHHexStringToRGBA(hexString, &red, &green, &blue, &aAlpha)) {
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    return nil;
}

+ (UIColor *)ch_colorWithColor:(UIColor *)fromColor toColor:(UIColor *)toColor delta:(CGFloat)delta {
    /*
     http://stackoverflow.com/questions/10781953/determine-rgba-colour-received-by-combining-two-colours
     */
    CGFloat aDelta = delta;
    CH_CLAMP_COLOR_VALUE(aDelta);
    
    CGFloat fromRed = fromColor.ch_redOfRGBA;
    CGFloat fromGreen = fromColor.ch_greenOfRGBA;
    CGFloat fromBlue = fromColor.ch_blueOfRGBA;
    CGFloat fromAlpha = fromColor.ch_alpha;
    
    CGFloat toRed = toColor.ch_redOfRGBA;
    CGFloat toGreen = toColor.ch_greenOfRGBA;
    CGFloat toBlue = toColor.ch_blueOfRGBA;
    CGFloat toAlpha = toColor.ch_alpha;
    
    CGFloat finalAlpha = fromAlpha + (toAlpha - fromAlpha) * aDelta;
    CGFloat finalRed = fromRed + (toRed - fromRed) * aDelta;
    CGFloat finalGreen = fromGreen + (toGreen - fromGreen) * aDelta;
    CGFloat finalBlue = fromBlue + (toBlue - fromBlue) * aDelta;
    
    return [UIColor colorWithRed:finalRed green:finalGreen blue:finalBlue alpha:finalAlpha];
}

+ (UIColor *)ch_colorWithFrontColor:(UIColor *)frontColor backendColor:(UIColor *)backendColor {    
    CGFloat frontAlpha = frontColor.ch_alpha;
    CGFloat frontRed = frontColor.ch_redOfRGBA;
    CGFloat frontGreen = frontColor.ch_greenOfRGBA;
    CGFloat frontBlue = frontColor.ch_blueOfRGBA;
    
    CGFloat backendAlpha = backendColor.ch_alpha;
    CGFloat backendRed = backendColor.ch_redOfRGBA;
    CGFloat backendGreen = backendColor.ch_greenOfRGBA;
    CGFloat backendBlue = backendColor.ch_blueOfRGBA;
    
    CGFloat resultAlpha = frontAlpha + backendAlpha * (1 - frontAlpha);
    CGFloat resultRed = (frontRed * frontAlpha + backendRed * backendAlpha * (1 - frontAlpha)) / resultAlpha;
    CGFloat resultGreen = (frontGreen * frontAlpha + backendGreen * backendAlpha * (1 - frontAlpha)) / resultAlpha;
    CGFloat resultBlue = (frontBlue * frontAlpha + backendBlue * backendAlpha * (1 - frontAlpha)) / resultAlpha;
    return [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:resultAlpha];
}

#pragma mark - Modify
- (UIColor *)ch_colorByAddColor:(UIColor *)addColor blendMode:(CGBlendMode)blendMode {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); // 获取设备支持的RGB颜色空间
    /*
     CGContextRef CGBitmapContextCreate ()
     当你调用这个函数的时候, Quartz创建一个位图绘制环境, 也就是位图上下文。
     当你向上下文中绘制信息时, Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。
     一个新的位图上下文的像素格式由三个参数决定:
     每个组件的位数, 颜色空间, alpha选项。alpha值决定了绘制像素的透明性。
     
     data -> 指向要渲染的绘制内存的地址。这个内存块的大小至少是(bytesPerRow*height)个字节
     width -> bitmap的宽度, 单位为像素
     height -> bitmap的高度, 单位为像素
     bitsPerComponent -> 内存中像素的每个组件的位数。例如, 对于32位像素格式和RGB颜色空间, 你应该将这个值设为8
     bytesPerRow -> bitmap的每一行在内存所占的比特数
     colorspace -> bitmap上下文使用的颜色空间
     bitmapInfo -> 指定bitmap是否包含alpha通道, 像素中alpha通道的相对位置, 像素组件是整形还是浮点型等信息的字符串
     */
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    uint8_t pixel[4] = { 0 }; // RGBA
    CGContextRef context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, bitmapInfo); // 上下文
    CGContextSetFillColorWithColor(context, self.CGColor); // Orignal
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextSetBlendMode(context, blendMode);
    CGContextSetFillColorWithColor(context, addColor.CGColor); // Add
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIColor colorWithRed:pixel[0] / 255.0f green:pixel[1] / 255.0f blue:pixel[2] / 255.0f alpha:pixel[3] / 255.0f];
}

- (UIColor *)ch_colorByChangeAlpha:(CGFloat)alphaDelta {
    CGFloat alpha = self.ch_alpha;
    alpha += alphaDelta;
    CH_CLAMP_COLOR_VALUE(alpha);
    return [self colorWithAlphaComponent:alpha];
}

- (UIColor *)ch_colorByChangeRed:(CGFloat)redDelta {
    return [self ch_colorByChangeRed:redDelta green:0 blue:0 alpha:0];
}

- (UIColor *)ch_colorByChangeGreen:(CGFloat)greenDelta {
    return [self ch_colorByChangeRed:0 green:greenDelta blue:0 alpha:0];
}

- (UIColor *)ch_colorByChangeBlue:(CGFloat)blueDelta{
    return [self ch_colorByChangeRed:0 green:0 blue:blueDelta alpha:0];
}

- (UIColor *)ch_colorByChangeRed:(CGFloat)redDelta green:(CGFloat)greenDelta blue:(CGFloat)blueDelta alpha:(CGFloat)alphaDelta {
    CGFloat red, blue, green, alpha;
    if (![self getRed:&red green:&green blue:&blue alpha:&alpha]) return nil;
    
    red += redDelta;
    green += greenDelta;
    blue += blueDelta;
    alpha += alphaDelta;
    
    CH_CLAMP_COLOR_VALUE(red);
    CH_CLAMP_COLOR_VALUE(green);
    CH_CLAMP_COLOR_VALUE(blue);
    CH_CLAMP_COLOR_VALUE(alpha);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)ch_colorByChangeToColor:(UIColor *)color delta:(CGFloat)delta {
    return [UIColor ch_colorWithColor:self toColor:color delta:delta];
}

- (UIColor *)ch_colorByChangeWithoutAlpha {
    return [self ch_colorByChangeAlpha:1];
}

- (UIColor *)ch_colorByAddToWhiteBackgroundColorWithAlpha:(CGFloat)alpha {
    return [self ch_colorByAddToBackgroundColor:[UIColor whiteColor] alpha:alpha];
}

- (UIColor *)ch_colorByAddToBackgroundColor:(UIColor *)backgroundColor alpha:(CGFloat)alpha {
    return [UIColor ch_colorWithFrontColor:[self colorWithAlphaComponent:alpha] backendColor:backgroundColor];
}

- (UIColor *)ch_colorByInverted {
    /*
     http://stackoverflow.com/questions/5893261/how-to-get-inverse-color-from-uicolor
     */
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    UIColor *color = [[UIColor alloc] initWithRed:(1.0 - components[0]) green:(1.0 - components[1])blue:(1.0 - components[2]) alpha:components[3]];
    return color;
}

#pragma mark - Color Space Info
- (CGColorSpaceModel)ch_colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)ch_colorSpaceString {
    CGColorSpaceModel model =  CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    switch (model) {
        case kCGColorSpaceModelUnknown:
            return @"kCGColorSpaceModelUnknown";
        case kCGColorSpaceModelMonochrome:
            return @"kCGColorSpaceModelMonochrome";
        case kCGColorSpaceModelRGB:
            return @"kCGColorSpaceModelRGB";
        case kCGColorSpaceModelCMYK:
            return @"kCGColorSpaceModelCMYK";
        case kCGColorSpaceModelLab:
            return @"kCGColorSpaceModelLab";
        case kCGColorSpaceModelDeviceN:
            return @"kCGColorSpaceModelDeviceN";
        case kCGColorSpaceModelIndexed:
            return @"kCGColorSpaceModelIndexed";
        case kCGColorSpaceModelPattern:
            return @"kCGColorSpaceModelPattern";
        default:
            return @"ColorSpaceInvalid";
    }
}

#pragma mark - Convert
void CHRGB2HSL(CGFloat red, CGFloat green, CGFloat blue,
               CGFloat *hue, CGFloat *saturation, CGFloat *lightness) {
    /* RGB -> HSL算法
     1.把RGB值转成[0,1]中数值;
     2.找出R,G和B中的最大值<maxColor>和最小值<minColor>;
     3.计算亮度:L=(maxColor + minColor)/2
     4.如果最大和最小的颜色值相同, 即表示灰色, 那么S定义为0, 而H未定义并在程序中通常写成0
     5.否则，根据明度L计算饱和度S:
     If L<0.5, S=(maxColor-minColor)/(maxColor+minColor)
     If L>=0.5, S=(maxColor-mincolor)/(2.0-maxColor-minColor)
     6.计算色相H[0°, 360°]/[0,1]:
     If R=maxColor, H=(G-B)/(maxColor-minColor)
     If G=maxColor, H=2.0+(B-R)/(maxColor-minColor)
     If B=maxColor, H=4.0+(R-G)/(maxColor-minColor)
     H=H*60°(H=H/6),如果H为负值，则加360°(1)
     
     说明:
     1.由步骤3的式子可以看出亮度仅与图像的最多颜色成分和最少的颜色成分的总量有关。亮度越低, 图像越趋于黑色。亮度越高图像越趋于明亮的白色
     2.由步骤5的式子可以看出饱和度与图像的最多颜色成分和最少的颜色成分的差量有关。饱和度越小, 图像越趋于灰度图像。饱和度越大, 图像越鲜艳, 给人的感觉是彩色的, 而不是黑白灰的图像。
     3.由第6步的计算看，H分成0～6区域(360°/0°红<Red>、60°黄(Yellow)、120°绿<Green>、180°青<Cyan>、240°蓝<Blue>、300°品红<Magenta>)。RGB颜色空间是一个立方体而HSL颜色空间是两个六角形锥体，其中的L是RGB立方体的主对角线。因此, RGB立方体的顶点:红、黄、绿、青、蓝和品红就成为HSL六角形的顶点，而数值0~6就告诉我们H在哪个部分
     */
    CH_CLAMP_COLOR_VALUE(red); // [0,1]
    CH_CLAMP_COLOR_VALUE(green);
    CH_CLAMP_COLOR_VALUE(blue);
    
    CGFloat max, min, delta, sum;
    max = fmaxf(red, fmaxf(green, blue)); // fmaxf -> 返回两个float参数最大值
    min = fminf(red, fminf(green, blue)); // fminf -> 返回两个float参数最小值
    delta = max - min; //  差值[0,1]
    sum = max + min; // [0,2]
    
    *lightness = sum / 2;           // Lightness -> 亮度[0,1] HLS -> L
    if (delta == 0) { // No Saturation, so Hue is undefined (achromatic) 无饱和度, 色相未定义(单色)
        *hue = *saturation = 0;
        return;
    }
    *saturation = delta / (sum < 1 ? sum : 2 - sum); // Saturation (sum < 1 ? sum : 2 - sum) -> [0,1]
    if (red == max) *hue = (green - blue) / delta / 6; // color between m & y 颜色在品与黄色红间[300°,60°]
    else if (green == max) *hue = (2 + (blue - red) / delta) / 6; // color between y & c 颜色在黄色与青色间[60°,180°]
    else *hue = (4 + (red - green) / delta) / 6; // color between c & m 颜色在青色与品红间[180°,300°]
    if (*hue < 0) *hue += 1;
}

void CHHSL2RGB(CGFloat hue, CGFloat saturation, CGFloat lightness,
               CGFloat *red, CGFloat *green, CGFloat *blue) {
    /* HSL -> RGB算法
     1.If S=0, 表示灰, 定义R,G和B都为L
     2.否则, 测试L:
     If L<=0.5, temp2=L*(1.0+S)
     If L>0.5, temp2=L+S-L*S
     3.temp1=2.0*L-temp2
     4.把H转换到[0,1]
     5.对于R,G,B, 计算另外的临时值temp3, 方法如下:
     for R, temp3=H+1.0/3.0
     for G, temp3=H
     for B, temp3=H-1.0/3.0
     If temp3<0, temp3=temp3+1.0
     If temp3>1, temp3=temp3-1.0
     6.对于R,G,B做如下测试:
     If 6.0*temp3<1, color=temp1+(temp2-temp1)*6.0*temp3
     Else If 2.0*temp3<1,color=temp2
     Else If 3.0*temp3<2
     color=temp1+(temp2-temp1)*((2.0/3.0)-temp3)*6.0
     Else color=temp1
     */
    CH_CLAMP_COLOR_VALUE(hue); // [0,1]
    CH_CLAMP_COLOR_VALUE(saturation);
    CH_CLAMP_COLOR_VALUE(lightness);
    
    if (saturation == 0) { // No Saturation, Hue is undefined (achromatic) 无饱和度, 色相未定义(单色)
        *red = *green = *blue = lightness;
        return;
    }
    
    CGFloat q;
    q = (lightness <= 0.5) ? (lightness * (1 + saturation)) : (lightness + saturation - (lightness * saturation));
    if (q <= 0) {
        *red = *green = *blue = 0.0;
    } else {
        *red = *green = *blue = 0;
        int sextant;
        CGFloat m, sv, fract, vsf, mid1, mid2;
        m = lightness + lightness - q;
        sv = (q - m) / q;
        if (hue == 1) hue = 0;
        hue *= 6.0;
        sextant = hue;
        fract = hue - sextant;
        vsf = q * sv * fract;
        mid1 = m + vsf;
        mid2 = q - vsf;
        switch (sextant)
        {
            case 0: *red = q; *green = mid1; *blue = m; break;
            case 1: *red = mid2; *green = q; *blue = m; break;
            case 2: *red = m; *green = q; *blue = mid1; break;
            case 3: *red = m; *green = mid2; *blue = q; break;
            case 4: *red = mid1; *green = m; *blue = q; break;
            case 5: *red = q; *green = m; *blue = mid2; break;
        }
    }
}

void CHRGB2HSB(CGFloat red, CGFloat green, CGFloat blue,
               CGFloat *hue, CGFloat *saturation, CGFloat *value) {
    CH_CLAMP_COLOR_VALUE(red);
    CH_CLAMP_COLOR_VALUE(green);
    CH_CLAMP_COLOR_VALUE(blue);
    
    CGFloat max, min, delta;
    max = fmax(red, fmax(green, blue));
    min = fmin(red, fmin(green, blue));
    delta = max - min;
    
    *value = max;               // Brightness
    if (delta == 0) { // No Saturation, so Hue is undefined (achromatic)
        *hue = *saturation = 0;
        return;
    }
    *saturation = delta / max;       // Saturation
    
    if (red == max) *hue = (green - blue) / delta / 6;             // color between y & m
    else if (green == max) *hue = (2 + (blue - red) / delta) / 6;  // color between c & y
    else *hue = (4 + (red - green) / delta) / 6;                // color between m & c
    if (*hue < 0) *hue += 1;
}

void CHHSB2RGB(CGFloat hue, CGFloat saturation, CGFloat value,
               CGFloat *red, CGFloat *green, CGFloat *blue) {
    CH_CLAMP_COLOR_VALUE(hue);
    CH_CLAMP_COLOR_VALUE(saturation);
    CH_CLAMP_COLOR_VALUE(value);
    
    if (saturation == 0) {
        *red = *green = *blue = value; // No Saturation, so Hue is undefined (Achromatic)
    } else {
        int sextant;
        CGFloat f, p, q, t;
        if (hue == 1) hue = 0;
        hue *= 6;
        sextant = floor(hue);
        f = hue - sextant;
        p = value * (1 - saturation);
        q = value * (1 - saturation * f);
        t = value * (1 - saturation * (1 - f));
        switch (sextant)
        {
            case 0: *red = value; *green = t; *blue = p; break;
            case 1: *red = q; *green = value; *blue = p; break;
            case 2: *red = p; *green = value; *blue = t; break;
            case 3: *red = p; *green = q; *blue = value; break;
            case 4: *red = t; *green = p; *blue = value; break;
            case 5: *red = value; *green = p; *blue = q; break;
        }
    }
}

void CHRGB2CMYK(CGFloat red, CGFloat green, CGFloat blue,
                CGFloat *cyan, CGFloat *magenta, CGFloat *yellow, CGFloat *key) {
    CH_CLAMP_COLOR_VALUE(red);
    CH_CLAMP_COLOR_VALUE(green);
    CH_CLAMP_COLOR_VALUE(blue);
    
    *cyan = 1 - red;
    *magenta = 1 - green;
    *yellow = 1 - blue;
    *key = fmin(*cyan, fmin(*magenta, *yellow));
    
    if (*key == 1) {
        *cyan = *magenta = *yellow = 0;   // Pure black
    } else {
        *cyan = (*cyan - *key) / (1 - *key);
        *magenta = (*magenta - *key) / (1 - *key);
        *yellow = (*yellow - *key) / (1 - *key);
    }
}

void CHCMYK2RGB(CGFloat cyan, CGFloat magenta, CGFloat yellow, CGFloat key,
                CGFloat *red, CGFloat *green, CGFloat *blue) {
    CH_CLAMP_COLOR_VALUE(cyan);
    CH_CLAMP_COLOR_VALUE(magenta);
    CH_CLAMP_COLOR_VALUE(yellow);
    CH_CLAMP_COLOR_VALUE(key);
    
    *red = (1 - cyan) * (1 - key);
    *green = (1 - magenta) * (1 - key);
    *blue = (1 - yellow) * (1 - key);
}

void CHRGB2CMY(CGFloat red, CGFloat green, CGFloat blue,
               CGFloat *cyan, CGFloat *magenta, CGFloat *yellow) {
    CH_CLAMP_COLOR_VALUE(red);
    CH_CLAMP_COLOR_VALUE(green);
    CH_CLAMP_COLOR_VALUE(blue);
    
    *cyan = 1 - red;
    *magenta = 1 - green;
    *yellow = 1 - blue;
}

void CHCMY2RGB(CGFloat cyan, CGFloat magenta, CGFloat yellow,
               CGFloat *red, CGFloat *green, CGFloat *blue) {
    CH_CLAMP_COLOR_VALUE(cyan);
    CH_CLAMP_COLOR_VALUE(magenta);
    CH_CLAMP_COLOR_VALUE(yellow);
    
    *red = 1 - cyan;
    *green = 1 - magenta;
    *blue = 1 - yellow;
}

void CHCMY2CMYK(CGFloat cyan, CGFloat magenta, CGFloat yellow,
                CGFloat *cCyan, CGFloat *mMagenta, CGFloat *yYellow, CGFloat *kKey) {
    CH_CLAMP_COLOR_VALUE(cyan);
    CH_CLAMP_COLOR_VALUE(magenta);
    CH_CLAMP_COLOR_VALUE(yellow);
    
    *kKey = fmin(cyan, fmin(magenta, yellow));
    if (*kKey == 1) {
        *cCyan = *mMagenta = *yYellow = 0;   // Pure black
    } else {
        *cCyan = (cyan - *kKey) / (1 - *kKey);
        *mMagenta = (magenta - *kKey) / (1 - *kKey);
        *yYellow = (yellow - *kKey) / (1 - *kKey);
    }
}

void CHCMYK2CMY(CGFloat cyan, CGFloat magenta, CGFloat yellow, CGFloat key,
                CGFloat *cCyan, CGFloat *mMagenta, CGFloat *yYellow) {
    CH_CLAMP_COLOR_VALUE(cyan);
    CH_CLAMP_COLOR_VALUE(magenta);
    CH_CLAMP_COLOR_VALUE(yellow);
    CH_CLAMP_COLOR_VALUE(key);
    
    *cCyan = cyan * (1 - key) + key;
    *mMagenta = magenta * (1 - key) + key;
    *yYellow = yellow * (1 - key) + key;
}

void CHHSB2HSL(CGFloat hue, CGFloat saturation, CGFloat brightness,
               CGFloat *hHue, CGFloat *sSaturation, CGFloat *lLightness) {
    CH_CLAMP_COLOR_VALUE(hue);
    CH_CLAMP_COLOR_VALUE(saturation);
    CH_CLAMP_COLOR_VALUE(brightness);
    
    *hHue = hue;
    *lLightness = (2 - saturation) * brightness / 2;
    if (*lLightness <= 0.5) {
        *sSaturation = (saturation) / ((2 - saturation));
    } else {
        *sSaturation = (saturation * brightness) / (2 - (2 - saturation) * brightness);
    }
}

void CHHSL2HSB(CGFloat hue, CGFloat saturation, CGFloat lightness,
               CGFloat *hHue, CGFloat *sSaturation, CGFloat *bBrightness) {
    CH_CLAMP_COLOR_VALUE(hue);
    CH_CLAMP_COLOR_VALUE(saturation);
    CH_CLAMP_COLOR_VALUE(lightness);
    
    *hHue = hue;
    if (lightness <= 0.5) {
        *bBrightness = (saturation + 1) * lightness;
        *sSaturation = (2 * saturation) / (saturation + 1);
    } else {
        *bBrightness = lightness + saturation * (1 - lightness);
        *sSaturation = (2 * saturation * (1 - lightness)) / *bBrightness;
    }
}

#pragma mark - CMYK
- (CGFloat)ch_cyanOfCMYK {
    CGFloat cyan = 0, magenta, yellow, key, alpha;
    [self ch_getCyan:&cyan magenta:&magenta yellow:&yellow key:&key alpha:&alpha];
    return cyan;
}

- (CGFloat)ch_magentaOfCMYK
{
    CGFloat cyan, magenta = 0, yellow, key, alpha;
    [self ch_getCyan:&cyan magenta:&magenta yellow:&yellow key:&key alpha:&alpha];
    return magenta;
}

- (CGFloat)ch_yellowOfCMYK
{
    CGFloat cyan, magenta, yellow = 0, key, alpha;
    [self ch_getCyan:&cyan magenta:&magenta yellow:&yellow key:&key alpha:&alpha];
    return yellow;
}

- (CGFloat)ch_keyOfCMYK
{
    CGFloat cyan, magenta, yellow, key = 0, alpha;
    [self ch_getCyan:&cyan magenta:&magenta yellow:&yellow key:&key alpha:&alpha];
    return key;
}

- (BOOL)ch_getCyan:(CGFloat *)cyan magenta:(CGFloat *)magenta yellow:(CGFloat *)yellow alpha:(CGFloat *)alpha {
    CGFloat red, green, blue, aAlpha;
    if (![self getRed:&red green:&green blue:&blue alpha:&aAlpha]) {
        return NO;
    }
    CHRGB2CMY(red, green, blue, cyan, magenta, yellow);
    *alpha = aAlpha;
    return YES;
}

- (BOOL)ch_getCyan:(CGFloat *)cyan magenta:(CGFloat *)magenta yellow:(CGFloat *)yellow key:(CGFloat *)key alpha:(CGFloat *)alpha {
    CGFloat red, green, blue, aAlpha;
    if (![self getRed:&red green:&green blue:&blue alpha:&aAlpha]) {
        return NO;
    }
    CHRGB2CMYK(red, green, blue, cyan, magenta, yellow, key);
    *alpha = aAlpha;
    return YES;
}

+ (UIColor *)ch_colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow {
    return [UIColor ch_colorWithCyan:cyan magenta:magenta yellow:yellow alpha:1];
}

+ (UIColor *)ch_colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow alpha:(CGFloat)alpha {
    CGFloat red, green, blue;
    CHCMY2RGB(cyan, magenta, yellow, &red, &green, &blue);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)ch_colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow key:(CGFloat)key {
    return [UIColor ch_colorWithCyan:cyan magenta:magenta yellow:yellow key:key alpha:1];
}

+ (UIColor *)ch_colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow key:(CGFloat)key alpha:(CGFloat)alpha {
    CGFloat red, green, blue;
    CHCMYK2RGB(cyan, magenta, yellow, key, &red, &green, &blue);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)ch_colorByChangeCyanOfCMYK:(CGFloat)CyanDelta {
    return [self ch_colorByChangeCyan:CyanDelta magenta:0 yellow:0 key:0 alpha:0];
}

- (UIColor *)ch_colorByChangeMagentaOfCMYK:(CGFloat)magentaDelta {
    return [self ch_colorByChangeCyan:0 magenta:magentaDelta yellow:0 key:0 alpha:0];
}

- (UIColor *)ch_colorByChangeYellowOfCMYK:(CGFloat)yellowDelta {
    return [self ch_colorByChangeCyan:0 magenta:0 yellow:yellowDelta key:0 alpha:0];
}

- (UIColor *)ch_colorByChangeKeyOfCMYK:(CGFloat)keyDelta {
    return [self ch_colorByChangeCyan:0 magenta:0 yellow:0 key:keyDelta alpha:0];
}

- (UIColor *)ch_colorByChangeCyan:(CGFloat)cyanDelta magenta:(CGFloat)magentaDelta yellow:(CGFloat)yellowDelta alpha:(CGFloat)alphaDelta {
    CGFloat cyan, magenta, yellow, alpha;
    if (![self ch_getCyan:&cyan magenta:&magenta yellow:&yellow alpha:&alpha]) return nil;
    
    cyan += cyanDelta;
    magenta += magentaDelta;
    yellow += yellowDelta;
    alpha += alphaDelta;
    
    cyan = cyan < 0 ? 0 : cyan > 1 ? 1 : cyan; // [0,1]
    magenta = magenta < 0 ? 0 : magenta > 1 ? 1 : magenta; // [0,1]
    yellow = yellow < 0 ? 0 : yellow > 1 ? 1 : yellow; // [0,1]
    alpha = alpha < 0 ? 0 : alpha > 1 ? 1 : alpha; // [0,1]
    
    return [UIColor ch_colorWithCyan:cyan magenta:magenta yellow:yellow alpha:alpha];
}

- (UIColor *)ch_colorByChangeCyan:(CGFloat)cyanDelta magenta:(CGFloat)magentaDelta yellow:(CGFloat)yellowDelta key:(CGFloat)keyDelta alpha:(CGFloat)alphaDelta {
    CGFloat cyan, magenta, yellow, key, alpha;
    if (![self ch_getCyan:&cyan magenta:&magenta yellow:&yellow key:&key alpha:&alpha]) return nil;
    
    cyan += cyanDelta;
    magenta += magentaDelta;
    yellow += yellowDelta;
    key += keyDelta;
    alpha += alphaDelta;
    
    cyan = cyan < 0 ? 0 : cyan > 1 ? 1 : cyan; // [0,1]
    magenta = magenta < 0 ? 0 : magenta > 1 ? 1 : magenta; // [0,1]
    yellow = yellow < 0 ? 0 : yellow > 1 ? 1 : yellow; // [0,1]
    key = key < 0 ? 0 : key > 1 ? 1 : key; // [0,1]
    alpha = alpha < 0 ? 0 : alpha > 1 ? 1 : alpha; // [0,1]
    
    return [UIColor ch_colorWithCyan:cyan magenta:magenta yellow:yellow key:key alpha:alpha];
}

#pragma mark - HSB
- (CGFloat)ch_hueOfHSB {
    CGFloat hue = 0, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return hue;
}

- (CGFloat)ch_saturationOfHSB {
    CGFloat hue, saturation = 0, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return saturation;
}

- (CGFloat)ch_brightnessOfHSB {
    CGFloat hue, saturation, brightness = 0, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return brightness;
}

+ (UIColor *)ch_colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (UIColor *)ch_colorByChangeHueOfHSB:(CGFloat)hueDelta {
    return [self ch_colorByChangeHue:hueDelta saturation:0 brightness:0 alpha:0];
}

- (UIColor *)ch_colorByChangeSaturationOfHSB:(CGFloat)saturationDelta {
    return [self ch_colorByChangeHue:0 saturation:saturationDelta brightness:0 alpha:0];
}

- (UIColor *)ch_colorByChangeBrightnessOfHSB:(CGFloat)brightnessDelta {
    return [self ch_colorByChangeHue:0 saturation:0 brightness:brightnessDelta alpha:0];
}

- (UIColor *)ch_colorByChangeHue:(CGFloat)hueDelta saturation:(CGFloat)saturationDelta brightness:(CGFloat)brightnessDelta alpha:(CGFloat)alphaDelta {
    CGFloat hue, saturation, brightness, alpha;
    if (![self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return self;
    }
    
    hue += hueDelta;
    saturation += saturationDelta;
    brightness += brightnessDelta;
    alpha += alphaDelta;
    
    hue -= (int)hue; // 多减(hue:0.5, hueDelta:0.8 -> hue = 0.3) 色相以角度计算(1 -> 360°, +/- -> 顺/逆)
    hue = hue < 0 ? hue + 1 : hue; // 少补(hue:0.5, hueDelta:-0.8 -> hue = 0.7)
    saturation = saturation < 0 ? 0 : saturation > 1 ? 1 : saturation; // [0,1]
    brightness = brightness < 0 ? 0 : brightness > 1 ? 1 : brightness; // [0,1]
    alpha = alpha < 0 ? 0 : alpha > 1 ? 1 : alpha; // [0,1]
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

#pragma mark - HSL
- (CGFloat)ch_hueOfHSL {
    CGFloat hue = 0, saturation, lightness, alpha;
    [self ch_getHue:&hue saturation:&saturation lightness:&lightness alpha:&alpha];
    return hue;
}

- (CGFloat)ch_saturationOfHSL {
    CGFloat hue, saturation = 0, lightness, alpha;
    [self ch_getHue:&hue saturation:&saturation lightness:&lightness alpha:&alpha];
    return saturation;
}

- (CGFloat)ch_lightnessOfHSL {
    CGFloat hue, saturation, lightness = 0, alpha;
    [self ch_getHue:&hue saturation:&saturation lightness:&lightness alpha:&alpha];
    return lightness;
}

- (BOOL)ch_getHue:(CGFloat *)hue saturation:(CGFloat *)saturation lightness:(CGFloat *)lightness alpha:(CGFloat *)alpha {
    CGFloat red, green, blue, aAlpha;
    if (![self getRed:&red green:&green blue:&blue alpha:&aAlpha]) {
        return NO;
    }
    CHRGB2HSL(red, green, blue, hue, saturation, lightness); // 基于RGB颜色空间调配
    *alpha = aAlpha;
    return YES;
}

+ (UIColor *)ch_colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness {
    return [UIColor ch_colorWithHue:hue saturation:saturation lightness:lightness alpha:1];
}

+ (UIColor *)ch_colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha {
    CGFloat red, green, blue;
    CHHSL2RGB(hue, saturation, lightness, &red, &green, &blue);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)ch_colorByChangeHueOfHSL:(CGFloat)hueDelta {
    return [self ch_colorByChangeHue:hueDelta saturation:0 lightness:0 alpha:0];
}

- (UIColor *)ch_colorByChangeSaturationOfHSL:(CGFloat)saturationDelta {
    return [self ch_colorByChangeHue:0 saturation:saturationDelta lightness:0 alpha:0];
}

- (UIColor *)ch_colorByChangeLightnessOfHSL:(CGFloat)lightnessDelta {
    return [self ch_colorByChangeHue:0 saturation:0 lightness:lightnessDelta alpha:0];
}

- (UIColor *)ch_colorByChangeHue:(CGFloat)hueDelta saturation:(CGFloat)saturationDelta lightness:(CGFloat)lightnessDelta alpha:(CGFloat)alphaDelta {
    CGFloat hue, saturation, lightness, alpha;
    if (![self ch_getHue:&hue saturation:&saturation lightness:&lightness alpha:&alpha]) return nil;
    
    hue += hueDelta;
    saturation += saturationDelta;
    lightness += lightnessDelta;
    alpha += alphaDelta;
    
    hue -= (int)hue; // 多减(hue:0.5, hueDelta:0.8 -> hue = 0.3) 色相以角度计算(1 -> 360°, +/- -> 顺/逆)
    hue = hue < 0 ? hue + 1 : hue; // 少补(hue:0.5, hueDelta:-0.8 -> hue = 0.7)
    saturation = saturation < 0 ? 0 : saturation > 1 ? 1 : saturation; // [0,1]
    lightness = lightness < 0 ? 0 : lightness > 1 ? 1 : lightness; // [0,1]
    alpha = alpha < 0 ? 0 : alpha > 1 ? 1 : alpha; // [0,1]
    
    return [UIColor ch_colorWithHue:hue saturation:saturation lightness:lightness alpha:alpha];
}

@end
