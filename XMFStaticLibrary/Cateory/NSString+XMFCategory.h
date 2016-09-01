//
//  NSString+Category.h
//  Tfunchat
//
//  Created by mr kiki on 16/3/24.
//  Copyright © 2016年 外语高手. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (XMFCategory)

/*!
 添加下划线
 */
+ (NSAttributedString *)xmf_AddUnderLineStyleWithString : (NSString *) str textColor: (UIColor *)color textFont: (UIFont *)font;

/*
 * 判断内容是否为空
 */
- (BOOL)xmf_isEmpty;

@end

#pragma mark - 去掉字符 -
@interface NSString (XMFTrimmingAdditions)

/**
 *  trim掉左面字符串
 */
- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;

/**
 *  trim掉右面字符串
 */
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

/*!
 去除两边的空格
 */
- (NSString *)stringByTrimming;

@end


#pragma mark - 验证 -
@interface NSString (XMFValidate)

// 身份证验证
- (BOOL)isValidateCardID;

// 根据身份证号，判断年龄是否满18岁
- (BOOL)isValidateTeenager;

// 手机号码验证
- (BOOL)isValidateMobile;

// 固定电话号码验证
- (BOOL)isValidateTel;

// 电话号码与手机号码同时验证
- (BOOL)isValidateTelAndMobile;

// 车牌号验证
- (BOOL) isValidateCarNumber;

// 邮箱验证
- (BOOL)isValidateEmail;

@end