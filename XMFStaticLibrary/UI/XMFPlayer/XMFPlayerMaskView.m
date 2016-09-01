//
//  XMFPlayerMaskView.m
//  XMFPlayer
//
//  Created by xumingfa on 16/6/1.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFPlayerMaskView.h"

@interface XMFPlayerMaskView ()

@property (weak, nonatomic) CAGradientLayer *bottomLayer;

@property (weak, nonatomic) CAGradientLayer *topLayer;

//@property (weak, nonatomic) UIView *bottomView;

//@property (weak, nonatomic) UIView *topView;
@end

@implementation XMFPlayerMaskView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 200, 200)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
        [self layoutItems];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initialize];
        [self layoutItems];
    }
    return self;
}

- (void)initialize
{
    
    //  头部
    UIView *topView = [UIView new];
    topView.hidden = YES;
    _topView = topView;
    [self addSubview: _topView];
    
    CAGradientLayer *topLayer = [CAGradientLayer layer];
    topLayer.startPoint = CGPointMake(1, 0);
    topLayer.endPoint = CGPointMake(1, 1);
    topLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    topLayer.locations = @[@0.0f, @1.0f];
    _topLayer = topLayer;
    [self.topView.layer addSublayer:_topLayer];
    
    //  尾部
    UIView *bottomView = [UIView new];
    bottomView.hidden = YES;
    _bottomView = bottomView;
    [self addSubview: _bottomView];
    
    CAGradientLayer *bottomLayer = [CAGradientLayer layer];
    bottomLayer.startPoint = CGPointMake(0, 0);
    bottomLayer.endPoint = CGPointMake(0, 1);
    bottomLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor blackColor].CGColor];
    bottomLayer.locations = @[@0.0f, @1.0f];
    _bottomLayer = bottomLayer;
    [self.bottomView.layer addSublayer:_bottomLayer];
    
    UILabel *timeLB = [UILabel new];
    timeLB.font = [UIFont systemFontOfSize:10.f];
    timeLB.textColor = [UIColor whiteColor];
    timeLB.text = @"00:0000:00";
    timeLB.numberOfLines = 0;
    timeLB.preferredMaxLayoutWidth = 30.f;
    _timeLB = timeLB;
    [self.bottomView addSubview: _timeLB];
    
    UIButton *playBN = [UIButton new];
    [playBN setImage:[UIImage imageNamed:@"XMFPlayerImage.bundle/Images/play"] forState:UIControlStateNormal];
    [playBN setImage:[UIImage imageNamed:@"XMFPlayerImage.bundle/Images/pause"] forState:UIControlStateSelected];
    _playBN = playBN;
    [self.bottomView addSubview: _playBN];
    
    UIButton *fullScreenBN = [UIButton new];
    [fullScreenBN setImage:[UIImage imageNamed:@"XMFPlayerImage.bundle/Images/full-screen"] forState:UIControlStateNormal];
    [fullScreenBN setImage:[UIImage imageNamed:@"XMFPlayerImage.bundle/Images/mid-screen"] forState:UIControlStateSelected];
    _fullScreenBN = fullScreenBN;
    [self.bottomView addSubview: _fullScreenBN];
    
    UIProgressView *bufferPV = [[UIProgressView alloc]init];
    bufferPV.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    bufferPV.trackTintColor = [UIColor clearColor];
    _bufferPV = bufferPV;
    [self.bottomView addSubview: _bufferPV];
    
    UISlider *videoSlider = [[UISlider alloc]init];
    [videoSlider setThumbImage:[UIImage imageNamed:@"XMFPlayerImage.bundle/Images/slider"] forState:UIControlStateNormal];
    videoSlider.minimumTrackTintColor = [UIColor whiteColor];
    videoSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.3 alpha:1];
    _videoSlider = videoSlider;
    [self.bottomView addSubview: _videoSlider];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityView = activityView;
    [self addSubview: _activityView];
    
    
    UIImageView *thumbnailIV = [[UIImageView alloc] init];
    thumbnailIV.contentMode = UIViewContentModeScaleToFill;
    thumbnailIV.backgroundColor = [UIColor blackColor];
    _thumbnailIV = thumbnailIV;
    [self addSubview: _thumbnailIV];
    
    UIImageView *playerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XMFPlayerImage.bundle/Images/play"]];
    _playerImage = playerImage;
    [self addSubview: _playerImage];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.topLayer.frame = self.topView.bounds;
    self.bottomLayer.frame = self.bottomView.bounds;
}

