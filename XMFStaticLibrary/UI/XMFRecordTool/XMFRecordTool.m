//
//  XMFRecordTool.m
//  ChatDemo
//
//  Created by xumingfa on 16/1/20.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFRecordTool.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface XMFRecordTool () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) NSURL *pathUrl;

@property (nonatomic, copy) NSString *audioSession;

@property (nonatomic, weak) NSTimer *timer;

//  网络
@property (nonatomic, strong) AVPlayer *avPlayer;

@property (nonatomic, assign) BOOL isPlayingNetWork;

@property (nonatomic, copy) dispatch_block_t compeletPlayAction;

@property (nonatomic, copy) XMFVolumBlock handle;

@end

@implementation XMFRecordTool

+ (instancetype)shareInstance {
    static dispatch_once_t onceRecord;
    static XMFRecordTool *recordTool;
    
    dispatch_once(&onceRecord, ^{
        recordTool = [[XMFRecordTool alloc] init];
        //添加监听
        [[NSNotificationCenter defaultCenter] addObserver:recordTool
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:recordTool
                                                 selector:@selector(moviePlayDidEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:recordTool
                                                 selector:@selector(moviePlayDidEnd)
                                                     name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                   object:nil];
    });
    
    return recordTool;
};


/**
 * 开始录制
 */
- (void)startRecord {
    
    if (self.recorder && self.recorder.isRecording) {
        [self cancelRecord];
    }
    
    self.audioSession   = [[AVAudioSession sharedInstance] category];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    //    [audioSession setActive:YES error:nil];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    //    NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",@"test"]];
    self.pathUrl = [NSURL URLWithString: path];
    
    if (!self.recorder) {
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.pathUrl settings:recordSetting error:nil];
        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;
    }
    
    [self.recorder prepareToRecord];
    [self.recorder record];
    
    self.timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

/**
 *  刷新视图
 */
- (void)refreshView {
    [self.recorder updateMeters];
    double lowPassResults = pow(10.0, (0.05 * [self.recorder peakPowerForChannel: 0]));
    float result = 100 * (float)lowPassResults;
    int number = 0;
    if (result > 0 && result <= 14.0) {
        number = 1;
    }
    else if (result > 14.0 && result <= 28.0) {
        number = 2;
    }
    else if (result > 28.0 && result <= 42.0) {
        number = 3;
    }
    else if (result > 42.0 && result <= 56.0) {
        number = 4;
    }
    else if (result > 56.0 && result <= 70.0) {
        number = 5;
    }
    else if (result > 70.0 && result <= 84.0) {
        number = 6;
    }
    else {
        number = 7;
    }
    
    if (self.handle) {
        self.handle(number);
    }
}

- (void)getVolumWithHandle:(XMFVolumBlock)handle {
    
    _handle = handle;
}



/**
 *  中断录制，并删除录音
 */
- (void)interruptRecord {
    [self cancelRecord];
    [self.recorder deleteRecording];
}


/**
 *  取消录制
 */
- (void)cancelRecord {
    [self.recorder stop];
    [[AVAudioSession sharedInstance] setCategory:self.audioSession error:nil];
}

- (NSString *)getCurrentRecordTime {
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:self.pathUrl options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    return [NSString stringWithFormat:@"%d", (int)audioDurationSeconds];
}

/**
 *  播放录音
 */
- (void)startPlayWithUrl : (NSURL *) url {
    
    self.audioSession = [[AVAudioSession sharedInstance] category];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];
    
    //添加红外检测，
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.player play];
    });
}

- (void)cancelPlay {
    //关掉红外检测，防止费电
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [self.player stop];
}

/**
 *  获得播放的状态
 */
- (BOOL)getPlayerState {
    return self.player.isPlaying;
}

#pragma mark - 网络播放
- (void)playNetWorkSourceWithURL:(NSURL *)url compeletAction:(dispatch_block_t)action{
    
    [self stopNetWorkSourcePlay];
    _pathUrl = url;
    _avPlayer = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:url]];
    //添加红外检测，
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.avPlayer play];
    });
    _isPlayingNetWork = YES;
    _compeletPlayAction = action;
}

- (void)stopNetWorkSourcePlay {
    
    if (self.avPlayer && self.isPlayingNetWork) {
        [self moviePlayDidEnd];
        [self.avPlayer pause];
        //关掉红外检测，防止费电
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
}

#pragma mark 播放结束
-(void)moviePlayDidEnd{
    
    self.isPlayingNetWork = NO;
    self.pathUrl = nil;
    if (self.compeletPlayAction) self.compeletPlayAction();
}

#pragma mark - AVAudioPlayerDelegate
/*
 Occurs when the audio player instance completes playback
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //To update UI on stop playing
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [self.timer invalidate];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{

}

//添加红外检测
//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES){
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
}

@end
