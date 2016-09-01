//
//  XMFProgressNormalView.m
//  ChatDemo
//
//  Created by xumingfa on 16/4/17.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFNormalHUD.h"
#import "XMFHUDConst.h"
#import "UIView+XMFKeyboard.h"

#define KEY_PATH_FOR_TITLE @"text"

#define PADDING_MIN 16.f

@interface XMFNormalHUD ()

@property (nonatomic, strong) NSLayoutConstraint *marginConstraint;

@end

@implementation XMFNormalHUD


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3;
        [self bulidView];
        [self bulidLayout];
    }
    return self;
}

- (void) bulidView {
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView startAnimating];
    _activityView = activityView;
    [self addSubview: _activityView];
    
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = [UIColor whiteColor];
    titleLB.numberOfLines = 0;
    _titleLB = titleLB;
    [self addSubview: _titleLB];
    
    [_titleLB addObserver:self forKeyPath:KEY_PATH_FOR_TITLE options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:KEY_PATH_FOR_TITLE]) {
        NSString *str = change[@"new"];
        if ([str isEqual: [NSNull null]]) {
            [self changeMarginConstraintWithSize: 0];
        }
        else {
            
            if ([str isEqualToString:@""]) {
                [self changeMarginConstraintWithSize: 0];
            }
            else {
                [self changeMarginConstraintWithSize:PADDING_MIN];
            }
            
        }
    }
}

- (void)changeMarginConstraintWithSize : (CGFloat) size {
    
    
    if ([self.constraints indexOfObject:self.marginConstraint] != NSNotFound) {
        [self removeConstraint:self.marginConstraint];
    }
    self.marginConstraint = [NSLayoutConstraint constraintWithItem:self.titleLB
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.activityView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:size];
    [self addConstraint: self.marginConstraint];
}

- (void)bulidLayout {
    
    const CGFloat ACTIVITY_SIZE = 50.f;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLB.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLB.preferredMaxLayoutWidth = CENTER_WIDTH - PADDING_MIN * 2;
    
    [self addConstraints: @[[NSLayoutConstraint constraintWithItem:self.activityView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:PADDING_MIN]
                            ,[NSLayoutConstraint constraintWithItem:self.activityView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]
                            ]];
    
    [self.activityView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.activityView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:ACTIVITY_SIZE]
                                        ,[NSLayoutConstraint constraintWithItem:self.activityView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:ACTIVITY_SIZE]]];
    
    [self.titleLB addConstraints:@[[NSLayoutConstraint constraintWithItem:self.titleLB
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1
                                                                 constant:0],
                                   [NSLayoutConstraint constraintWithItem:self.titleLB
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1
                                                                 constant:ACTIVITY_SIZE + 2 * PADDING_MIN]]];
    
    [self addConstraints: @[[NSLayoutConstraint constraintWithItem:self.titleLB
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:PADDING_MIN]
                            ,[NSLayoutConstraint constraintWithItem:self.titleLB
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-PADDING_MIN]
                            ,[NSLayoutConstraint constraintWithItem:self.titleLB
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-PADDING_MIN]]];
}

- (void)dealloc {
    
    [self xmf_removeKeyboardHeightChangeListen];
}

@end
