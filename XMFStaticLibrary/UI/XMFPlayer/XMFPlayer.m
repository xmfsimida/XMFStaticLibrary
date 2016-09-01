//
//  XMFPlayer.m
//  XMFPlayer
//
//  Created by xumingfa on 16/6/1.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+XMFCategory.h"
#import "XMFPlayerMaskView.h"
#import "UIImage+Category.h"
#import "XMFMPMoviePlayerViewController.h"

typedef NS_ENUM(NSInteger, XMFPanDirection){
    
    XMFPanDirectionHorizontal, // 横移
    XMFPanDirectionVertical //  纵移
};

typedef NS_ENUM(NSInteger, XMFPlayerState) {
    
    XMFPlayerStateBuffering = 1010,  // 缓冲中
    XMFPlayerStatePlaying = 2020,    // 播放中
    XMFPlayerStateStopped = 3030,    // 停止播放
    XMFPlayerStatePause = 4040       // 暂停播放
};

@interface XMFPlayer () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (weak, nonatomic) AVPlayerLayer *playerLayer;
@property (weak, nonatomic) XMFPlayerMaskView *videoMaskView;

@property (assign, nonatomic) XMFPanDirection panDirection;
@property (assign, nonatomic) XMFPlayerState playerState;
@property (assign, nonatomic, getter=isDragSlider) BOOL dragSlider;
@property (strong, nonatomic) UISlider *volumeViewSlider;

@property (assign, nonatomic) BOOL isFull;

