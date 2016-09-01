//
//  SBView.h
//  animationTest
//
//  Created by xumingfa on 16/8/4.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFHUDConst.h"

@interface XMFThreeBallView : UIView

/// 球的直径大小（默认10)
@property (assign, nonatomic) CGFloat dotSize;

/// 上中球的颜色（默认为红色）
@property (strong, nonatomic, nullable) UIColor *aBallColor;

/// 左下球颜色 （默认为黄）
@property (strong, nonatomic, nullable) UIColor *bBallColor;

/// 右下球颜色（默认为绿）
@property (strong, nonatomic, nullable) UIColor *cBallColor;

/// 球的样式 （默认为三角运动）
@property (assign, nonatomic) XMFBallHUDStyle ballStyle;

/*!
 开始动画
 */
- (void)play;

@end