- (void)layoutItems {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    self.playBN.translatesAutoresizingMaskIntoConstraints = NO;
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLB.translatesAutoresizingMaskIntoConstraints = NO;
    self.bufferPV.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullScreenBN.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.thumbnailIV.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.timeLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLB setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    const CGFloat H_PADDING = 8.f;
    
    const CGFloat BUTTON_SIZE = 20.f;
    
    [self.activityView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30.f],
                                        [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30.f]
                                        ]];
    
    [self.topView addConstraint: [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30.f]];
    
    
    [self.bottomView addConstraints:@[
                                      [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30.f]
                                      , [NSLayoutConstraint constraintWithItem:self.playBN attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                                      ,[NSLayoutConstraint constraintWithItem:self.playBN attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeLeft multiplier:1 constant:H_PADDING]
                                      ,    [NSLayoutConstraint constraintWithItem:self.timeLB attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                                      , [NSLayoutConstraint constraintWithItem:self.timeLB attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.playBN attribute:NSLayoutAttributeRight multiplier:1 constant:H_PADDING]
                                      ,[NSLayoutConstraint constraintWithItem:self.bufferPV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                                      ,[NSLayoutConstraint constraintWithItem:self.fullScreenBN attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                                      
                                      ,[NSLayoutConstraint constraintWithItem:self.videoSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.bufferPV attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]
                                      ,[NSLayoutConstraint constraintWithItem:self.videoSlider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bufferPV attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                                      ,[NSLayoutConstraint constraintWithItem:self.videoSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.bufferPV attribute:NSLayoutAttributeHeight multiplier:1 constant:0]
                                      ,[NSLayoutConstraint constraintWithItem:self.videoSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.bufferPV attribute:NSLayoutAttributeWidth multiplier:1 constant:0]
                                      
                                      ,[NSLayoutConstraint constraintWithItem:self.bufferPV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.timeLB attribute:NSLayoutAttributeRight multiplier:1 constant:H_PADDING]
                                      , [NSLayoutConstraint constraintWithItem:self.bufferPV attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.fullScreenBN attribute:NSLayoutAttributeLeft multiplier:1 constant:-H_PADDING]
                                      , [NSLayoutConstraint constraintWithItem:self.fullScreenBN attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeRight multiplier:1 constant:-H_PADDING]
                                      ]];
    
    [self.playBN addConstraints:@[
                                  [NSLayoutConstraint constraintWithItem:self.playBN attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_SIZE],
                                  [NSLayoutConstraint constraintWithItem:self.playBN attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_SIZE]
                                  ]];
    
    [self.fullScreenBN addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:self.fullScreenBN attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_SIZE],
                                        [NSLayoutConstraint constraintWithItem:self.fullScreenBN attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_SIZE]
                                        ]];
    
    [self.bufferPV addConstraint:[NSLayoutConstraint constraintWithItem:self.bufferPV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_SIZE]
     ];
    
    NSArray *layout = @[
                        [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                        [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                        
                        [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                        [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                        [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                        
                        [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                        [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                        [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]
                        
                        ,[NSLayoutConstraint constraintWithItem:self.thumbnailIV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]
                        ,[NSLayoutConstraint constraintWithItem:self.thumbnailIV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                        ,[NSLayoutConstraint constraintWithItem:self.thumbnailIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]
                        ,[NSLayoutConstraint constraintWithItem:self.thumbnailIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]
                        ,[NSLayoutConstraint constraintWithItem:self.playerImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]
                        ,[NSLayoutConstraint constraintWithItem:self.playerImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                        ];
    [self addConstraints:layout];
}


@end
