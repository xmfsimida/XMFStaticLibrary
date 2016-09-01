//
//  XMFHUDConst.h
//  PWDemo
//
//  Created by xumingfa on 16/8/10.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XMFBallHUDStyle) {
    XMFBallHUDStyleTriangleMovement = 0, // 三角运动
    XMFBallHUDStyleCollision, // 碰撞
    XMFBallHUDStyleScaleChange, // 大小变化
};

//  中间视图的大小
#define CENTER_WIDTH 180.f
#define CENTER_HEIGHT CENTER_WIDTH

//  进度条中间视图大小
#define PROGRESS_CENTER_WIDTH 100.f
#define PROGRESS_CENTER_HEIGHT PROGRESS_CENTER_WIDTH
#define PROGRESS_CENTER_PADDING 5.f

//  三色球中间视图大小
#define BALL_CENTER_WIDTH 50.f
#define BALL_CENTER_HEIGHT BALL_CENTER_WIDTH

/// progressHUD背景颜色
#define XMF_PROGRESS_HUD_BACKGROUND_COLOR [[UIColor blackColor] colorWithAlphaComponent: 0.6]
/// progressHUD圆角
#define XMF_PROGRESS_HUD_CORNER_RADIUS PROGRESS_CENTER_WIDTH / 2
///  滚动条的颜色
#define XMF_PROGRESS_HUD_LOADING_FOREGROUND_COLOR [UIColor whiteColor]
///  滚动条的底色
#define XMF_PROGRESS_HUD_LOADING_BACKGROUND_COLOR [[UIColor blackColor] colorWithAlphaComponent: 0.8]