/// 滑动事件
@property (weak, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation XMFPlayer

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 200, 200)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (void)initialize
{
    
    self.backgroundColor = [UIColor blackColor];
    _player = [[AVPlayer alloc] init];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer: self.player];
    
    if ([self.playerLayer.videoGravity isEqualToString: AVLayerVideoGravityResizeAspect]) {
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterForeground)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监听屏幕转动
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self changeProgress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [self.videoMaskView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    [doubleTap setNumberOfTouchesRequired:1];
    [doubleTap setNumberOfTapsRequired:2];
    [self.videoMaskView addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
    
}

- (XMFPlayerMaskView *)videoMaskView {
    
    if (_videoMaskView) return _videoMaskView;
    XMFPlayerMaskView *videoMaskView = [[XMFPlayerMaskView alloc] initWithFrame:self.bounds];
    [videoMaskView.playBN addTarget:self action:@selector(playerAction:) forControlEvents:UIControlEventTouchUpInside];
    [videoMaskView.fullScreenBN addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [videoMaskView.videoSlider addTarget:self action:@selector(sliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [videoMaskView.videoSlider addTarget:self action:@selector(sliderTouchChanged:) forControlEvents:UIControlEventValueChanged];
    [videoMaskView.videoSlider addTarget:self action:@selector(sliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    _videoMaskView = videoMaskView;
    [self addSubview: _videoMaskView];
    videoMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *layoutAry = @[
                           [NSLayoutConstraint constraintWithItem:videoMaskView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:videoMaskView.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]
                           ,[NSLayoutConstraint constraintWithItem:videoMaskView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:videoMaskView.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                           ,[NSLayoutConstraint constraintWithItem:videoMaskView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:videoMaskView.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:0]
                           ,[NSLayoutConstraint constraintWithItem:videoMaskView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:videoMaskView.superview attribute:NSLayoutAttributeHeight multiplier:1 constant:0]
                           ];
    [videoMaskView.superview addConstraints:layoutAry];
    return _videoMaskView;
}


- (void)setVideoURL:(NSURL *)videoURL
{
    
    _videoURL = videoURL;
    //将之前的监听时间移除掉。
    [self removeAllObserver];
    self.playerItem = nil;
    self.playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    // AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    // 监听播放状态
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    __weak typeof(self) weakSelf = self;
    if (self.stopPlayCoverImage) { // 设置背景图
        weakSelf.videoMaskView.thumbnailIV.image = self.stopPlayCoverImage;
    }
    else {
        [UIImage getThumbnailImage:_videoURL block:^(UIImage *image) {
            weakSelf.videoMaskView.thumbnailIV.image = image;
        }];
    }
}

/*!
 暂停播放
 */
- (void)pause {
    
    self.videoMaskView.thumbnailIV.hidden = self.videoMaskView.thumbnailIV ? YES : NO;
    [self.player pause];
    self.playerState = XMFPlayerStatePause;
    self.videoMaskView.playerImage.hidden = NO;
    self.videoMaskView.playBN.selected = NO;
}

/*!
 播放
 */
- (void)play {
    
    if (!self.videoURL.absoluteString || self.videoURL.absoluteString.length == 0) return;
    self.videoMaskView.thumbnailIV.hidden = self.videoMaskView.thumbnailIV ? YES : NO;
    [self.player play];
    self.playerState = XMFPlayerStatePlaying;
    self.videoMaskView.playerImage.hidden = YES;
    self.videoMaskView.playBN.selected = YES;
}

/*!
 播放按钮事件
 */
- (void)playerAction : (UIButton *)button {
    
    if (button.selected) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/*!
 全屏按钮事件
 */
- (void)fullScreenAction : (UIButton *)button {
    
    if (!self.isAllowFullScreen) return;
    
    button.selected = !button.selected;
    [self interfaceOrientation:(button.selected==YES) ? UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait];
    if (button.isSelected) {
        [self addPanGesture];
        self.isFull = YES;
        self.videoMaskView.bottomView.hidden = NO;
        self.videoMaskView.topView.hidden = NO;
    }
    else {
        [self removePanGesture];
        self.isFull = NO;
        self.videoMaskView.bottomView.hidden = YES;
        self.videoMaskView.topView.hidden = YES;
    }
}



/*!
 滑动条事件
 */
- (void)sliderTouchBegan : (UISlider *)slider {
    self.dragSlider = YES;
}

- (void)sliderTouchChanged : (UISlider *)slider {
    
    CGFloat total   = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    CGFloat current = total*slider.value;
    //秒数
    NSInteger proSec = (NSInteger)current%60;
    //分钟
    NSInteger proMin = (NSInteger)current/60;
    NSString *timeStr = self.videoMaskView.timeLB.text;
    if (timeStr.length > 5) {
        [timeStr stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:[NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec]];
    }
    self.videoMaskView.timeLB.text = timeStr;
}

- (void)sliderTouchEnded : (UISlider *)slider {
    
    // 计算出拖动的当前秒数
    CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    NSInteger dragedSeconds = floorf(total * slider.value);
    // 转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self endSlideTheVideo:dragedCMTime];
}

// 滑动结束视频跳转
- (void)endSlideTheVideo:(CMTime)dragedCMTime
{
    
    [self.player pause];
    [self.videoMaskView.activityView startAnimating];
    __weak typeof(self) weakSelf = self;
    [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
        
        [weakSelf.videoMaskView.activityView stopAnimating];
        if (!weakSelf.videoMaskView.playBN.isSelected) {        // 如果点击了暂停按钮
            weakSelf.dragSlider = NO;
            return ;
        }
        if ((weakSelf.videoMaskView.bufferPV.progress - weakSelf.videoMaskView.videoSlider.value) >= 0.f)
            [weakSelf play];
        else
            [weakSelf bufferingSomeSecond];
        weakSelf.dragSlider = NO;
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.playerItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                
                [self.videoMaskView.activityView stopAnimating];
                self.playerState = XMFPlayerStateStopped;
            } else if (self.player.status == AVPlayerStatusFailed){
                
                self.playerState = XMFPlayerStateStopped;
                [self.videoMaskView.activityView startAnimating];
            }
            
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            [self.videoMaskView.bufferPV setProgress:timeInterval / totalDuration animated:NO];
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            if (self.playerItem.playbackBufferEmpty) {            // 当缓冲是空的时候
                self.playerState = XMFPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            if (self.playerItem.playbackLikelyToKeepUp){            // 当缓冲好的时候
                self.playerState = XMFPlayerStatePause;
                [self.videoMaskView.activityView stopAnimating];
            }
        }
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

/*!
 缓冲
 */
- (void)bufferingSomeSecond
{
    
    [self.videoMaskView.activityView startAnimating];
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!self.videoMaskView.playBN.isSelected) {        // 如果此时用户已经暂停了，则不再需要开启播放了
            [self.videoMaskView.activityView stopAnimating];
            isBuffering = NO;
            return;
        }
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        /** 是否缓冲好的标准 （系统默认是1分钟。不建议用 ）*/
        //self.playerItme.isPlaybackLikelyToKeepUp
        if ((self.videoMaskView.bufferPV.progress - self.videoMaskView.videoSlider.value) > 0.01) {
            self.playerState = XMFPlayerStatePlaying;
            [self play];
        }
        else
        {
            [self bufferingSomeSecond];
        }
        [self.videoMaskView.activityView stopAnimating];
    });
}

#pragma mark - NSNotification Action
// 播放完了
- (void)moviePlayDidEnd:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [_player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finish){
        
        [weakSelf.videoMaskView.videoSlider setValue:0.0 animated:YES];
        NSString *timeStr = weakSelf.videoMaskView.timeLB.text;
        if (timeStr.length > 5) {
            [timeStr stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"00:00"];
        }
        weakSelf.videoMaskView.timeLB.text = timeStr;
        
    }];
    
    self.playerState = XMFPlayerStateStopped;
    self.videoMaskView.playBN.selected = NO;
    self.videoMaskView.thumbnailIV.hidden = NO;
    self.videoMaskView.playerImage.hidden = NO;
}

/*!
 应用进入后台
 */
- (void)appDidEnterBackground {
    
    [self pause];
}


/*!
 应用进入前台
 */
- (void)appDidEnterForeground {
    
    if (self.playerState == XMFPlayerStatePlaying) [self play];
}

/*!
 屏幕转动
 */
- (void)onDeviceOrientationChange {
    
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (interfaceOrientation == UIInterfaceOrientationPortrait ) {
        //  改变视频大小
//                self.initializationFrame = self.frame;
        
//                self.videoMaskView.fullScreenBN.selected = NO;
        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
    }else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

/*!
 改变progress
 */
- (void)changeProgress {
    
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        if (weakSelf.isDragSlider) return ;
        
        float currentTime = CMTimeGetSeconds(time); // 当前时间
        float totalTime = CMTimeGetSeconds(weakSelf.playerItem.duration);
        
        if (currentTime) [weakSelf.videoMaskView.videoSlider setValue:(currentTime / totalTime) animated:YES];
        
        // 当前 秒 分
        NSInteger proSec = (NSInteger)currentTime % 60;
        NSInteger proMin = (NSInteger)currentTime / 60;
        
        // 总 秒 分
        NSInteger durSec = (NSInteger)totalTime % 60;
        NSInteger durMin = (NSInteger)totalTime / 60;
        
        weakSelf.videoMaskView.timeLB.text = [NSString stringWithFormat:@"%02zd:%02zd%02zd:%02zd", proMin, proSec , durMin, durSec];
    }];
}

#pragma mark - 平移手势方法

- (void)tapGesture:(UIPanGestureRecognizer *)pan
{
    if (!self.videoURL || self.videoURL.absoluteString.length == 0) return;
    [self playerAction:self.videoMaskView.playBN];
}

- (void)doubleTapGesture:(UIPanGestureRecognizer *)pan
{
    
    [self pause];
    XMFMPMoviePlayerViewController *moviePlayer = [[XMFMPMoviePlayerViewController alloc] initWithContentURL:self.videoURL];
    UIViewController *vc = [self xmf_getBelongViewController];
    [vc presentMoviePlayerViewControllerAnimated: moviePlayer];
//    [self fullScreenAction:self.videoMaskView.fullScreenBN];
}

- (void)addPanGesture {
    
    // 添加平移手势，用来控制音量、亮度、快进快退
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDirection:)];
    [self.videoMaskView addGestureRecognizer:pan];
    _panGesture = pan;
}

- (void)removePanGesture {
    
    [self.videoMaskView removeConstraint:self.panGesture];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    // 判断是垂直移动还是水平移动
    CGPoint point = [pan translationInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                self.panDirection = XMFPanDirectionHorizontal;
                self.dragSlider = YES;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = XMFPanDirectionVertical;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            if (self.panDirection == XMFPanDirectionHorizontal) {
                [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                [self sliderTouchChanged:self.videoMaskView.videoSlider];
            }
            else if (self.panDirection == XMFPanDirectionVertical) {
                [self verticalMoved: veloctyPoint.y]; // 垂直移动方法只要y方向的值
            }
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            if (self.panDirection == XMFPanDirectionHorizontal) {
                [self sliderTouchEnded:self.videoMaskView.videoSlider];
            }
            else if (self.panDirection == XMFPanDirectionVertical) {
                
            }
        }
        default:
            break;
    }
}

- (UISlider *)volumeViewSlider {
    
    if (_volumeViewSlider) return _volumeViewSlider;
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider *volumeViewSlider = nil;
    for (UIView *view in volumeView.subviews){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    _volumeViewSlider = volumeViewSlider;
    return _volumeViewSlider;
}

/*!
 改变系统音量
 */
- (void)verticalMoved:(CGFloat)value
{

    if (self.playerState == XMFPlayerStatePlaying || self.playerState == XMFPlayerStateBuffering) { // 播放或者缓冲
        
        [self.volumeViewSlider setValue: MIN(self.volumeViewSlider.maximumValue, self.volumeViewSlider.value - value / 10000) animated:YES];
    }
}

-(void)horizontalMoved:(CGFloat)value
{
    self.videoMaskView.videoSlider.value += value / 10000;
}

- (void) removeAllObserver {
    
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAllObserver];
}

@end
