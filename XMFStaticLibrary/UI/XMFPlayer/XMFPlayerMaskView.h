//
//  XMFPlayerMaskView.h
//  XMFPlayer
//
//  Created by xumingfa on 16/6/1.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMFPlayerMaskView : UIView

@property (weak, nonatomic) UILabel *timeLB; // 当前时间

@property (weak, nonatomic) UIButton *playBN; // 播放 暂停 按钮

@property (weak, nonatomic) UIButton *fullScreenBN; // 全屏按钮

@property (weak, nonatomic) UIProgressView *bufferPV; // 缓存进度条
@property (weak, nonatomic) UISlider *videoSlider;

@property (weak, nonatomic) UIActivityIndicatorView *activityView; // 菊花

@property (weak, nonatomic) UIView *bottomView;

@property (weak, nonatomic) UIView *topView;

@property (weak, nonatomic) UIImageView *thumbnailIV;

@property (weak, nonatomic) UIImageView *playerImage;

@end
