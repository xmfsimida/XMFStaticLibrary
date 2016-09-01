//
//  XMFLoadingButton.m
//  XMFLoadingButton
//
//  Created by xumingfa on 16/5/29.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFLoadingButton.h"

@interface XMFLoadingButton ()

@property (nonatomic, weak) CAShapeLayer *loadingLayer;
///  默认状态frame
@property (nonatomic, assign) CGRect nomarlFrame;
/// 默认状态radius
@property (nonatomic, assign) CGFloat nomarlRadius;
/// 颜色
@property (nonatomic, assign) UIColor *nomarlTextColor;

@end

@implementation XMFLoadingButton

- (void)setStatus:(XMFLoadingButtonStatus)status {
    
    @synchronized (self) {
        if (status == _status) return;
    }
    _status = status;
    [self changeStatus];
}

- (UIColor *)loadingColor {
    
    if (_loadingColor) return _loadingColor;
    _loadingColor = [UIColor redColor];
    return  _loadingColor;
}

- (CGFloat)lineWidth {
    
    if (_lineWidth > 0) return _lineWidth;
    _lineWidth = 5.f;
    return _lineWidth;
}

- (void)changeStatus {
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
    if (self.status == XMFLoadingButtonStatusNomarl) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = self.nomarlFrame;
            self.layer.cornerRadius = self.nomarlRadius;
        } completion:^(BOOL finished) {
            [self setTitleColor:self.nomarlTextColor forState: UIControlStateNormal];
            self.loadingLayer.hidden = YES;
            self.enabled = YES;
        }];
    }
    else {
        self.enabled = NO;
        self.nomarlTextColor = self.titleLabel.textColor;
        self.nomarlFrame = self.frame;
        self.nomarlRadius = self.layer.cornerRadius;
        CGRect newFrame = self.frame;
        newFrame.origin = CGPointMake(CGRectGetMidX(self.frame) - [self filterMaxSize] / 2 , CGRectGetMidY(self.frame) - [self filterMaxSize] / 2);
        newFrame.size = CGSizeMake([self filterMaxSize], [self filterMaxSize]);
        self.layer.masksToBounds = YES;
        [self setTitleColor:self.backgroundColor forState: UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = newFrame;
            self.layer.cornerRadius = [self filterMaxSize] / 2;
        } completion:^(BOOL finished) {
            self.loadingLayer.hidden = NO;
        }];
    }
}

/*!
 选最小的边
 */
- (CGFloat)filterMaxSize {
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    
    if (height - width > 0) {
        return width;
    }
    else {
        return height;
    }
}

- (CAShapeLayer *)loadingLayer {
    
    if (_loadingLayer) return _loadingLayer;
    CGRect bounds = CGRectMake(0, 0, [self filterMaxSize], [self filterMaxSize]);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = bounds;
    shapeLayer.strokeColor = self.loadingColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = self.lineWidth;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.strokeStart = 0.f;
    shapeLayer.strokeEnd = 0.7;
    shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:bounds];
    shapeLayer.path = path.CGPath;
    [shapeLayer addAnimation:[self getAnimation] forKey:nil];
    [self.layer addSublayer: shapeLayer];
    _loadingLayer = shapeLayer;
    return shapeLayer;

}

- (CABasicAnimation *)getAnimation
{
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.autoreverses = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.duration = 0.5;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return rotationAnimation;
}

@end
