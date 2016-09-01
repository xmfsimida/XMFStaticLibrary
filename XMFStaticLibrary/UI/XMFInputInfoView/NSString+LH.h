//
//  NSString+LH.h
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LH)

/// 判断字符串是否为空，空值 → YES，非空值 → NO。字符串为nil时，不会执行getter方法，直接返回 NO。
@property (nonatomic, assign, readonly) BOOL isEmpty;
/// 判断字符串是否不为空，非空值 → YES，空值 → NO。如果字符串可能为nil时，调用这个会好点。
@property (nonatomic, assign, readonly) BOOL isNotEmpty;

@end


#pragma mark - 去掉字符 -
@interface NSString (TrimmingAdditions)

/**
 *  trim掉左面字符串
 */
- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;

/**
 *  trim掉右面字符串
 */
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

@end


#pragma mark - 加密 -
@interface NSString (Encrypt)

//16位MD5加密方式
- (NSString *)md5_16Bit_String;
//32位MD5加密方式
- (NSString *)md5_32Bit_String;
/// sha1加密方式
- (NSString *)sha1String;
/// sha256加密方式
- (NSString *)sha256String;
/// sha384加密方式
- (NSString *)sha384String;
/// sha512加密方式
- (NSString*)sha512String;

@end


#pragma mark - 字体 -
@interface NSString (Font)

/*
 字母 ”a“  下面为调用 systemFontOfSize 的结果，得到高度会小于下面的高度
 汉字 ”我“ 宽度为字体大小，高度跟下面一样
 system font 10, size is {6, 12}
 system font 11, size is {7, 14}
 system font 12, size is {7, 15}
 system font 13, size is {8, 16}
 system font 14, size is {8, 17}
 system font 15, size is {9, 18}
 system font 16, size is {9, 20}
 system font 17, size is {10, 21}
 system font 18, size is {10, 22}
 system font 19, size is {11, 23}
 system font 20, size is {11, 24}
 system font 21, size is {12, 26}
 */

/// 获取字符串大小
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end


#pragma mark - 垂直绘画 -
@interface NSString (VerticalAlign)

typedef enum {
    NSVerticalTextAlignmentTop,
    NSVerticalTextAlignmentMiddle,
    NSVerticalTextAlignmentBottom
} NSVerticalTextAlignment;


/// 垂直画文本
- (CGSize)drawVerticallyInRect:(CGRect)rect withFont:(UIFont *)font verticalAlignment:(NSVerticalTextAlignment)vAlign;

/// 垂直画文本： 换行模式
- (CGSize)drawVerticallyInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode verticalAlignment:(NSVerticalTextAlignment)vAlign;

/// 垂直画文本： 换行模式 、 文本水平对齐模式
- (CGSize)drawVerticallyInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment verticalAlignment:(NSVerticalTextAlignment)vAlign;

@end


#pragma mark - 验证 -
@interface NSString (Validate)

/// 身份证验证
- (BOOL)isValidateCardID;

/// 根据身份证号，判断年龄是否满18岁
- (BOOL)isValidateTeenager;

/// 手机号码验证
- (BOOL)isValidateMobile;

/// 固定电话号码验证
- (BOOL)isValidateTel;

/// 电话号码与手机号码同时验证
- (BOOL)isValidateTelAndMobile;

/// 车牌号验证
- (BOOL) isValidateCarNumber;

/// 邮箱验证
- (BOOL)isValidateEmail;

@end
