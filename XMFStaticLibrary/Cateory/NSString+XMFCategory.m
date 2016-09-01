//
//  NSString+Category.m
//  Tfunchat
//
//  Created by mr kiki on 16/3/24.
//  Copyright © 2016年 外语高手. All rights reserved.
//

#import "NSString+XMFCategory.h"

@implementation NSString (XMFCategory)

+ (NSAttributedString *)xmf_AddUnderLineStyleWithString:(NSString *)str textColor:(UIColor *)color textFont:(UIFont *)font{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange strRange = {0,[str length]};
    [attStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:strRange];
    [attStr addAttribute:NSFontAttributeName value:font range:strRange];
    return attStr;
}

//通过图片Data数据第一个字节 来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

/*
 * 判断内容是否为空
 */
- (BOOL)xmf_isEmpty {
    
    return [self isEqualToString: @""] && self.length == 0 ? YES : NO;
}


@end

@implementation NSString (XMFTrimmingAdditions)


/**
 *  trim掉左面字符串
 */
- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer range:NSMakeRange(0, length)];
    
    for ( ; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}


/**
 *  trim掉右面字符串
 */
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer range:NSMakeRange(0, length)];
    
    for ( ; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

/*!
 去除两边的空格
 */
- (NSString *)stringByTrimming {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

#pragma mark - 验证 -
@implementation NSString (XMFValidate)

/// 身份证验证
- (BOOL)isValidateCardID {
    NSString *cardID = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!cardID) {
        return NO;
    }else {
        length = cardID.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [cardID substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return  false;
    }
    
    
    NSRegularExpression  *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [cardID substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"                                                                        options:NSRegularExpressionCaseInsensitive                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"                                                                        options:NSRegularExpressionCaseInsensitive                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:cardID                                                                         options:NSMatchingReportProgress                                                                           range:NSMakeRange(0, cardID.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [cardID substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"                                                                        options:NSRegularExpressionCaseInsensitive                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"                                                                        options:NSRegularExpressionCaseInsensitive                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:cardID                                                                         options:NSMatchingReportProgress                                                                           range:NSMakeRange(0, cardID.length)];
            
            if(numberofMatch >0) {
                int S = ([cardID substringWithRange:NSMakeRange(0,1)].intValue + [cardID substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([cardID substringWithRange:NSMakeRange(1,1)].intValue + [cardID substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([cardID substringWithRange:NSMakeRange(2,1)].intValue + [cardID substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([cardID substringWithRange:NSMakeRange(3,1)].intValue + [cardID substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([cardID substringWithRange:NSMakeRange(4,1)].intValue + [cardID substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([cardID substringWithRange:NSMakeRange(5,1)].intValue + [cardID substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([cardID substringWithRange:NSMakeRange(6,1)].intValue + [cardID substringWithRange:NSMakeRange(16,1)].intValue) *2 + [cardID substringWithRange:NSMakeRange(7,1)].intValue *1 + [cardID substringWithRange:NSMakeRange(8,1)].intValue *6 + [cardID substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[cardID substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

/// 根据身份证号，判断年龄是否满18岁
- (BOOL)isValidateTeenager {
    // 年龄是否满18岁
    int age = 0;
    NSString *birthStr = @"0";
    NSString *yearStr = [NSString getStringFromDate:[NSDate date] format:@"yyyy"];
    if (self.length == 18) {
        //7、8、9、10位为出生年份(四位数)，第11、第12位为出生月份，第13、14位代表出生日期
        birthStr = [self substringWithRange:NSMakeRange(6, 4)];
        
    }else if (self.length == 15) {
        //7、8位为出生年份(两位数)，第9、10位为出生月份，第11、12位代表出生日期
        birthStr = [self substringWithRange:NSMakeRange(6, 2)];
        birthStr = [NSString stringWithFormat:@"19%@", birthStr];
    }
    
    age = [yearStr intValue] - [birthStr intValue];
    if (age < 18) {
        return NO;
    }
    
    return YES;
}

/// 获取指定格式的显示时间 yyyy-MM-dd HH:mm:ss
+ (NSString *)getStringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}


/// 手机号码验证
- (BOOL)isValidateMobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/// 固定电话号码验证
- (BOOL)isValidateTel {
    NSString *telRegex = @"^(\\d{3,4}-?)?\\d{7,8}$";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",telRegex];
    return [telTest evaluateWithObject:self];
}

/// 电话号码与手机号码同时验证
- (BOOL)isValidateTelAndMobile {
    NSString *telRegex = @"(^(\\d{3,4}-?)?\\d{7,8})$|(13[0-9]{9})";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",telRegex];
    return [telTest evaluateWithObject:self];
}

/// 车牌号验证
- (BOOL)isValidateCarNumber {
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:self];
}

/// 邮箱验证
- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end