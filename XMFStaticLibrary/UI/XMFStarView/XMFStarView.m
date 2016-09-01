//
//  XMFStarView.m
//  XMFStarView
//
//  Created by xumingfa on 16/7/5.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFStarView.h"

@interface XMFStarView ()

@property (nonatomic, strong) NSArray<UIImageView *> *imageViewAry;

@end

#define XMF_STAR_COUNT 5 // 星星数量

@implementation XMFStarView

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)setStarValue:(NSUInteger)starValue {
    
    _starValue = starValue > XMF_STAR_COUNT ? XMF_STAR_COUNT : starValue;
    [self changeStarValue: _starValue];
}

- (void)initUI {
    
    NSMutableArray<UIImageView *> *ary = [NSMutableArray arrayWithCapacity: XMF_STAR_COUNT];
    UIImageView *iv = nil;
    for (int i = 0; i < XMF_STAR_COUNT; i++) {
        
        iv = [[UIImageView alloc] init];
        [ary addObject: iv];
        [self addSubview: iv];
    }
    _imageViewAry = ary;
    
    [self changeStarValue: self.starValue];
}

- (void)setNormalImage:(UIImage *)normalImage {
    
    _normalImage = normalImage;
    [self changeNormalImage];
}

- (void)changeNormalImage {
    
    for (UIImageView *imageView in self.imageViewAry) {
        imageView.image = self.normalImage;
    }
}

- (void)setHightlightImage:(UIImage *)hightlightImage {
    
    _hightlightImage = hightlightImage;
    [self changeHighlightImage];
}

- (void)changeHighlightImage {
    
    for (UIImageView *imageView in self.imageViewAry) {
        imageView.highlightedImage = self.hightlightImage;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self tranPxToCurrentX: touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self tranPxToCurrentX: touches];
}

- (void)tranPxToCurrentX : (NSSet<UITouch *> *)touches {
    
    if (!self.isChange) return;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self countStarNumCurrentX:point.x];
}

/*!
 根据当前坐标算出有几颗高亮星星
 */
- (void)countStarNumCurrentX : (CGFloat)currentX {
    
    NSUInteger starValue = ceilf(currentX * XMF_STAR_COUNT / CGRectGetWidth(self.bounds));
    [self changeStarValue: starValue];
}

- (void)changeStarValue : (NSUInteger)starValue {
    
    for (int i = 0; i < XMF_STAR_COUNT; i++) {
        
        self.imageViewAry[i].highlighted = i + 1 <= starValue ? YES : NO;
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    const CGFloat V_PADDING = 2.f;
    const CGFloat H_PADDING = 2.f;
    
    const CGFloat HEIGHT = CGRectGetHeight(self.bounds) - V_PADDING * 2;
    const CGFloat WIDTH = (CGRectGetWidth(self.bounds) - (H_PADDING + 1) * XMF_STAR_COUNT) / XMF_STAR_COUNT;
    
    for (int i = 0; i < XMF_STAR_COUNT; i++) {
        
        CGRect frame = CGRectMake(i == 0 ? H_PADDING : CGRectGetMaxX(self.imageViewAry[i - 1].frame) + H_PADDING, V_PADDING, WIDTH, HEIGHT);
        self.imageViewAry[i].frame = frame;
    }
}

@end
