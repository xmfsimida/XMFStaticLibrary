//
//  XMFBaseBadge.m
//  XMFBadgeView
//
//  Created by xumingfa on 16/6/2.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFBaseBadge.h"

@interface XMFBaseBadge ()

@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) NSLayoutConstraint *centerXConstraint;
@property (nonatomic, weak) NSLayoutConstraint *centerYConstraint;

@end

@implementation XMFBaseBadge

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 20, 20)];
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

- (void)initialize {
       
    [self addLayoutForNewSubView: [self loadSubView]];

}

- (UIView *)loadSubView {
    return nil;
}

- (void)addLayoutForNewSubView : (__kindof UIView * __nonnull) newView {
 
    if (!newView) return;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    newView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: newView];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                           ,[NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]
                           ]];
    
}

- (void)setStyle:(XMFBadgePositionStyle)style {
    
    _style = style;
    [self layoutItems];
}

- (void)layoutItems {
    
    if (!self.superview) return;
    
    if (self.widthConstraint) [self removeConstraint:self.widthConstraint];
    if (self.heightConstraint) [self removeConstraint:self.heightConstraint];
    if (self.centerXConstraint) [self.superview removeConstraint:self.centerXConstraint];
    if (self.centerYConstraint) [self.superview removeConstraint: self.centerYConstraint];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX = nil;
    NSLayoutConstraint *centerY = nil;
    switch (self.style) {
        case XMFBadgePositionStyleTopLeft:
            
            centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            break;
        case XMFBadgePositionStyleTopRight:
            centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            break;
        case XMFBadgePositionStyleBottomLeft:
            centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            break;
        case XMFBadgePositionStyleBottomRight:
            centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            break;
        case XMFBadgePositionStyleCenter:
            centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            break;
        default:
            break;
    }
    _centerXConstraint = centerX;
    _centerYConstraint = centerY;
    [self.superview addConstraints:@[
                                     self.centerYConstraint
                                     ,self.centerXConstraint
                                     ]];
    
    NSLayoutConstraint *height = nil;
    NSLayoutConstraint *width = nil;
    height = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight(self.frame)];
    width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetWidth(self.frame)];
    _widthConstraint = width;
    _heightConstraint = height;
    [self addConstraints:@[
                           self.widthConstraint,
                           self.heightConstraint
                           ]];
}

@end
