//
//  SBView.m
//  animationTest
//
//  Created by xumingfa on 16/8/4.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFThreeBallView.h"
#import "UIView+XMFKeyboard.h"

@interface XMFThreeBallView ()

@property (weak, nonatomic) CAShapeLayer *redLayer;

@property (weak, nonatomic) CAShapeLayer *blueLayer;

@property (weak, nonatomic) CAShapeLayer *greenLayer;

@property (assign, nonatomic) CGPoint topCenterPoint;

@property (assign, nonatomic) CGPoint topLeftPoint;

@property (assign, nonatomic) CGPoint topRightPoint;

@property (assign, nonatomic) CGPoint centerPoint;

@property (assign, nonatomic) CGPoint bottomLeftPoint;

@property (assign, nonatomic) CGPoint bottomRightPoint;

@property (assign, nonatomic) CGFloat dotWidth;

@property (assign, nonatomic) CGFloat dotHeight;

@end

@implementation XMFThreeBallView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (CGFloat)dotSize {
    
    if (_dotSize <= 0) {
        _dotSize = 10;
    }
    return _dotSize;
}

- (CGFloat)dotWidth {
    
    if (_dotWidth <= 0) {
        _dotWidth = self.dotSize;
    }
    return _dotWidth;
}

- (CGFloat)dotHeight {
    
    if (_dotHeight <= 0) {
        _dotHeight = self.dotSize;
    }
    return _dotHeight;
}

- (UIColor *)aBallColor {
    
    if (!_aBallColor) {
        _aBallColor = [UIColor colorWithRed:255 / 255.f green:102 / 255.f blue:102 / 255.f alpha:1];
    }
    return _aBallColor;
}

- (UIColor *)bBallColor {
    
    if (!_bBallColor) {
        _bBallColor = [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:102 / 255.f alpha:1];
    }
    return _bBallColor;
}

- (UIColor *)cBallColor {
    
    if (!_cBallColor) {
        _cBallColor = [UIColor colorWithRed:153 / 255.f green:204 / 255.f blue:102 / 255.f alpha:1];
    }
    return _cBallColor;
}

