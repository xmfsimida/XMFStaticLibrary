//
//  XMFRecordTool.h
//  ChatDemo
//
//  Created by xumingfa on 16/1/20.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XMFVolumBlock)(NSInteger num);

@interface XMFRecordTool : NSObject

/// 单例
+ (instancetype)shareInstance;
/// 开始录音
- (void)startRecord;
/// 中断录制，并删除录音
- (void)interruptRecord;
/// 取消录制
- (void)cancelRecord;
/// 获得当前录制音量
- (void)getVolumWithHandle : (XMFVolumBlock)handle;
/// 开始播放录音（只允许本地录音）
- (void)startPlayWithUrl : (NSURL *) url;
/// 获得当前播放状态
- (BOOL)getPlayerState;
/// 获得当前播放时间
- (NSString *)getCurrentRecordTime;
/// 本地录音地址
- (NSURL *)pathUrl;
/// 停止播放
- (void)cancelPlay;

///  本地或网络音频播放
- (void)playNetWorkSourceWithURL:(NSURL *)url compeletAction : (dispatch_block_t) action;
/// 关闭播放
- (void)stopNetWorkSourcePlay;
/// 当前播放url
@property (nonatomic, strong, readonly) NSURL *pathUrl;
/// 是否正在播放
@property (nonatomic, assign, readonly) BOOL isPlayingNetWork;

@end
