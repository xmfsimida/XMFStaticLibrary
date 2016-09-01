//
//  XMFPlayer.h
//  XMFPlayer
//
//  Created by xumingfa on 16/6/1.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMFPlayer : UIView

/// 资源URL
@property (nonatomic, strong, nullable) NSURL *videoURL;
/// 封面图
@property (nonatomic, strong, nullable) UIImage *stopPlayCoverImage;
/// 是否允许全屏
@property (nonatomic, assign, getter=isAllowFullScreen) BOOL allowFullScreen;
/*!
 暂停播放
 */
- (void)pause;

/*!
 播放
 */
- (void)play;

@end
