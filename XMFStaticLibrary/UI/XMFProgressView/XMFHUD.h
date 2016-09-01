//
//  XMFProgressViewBuilder.h
//  TestDemo
//
//  Created by mr kiki on 16/3/30.
//  Copyright © 2016年 mr kiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFHUDConst.h"

@interface XMFHUD : NSObject

#pragma mark - hide
+ (void)dismiss;

#pragma mark - progress
+ (void)showProgress;

+ (void)refreshProgressWithTotalLenght:(CGFloat)totalLenght
                         currentLenght:(CGFloat)currentLenght;
#pragma mark - 普通类型

+ (void)showWithTitle:(NSString * _Nullable)title;

+ (void)show;

#pragma mark - 三色球类型
/*!
 无法触摸模式（三角运动）
 */
+ (void)showBall;

+ (void)showBallWithStyle : (XMFBallHUDStyle)style;

/*!
 默认为keyWindow
 */
+ (void)showBallWithContent : (__kindof UIView * _Nullable)contentView;

/*!
 默认为keyWindow
 */
+ (void)showBallWithContent : (__kindof UIView * _Nullable)contentView style : (XMFBallHUDStyle)style ;

@end
