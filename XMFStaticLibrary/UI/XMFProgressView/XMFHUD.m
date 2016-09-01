//
//  XMFProgressViewBuilder.m
//  TestDemo
//
//  Created by mr kiki on 16/3/30.
//  Copyright © 2016年 mr kiki. All rights reserved.
//

#import "XMFHUD.h"

#import "XMFNormalHUD.h"
#import "XMFProgressHUD.h"
#import "XMFHUDConst.h"
#import "XMFThreeBallView.h"
#import "UIView+XMFKeyboard.h"

#import <objc/runtime.h>

@implementation XMFHUD

static char XMF_HUD_FLAG;

+ (UIView *)windowView {
    
    return [[UIApplication sharedApplication].delegate window];
}

#pragma mark - hide

+ (void)dismiss {
    
    if (![self windowView]) return;
    [self windowView].userInteractionEnabled = YES;
    UIView *view = objc_getAssociatedObject([self windowView], &XMF_HUD_FLAG);
    if (view) {
        objc_setAssociatedObject([self windowView], &XMF_HUD_FLAG, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha = 0.1;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

+ (void)dimissIsExist {
    
    if (![self windowView]) return;
    [self windowView].userInteractionEnabled = YES;
    UIView *view = objc_getAssociatedObject([self windowView], &XMF_HUD_FLAG);
    if (view) {
        [view removeFromSuperview];
        objc_setAssociatedObject([self windowView], &XMF_HUD_FLAG, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
}

#pragma mark - progress

+ (void)showProgress {
    
    [self dimissIsExist];
    XMFProgressHUD *pbv = [XMFProgressHUD new];
    objc_setAssociatedObject([self windowView], &XMF_HUD_FLAG, pbv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self windowView].userInteractionEnabled = NO;
    [[self windowView] addSubview: pbv];
    [self layoutProgressViewWith: pbv];
}

+ (void)refreshProgressWithTotalLenght:(CGFloat)totalLenght currentLenght:(CGFloat)currentLenght {
    
    XMFProgressHUD *pbv = objc_getAssociatedObject([self windowView], &XMF_HUD_FLAG);
    if (pbv) [pbv refreshViewWithTotalLenght:totalLenght currentLenght:currentLenght];
}

#pragma mark - 三色球
+ (void)showBall {
    
    [self windowView].userInteractionEnabled = NO;
    [self showBallWithContent:[self windowView]];
}

+ (void)showBallWithContent:(__kindof UIView *)contentView {
    
    [self showBallWithContent:contentView style:XMFBallHUDStyleTriangleMovement];
}

+ (void)showBallWithStyle:(XMFBallHUDStyle)style {
    
    [self windowView].userInteractionEnabled = NO;
    [self showBallWithContent:[self windowView] style:style];
}

+ (void)showBallWithContent : (__kindof UIView * _Nullable)contentView style : (XMFBallHUDStyle)style {
    
    [self dimissIsExist];
    XMFThreeBallView *pbv = [XMFThreeBallView new];
    pbv.ballStyle = style;
    if (contentView == nil)
        [[self windowView] addSubview: pbv];
    else
        [contentView addSubview: pbv];
    objc_setAssociatedObject([self windowView], &XMF_HUD_FLAG, pbv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self layoutBallViewWith: pbv];
    [pbv play];
}

#pragma mark - 普通类型

+ (void)show {
    
    [self showWithTitle:nil];
}

+ (void)showWithTitle:(NSString *)title {
    
    [self dimissIsExist];
    XMFNormalHUD *pbv = [XMFNormalHUD new];
    [self windowView].userInteractionEnabled = NO;
    pbv.titleLB.text = title;
    [[self windowView] addSubview: pbv];
    objc_setAssociatedObject([self windowView], &XMF_HUD_FLAG, pbv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self layoutNormalViewWith: pbv];
}

+ (void)layoutBallViewWith : (UIView *)view {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:view.superview
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0];
    centerYConstraint.priority = UILayoutPriorityDefaultLow;
    [view.superview addConstraints: @[
                                      [NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view.superview
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1
                                                                    constant:0]
                                      ,centerYConstraint]];
    [view addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1
                                                         constant:BALL_CENTER_WIDTH]
                           ,[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:BALL_CENTER_HEIGHT]]];
    [view xmf_addKeyboardHeightChangeListenWithAutoLayout:YES];
}

+ (void)layoutNormalViewWith : (UIView *)view {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:view.superview
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0];
    centerYConstraint.priority = UILayoutPriorityDefaultLow;
    [view.superview addConstraints: @[[NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view.superview
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1
                                                                    constant:0]
                                      ,centerYConstraint]];
}

+ (void)layoutProgressViewWith : (UIView *)view {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:view.superview
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0];
    [view.superview addConstraints: @[[NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view.superview
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1
                                                                    constant:0]
                                      ,centerYConstraint]];
    
    [view addConstraints:
     @[
       [NSLayoutConstraint constraintWithItem:view
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                    attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:1
                                     constant:PROGRESS_CENTER_WIDTH]
       ,[NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                      constant:PROGRESS_CENTER_HEIGHT]
       ]];
}


@end