- (void)initUI {
    
    CGRect frame = CGRectMake(0, 0, self.dotWidth, self.dotHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    CAShapeLayer *redLayer = [CAShapeLayer layer];
    redLayer.path = path.CGPath;
    redLayer.fillColor = self.aBallColor.CGColor;
    _redLayer = redLayer;
    [self.layer addSublayer:_redLayer];
    
    CAShapeLayer *blueLayer = [CAShapeLayer layer];
    blueLayer.path = path.CGPath;
    blueLayer.fillColor = self.bBallColor.CGColor;
    _blueLayer = blueLayer;
    [self.layer addSublayer:_blueLayer];
    
    CAShapeLayer *greenLayer = [CAShapeLayer layer];
    greenLayer.path = path.CGPath;
    greenLayer.fillColor = self.cBallColor.CGColor;
    _greenLayer = greenLayer;
    [self.layer addSublayer:_greenLayer];
}


- (CGPoint)topCenterPoint {
    
    if (CGPointEqualToPoint(CGPointZero, _topCenterPoint)) {
        _topCenterPoint = CGPointMake(CGRectGetMidX(self.bounds), -self.dotHeight / 2);
    }
    return _topCenterPoint;
}

- (CGPoint)topLeftPoint {
    
    if (CGPointEqualToPoint(CGPointZero, _topLeftPoint)) {
        _topLeftPoint = CGPointMake(CGRectGetMinX(self.bounds), -self.dotHeight / 2);
    }
    return _topLeftPoint;
}

- (CGPoint)topRightPoint {
    
    if (CGPointEqualToPoint(CGPointZero, _topRightPoint)) {
        _topRightPoint = CGPointMake(CGRectGetMaxX(self.bounds), -self.dotHeight / 2);
    }
    return _topRightPoint;
}

- (CGPoint)centerPoint {
    
    if (CGPointEqualToPoint(CGPointZero, _centerPoint)) {
        _centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    return _centerPoint;
}

- (CGPoint)bottomLeftPoint {
    
    if (CGPointEqualToPoint(CGPointZero, _bottomLeftPoint)) {
        _bottomLeftPoint = CGPointMake(-self.dotWidth / 2, CGRectGetMaxY(self.bounds));
    }
    return _bottomLeftPoint;
}

- (CGPoint)bottomRightPoint {
    
    if (CGPointEqualToPoint(CGPointZero, _bottomRightPoint)) {
        _bottomRightPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    }
    return _bottomRightPoint;
}

- (void)play {
    
    [self layoutIfNeeded];
    
    if (self.ballStyle == XMFBallHUDStyleTriangleMovement)
        [self animationOne];
    else if (self.ballStyle == XMFBallHUDStyleCollision)
        [self animationTwo];
    else
        [self animationThree];
}

/*!
 三角动画
 */
- (void)animationOne {
    
    UIBezierPath *aAnimationPath = [UIBezierPath bezierPath];
    [aAnimationPath moveToPoint:self.topCenterPoint];
    [aAnimationPath addLineToPoint:self.bottomLeftPoint];
    [aAnimationPath addLineToPoint:self.bottomRightPoint];
    [aAnimationPath closePath];
    
    CAKeyframeAnimation *aKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    aKeyAnimation.path = aAnimationPath.CGPath;
    aKeyAnimation.duration = 1;
    aKeyAnimation.repeatCount = HUGE_VALF;
    
    UIBezierPath *bAnimationPath = [UIBezierPath bezierPath];
    [bAnimationPath moveToPoint:self.bottomLeftPoint];
    [bAnimationPath addLineToPoint:self.bottomRightPoint];
    [bAnimationPath addLineToPoint:self.topCenterPoint];
    [bAnimationPath closePath];
    
    CAKeyframeAnimation *bKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    bKeyAnimation.path = bAnimationPath.CGPath;
    bKeyAnimation.duration = 1;
    bKeyAnimation.repeatCount = HUGE_VALF;
    
    UIBezierPath *cAnimationPath = [UIBezierPath bezierPath];
    [cAnimationPath moveToPoint:self.bottomRightPoint];
    [cAnimationPath addLineToPoint:self.topCenterPoint];
    [cAnimationPath addLineToPoint:self.bottomLeftPoint];
    [cAnimationPath closePath];
    
    CAKeyframeAnimation *cKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    cKeyAnimation.path = cAnimationPath.CGPath;
    cKeyAnimation.duration = 1;
    cKeyAnimation.repeatCount = HUGE_VALF;
    
    
    [self.redLayer addAnimation:aKeyAnimation forKey:nil];
    [self.blueLayer addAnimation:bKeyAnimation forKey:nil];
    [self.greenLayer addAnimation:cKeyAnimation forKey:nil];
}

/*!
 半环运动
 */
- (void)animationTwo {
    
    CGFloat totalTimes = 0.9;
    CGFloat duration = totalTimes / 4;
    
    UIBezierPath *aAnimationPath1 = [UIBezierPath bezierPath];
    [aAnimationPath1 moveToPoint: self.topLeftPoint];
    [aAnimationPath1 addQuadCurveToPoint:CGPointMake(self.centerPoint.x - self.dotWidth, self.centerPoint.y) controlPoint:  CGPointMake(self.topLeftPoint.x, self.centerPoint.y)];
    
    CAKeyframeAnimation *aKeyAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    aKeyAnimation1.path = aAnimationPath1.CGPath;
    aKeyAnimation1.beginTime = totalTimes * 0;
    aKeyAnimation1.duration = duration;
    aKeyAnimation1.fillMode = kCAFillModeForwards;
    aKeyAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    UIBezierPath *aAnimationPath2 = [UIBezierPath bezierPath];
    [aAnimationPath2 moveToPoint: CGPointMake(self.centerPoint.x - self.dotWidth, self.centerPoint.y)];
    [aAnimationPath2 addQuadCurveToPoint:self.topLeftPoint controlPoint:  CGPointMake(self.topLeftPoint.x, self.centerPoint.y)];
    
    CAKeyframeAnimation *aKeyAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    aKeyAnimation2.path = aAnimationPath2.CGPath;
    aKeyAnimation2.beginTime = totalTimes / 4 * 3;
    aKeyAnimation2.duration = duration;
    aKeyAnimation2.fillMode = kCAFillModeForwards;
    aKeyAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *aAnimationGroup = [CAAnimationGroup animation];
    aAnimationGroup.animations = @[aKeyAnimation1, aKeyAnimation2];
    aAnimationGroup.repeatCount = HUGE_VALF;
    aAnimationGroup.duration = totalTimes;
    
    [self.redLayer addAnimation:aAnimationGroup forKey:nil];
    /***** 万恶的分割线 *****/
    UIBezierPath *cAnimationPath = [UIBezierPath bezierPath];
    [cAnimationPath moveToPoint: CGPointMake(self.centerPoint.x + self.dotWidth, self.centerPoint.y)];
    [cAnimationPath addQuadCurveToPoint:self.topRightPoint controlPoint:CGPointMake(self.topRightPoint.x - self.dotWidth / 2, self.centerPoint.y)];
    
    CAKeyframeAnimation *cKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    cKeyAnimation.path = cAnimationPath.CGPath;
    cKeyAnimation.beginTime = totalTimes / 4;
    cKeyAnimation.duration = duration;
    cKeyAnimation.fillMode = kCAFillModeForwards;
    cKeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    UIBezierPath *cAnimationPath2 = [UIBezierPath bezierPath];
    [cAnimationPath2 moveToPoint: self.topRightPoint];
    [cAnimationPath2 addQuadCurveToPoint:CGPointMake(self.centerPoint.x + self.dotWidth, self.centerPoint.y) controlPoint: CGPointMake(self.topRightPoint.x - self.dotWidth / 2, self.centerPoint.y)];
    
    CAKeyframeAnimation *cKeyAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    cKeyAnimation2.path = cAnimationPath2.CGPath;
    cKeyAnimation2.beginTime = totalTimes / 2;
    cKeyAnimation2.duration = duration;
    cKeyAnimation2.fillMode = kCAFillModeForwards;
    cKeyAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *bAnimationGroup = [CAAnimationGroup animation];
    bAnimationGroup.animations = @[cKeyAnimation, cKeyAnimation2];
    bAnimationGroup.repeatCount = HUGE_VALF;
    bAnimationGroup.duration = totalTimes;
    
    [self.greenLayer addAnimation:bAnimationGroup forKey:nil];
}

/*!
 大小变化
 */
- (void)animationThree {
    
    [self.greenLayer removeFromSuperlayer];
    
    CGFloat totalTimes = 2;
    CGFloat duration = totalTimes / 4;
    
    CABasicAnimation *aAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    aAnimation.fromValue = @(1);
    aAnimation.toValue = @(1.5);
    aAnimation.fillMode = kCAFillModeForwards;
    aAnimation.beginTime = CACurrentMediaTime();
    aAnimation.repeatCount = HUGE_VALF;
    aAnimation.autoreverses = YES;
    aAnimation.duration = duration;
    
    CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    cAnimation.fromValue = @(1);
    cAnimation.toValue = @(1.5);
    cAnimation.fillMode = kCAFillModeForwards;
    cAnimation.beginTime = totalTimes / 2;
    cAnimation.repeatCount = HUGE_VALF;
    cAnimation.autoreverses = YES;
    cAnimation.duration = duration;
    
    [self.redLayer addAnimation:aAnimation forKey:nil];
    [self.blueLayer addAnimation:cAnimation forKey:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.ballStyle == XMFBallHUDStyleTriangleMovement) {
        self.redLayer.frame = CGRectMake(self.topCenterPoint.x, self.topCenterPoint.y, self.dotWidth, self.dotHeight);
        self. blueLayer.frame = CGRectMake(self.bottomLeftPoint.x, self.bottomLeftPoint.y, self.dotWidth, self.dotHeight);
        self.greenLayer.frame = CGRectMake(self.bottomRightPoint.x, self.bottomRightPoint.y, self.dotWidth, self.dotHeight);
        
    } else if (self.ballStyle == XMFBallHUDStyleCollision) {
        self.redLayer.frame = CGRectMake(self.topLeftPoint.x - self.dotWidth / 2, self.topRightPoint.y - self.dotHeight / 2
                                         , self.dotWidth, self.dotHeight);
        self.blueLayer.frame = CGRectMake(self.centerPoint.x - self.dotWidth / 2, self.centerPoint.y - self.dotHeight / 2, self.dotWidth, self.dotHeight);
        self.greenLayer.frame = CGRectMake(self.centerPoint.x + self.dotWidth / 2, self.centerPoint.y - self.dotHeight / 2, self.dotWidth, self.dotHeight);
    }
    else {
        self.redLayer.frame = CGRectMake(CGRectGetMaxX(self.bounds) / 4 - self.dotWidth / 2, self.centerPoint.y  - self.dotHeight / 2, self.dotWidth, self.dotHeight);
        self.blueLayer.frame = CGRectMake(CGRectGetMaxX(self.bounds) / 4 * 3 - self.dotWidth / 2, self.centerPoint.y  - self.dotHeight / 2, self.dotWidth, self.dotHeight);
    }
}

- (void)dealloc {
    
    [self xmf_removeKeyboardHeightChangeListen];
}

@end
