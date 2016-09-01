//
//  XMFToastView.m
//  XMFToastView
//
//  Created by xumingfa on 16/6/8.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFToastView.h"
#import "UIView+XMFKeyboard.h"
#import "UIView+XMFCategory.h"

@interface XMFToastView ()

@property (nonatomic, weak) UILabel *titleLB;

@property (nonatomic, weak) UIImageView *image;

@property (nonatomic, assign) XMFToastPosition position;

@end

#define MAX_HEIGHT 300.f //最大高度

#define H_PADDING 8.f // 边距

#define H_MARGIN 25.f // 内边距

#define V_PADDING 16.f // 上下边距

@implementation XMFToastView

+ (void)showToastViewToView:(__kindof UIView *)view content:(NSString *)content position:(XMFToastPosition)position duration:(CGFloat)duration {
    
    if (duration <= 0.f) duration = 1.5f;
    if (!content) content = @"";
    
    XMFToastView *tosatView = [XMFToastView new];
    tosatView.position = position;
    if (!view) {
        [[[[UIApplication sharedApplication] delegate] window] addSubview: tosatView];
    }
    else {
        [view addSubview: tosatView];
    }
    
    [tosatView initUI:content];
    [tosatView layoutItems];
    [tosatView addStartAnimation];
    
    [tosatView dismissTosatWithDelay:duration];
}

+ (void)showToastViewToView:(__kindof UIView *)view
                    content:(NSString *)content
                   duration:(CGFloat)duration {
    
    
    [self showToastViewToView:view content:content position:XMFToastPositionCenter duration:duration];
}

- (void)addStartAnimation {
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    baseAnimation.fromValue = @0.1f;
    baseAnimation.toValue = @1.f;
    baseAnimation.autoreverses = NO;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    baseAnimation.duration = 0.3;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:baseAnimation forKey:nil];
}


- (void)dismissTosatWithDelay : (NSTimeInterval)delay {

    [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
;
}

- (void)initUI : (NSString *)title {
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.text = title;
    titleLB.numberOfLines = 0;
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = [UIColor whiteColor];
    _titleLB = titleLB;
    [self addSubview: _titleLB];
}

/*!
 计算出被Nav覆盖的大小
 */
- (CGFloat)countNavY {
    
    // 防止被navagationBar覆盖
    CGFloat vOffset = 8.f; // 上下偏移量
    CGFloat yOffet = 0.0;
    CGPoint rPoint = [self.superview convertPoint:self.superview.frame.origin toView:nil];
    const CGFloat NAVAGATIONBAR_Y = 64.f; // 导航栏的最大y值
    UIViewController *vc = [self xmf_getBelongViewController];
    if (vc && vc.navigationController && rPoint.y < NAVAGATIONBAR_Y) {
        yOffet = NAVAGATIONBAR_Y + rPoint.y;
    }
    return yOffet + vOffset;
}

/*!
 计算出被Tab覆盖的大小
 */
- (CGFloat)countTabY {
    
    CGFloat vOffset = 8.f; // 上下偏移量
    CGRect rFrame = [self.superview convertRect:self.superview.frame toView:nil];
    CGFloat maxY = CGRectGetMaxY(rFrame);
    const CGFloat SCREEN_HEIGHT = [UIScreen mainScreen].bounds.size.height;
    const CGFloat TABBAR_Y = 44.f; // 导航栏的高度
    CGFloat yOffet = maxY - (SCREEN_HEIGHT  - TABBAR_Y);
    return yOffet - vOffset;
}


- (void)layoutItems {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLB.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *widthLayout = [NSLayoutConstraint constraintWithItem:self.titleLB attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-H_MARGIN * 2];
    widthLayout.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *heightLayout = [NSLayoutConstraint constraintWithItem:self.titleLB attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-V_PADDING * 2];
    heightLayout.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *titleXLayout = [NSLayoutConstraint constraintWithItem:self.titleLB attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *titleYLayout = [NSLayoutConstraint constraintWithItem:self.titleLB attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *hLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:MAX_HEIGHT];
    [self addConstraints:@[
                           widthLayout,
                           heightLayout,
                           titleXLayout,
                           titleYLayout,
                           hLayout
                           ]];
    
    NSLayoutConstraint *wLayout = nil;
    NSLayoutConstraint *xLayout = nil;
    NSLayoutConstraint *yLayout = nil;
    
    xLayout = [NSLayoutConstraint constraintWithItem:self
                                           attribute:NSLayoutAttributeCenterX
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.superview
                                           attribute:NSLayoutAttributeCenterX
                                          multiplier:1
                                            constant:0];
    
    CGFloat margin; // 左右边距
    NSLayoutRelation layoutRelatedBy;
    switch (self.position) {
        case XMFToastPositionTop:
        {
            yLayout = [NSLayoutConstraint constraintWithItem:self
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.superview
                                                   attribute:NSLayoutAttributeTop
                                                  multiplier:1
                                                    constant:[self countNavY]];
            margin = -H_PADDING * 2;
            layoutRelatedBy = NSLayoutRelationEqual;
        }
            break;
        case XMFToastPositionCenter:
            yLayout = [NSLayoutConstraint constraintWithItem:self
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.superview
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1
                                                    constant:0];
            margin = -H_PADDING * 2;
            layoutRelatedBy = NSLayoutRelationLessThanOrEqual;
            break;
        case XMFToastPositionBottom:
            yLayout = [NSLayoutConstraint constraintWithItem:self
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.superview
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1
                                                    constant:-[self countTabY]];
            margin = -H_PADDING * 2;
            layoutRelatedBy = NSLayoutRelationLessThanOrEqual;
            break;
        default:
            break;
    }
    
    wLayout = [NSLayoutConstraint constraintWithItem:self
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:layoutRelatedBy
                                              toItem:self.superview
                                           attribute:NSLayoutAttributeWidth
                                          multiplier:1
                                            constant:margin];
    
    yLayout.priority = UILayoutPriorityDefaultLow;
    [self.superview addConstraints:@[
                                     xLayout,
                                     yLayout,
                                     wLayout
                                     ]];
    
    [self layoutIfNeeded];
    [self xmf_addKeyboardHeightChangeListenWithAutoLayout:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.position == XMFToastPositionCenter || self.position == XMFToastPositionBottom) {
        self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    }
}

- (void)dealloc {
    
    [self xmf_removeKeyboardHeightChangeListen];
}

@end

