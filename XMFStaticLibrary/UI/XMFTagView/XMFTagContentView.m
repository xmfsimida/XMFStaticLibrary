//
//  XMFTagContentView.m
//  XMFTagView
//
//  Created by xumingfa on 16/5/30.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFTagContentView.h"
#import "UIView+XMFCategory.h"
#import "XMFTagButton.h"
#import "XMFTagBase.h"
#import "XMFTagContentModel.h"

@interface XMFTagContentView ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<XMFTagButton *> *buttonAry;

@property (nonatomic, copy) XMFTagContentViewAction action;

@property (nonatomic, weak) UIButton *moreBN;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *,  NSMutableArray<XMFTagButton *> *> *cacheButtons;

@property (nonatomic, weak) UIActivityIndicatorView *activityView;

@end

#define LEFT_PADDING 8.f
#define RIGHT_PADDING LEFT_PADDING

#define TOP_PADDING 4.f
#define BOTTOM_PADDIN TOP_PADDING

#define TAG_NUMBER 202020

@implementation XMFTagContentView

- (UIColor *)hightlightColor {
    
    if (_hightlightColor) return _hightlightColor;
    return [UIColor whiteColor];
}

- (UIColor *)normalColor {
    
    if (_normalColor) return _normalColor;
    return [UIColor grayColor];
}

- (UIColor *)itembackgroundColor {
    
    if (_itembackgroundColor) return _itembackgroundColor;
    return [UIColor whiteColor];
}

- (UIColor *)moreBackgroundColor {
    
    if (_moreBackgroundColor) return _moreBackgroundColor;
    return [UIColor whiteColor];
}

- (UIImage *)moreImage {
    
    if (_moreImage) return _moreImage;
    return [UIImage imageNamed:@"XMFTagViewResource.bundle/Image/bottom-jiantou@2x.png"];
}

- (UIButton *)moreBN {
    
    if (_moreBN) return _moreBN;
    UIButton *moreBN = [UIButton new];
    [moreBN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreBN setImage:self.moreImage forState:UIControlStateNormal];
    [moreBN setBackgroundColor:self.moreBackgroundColor];
    [moreBN addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    _moreBN = moreBN;
    [self addSubview: _moreBN];
    return _moreBN;
}

- (UIActivityIndicatorView *)activityView {
    
    if (_activityView) return _activityView;
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView = activityView;
    [self addSubview: _activityView];
    return _activityView;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initBase];
    }
    return self;
}

- (void)memoryWarning:(NSNotification*)note {
    [self.cacheButtons removeAllObjects];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initBase];
    }
    return self;
}

- (void) initBase {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    _cacheButtons = [NSMutableDictionary<NSNumber *,  NSMutableArray<XMFTagButton *> *> dictionary];
    [self addLayoutForActivityView];
}

- (void)addLayoutForActivityView {
    
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *layoutCenterX = [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *layoutCenterY = [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *layoutWidth = [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50.f];
    NSLayoutConstraint *layoutHeight = [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50.f];
    [self.activityView addConstraints:@[layoutWidth, layoutHeight]];
    [self addConstraints:@[layoutCenterX, layoutCenterY]];
}

- (void)pushItemWithAction:(XMFTagContentViewAction)action {
    
    _action = action;
}

- (void)setContentAry:(NSArray<XMFTagContentModel *> *)contentAry {
    
    if (self.buttonAry && self.buttonAry.count > 0 && self.contentAry && self.contentAry.count > 0) { // 缓存UI数据
        [self.cacheButtons setObject:self.buttonAry forKey:@(self.contentAry.lastObject.groudId)];
    }
    _contentAry = contentAry;
    [self.activityView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initialize];
        [self.activityView stopAnimating];
    });
    
}

- (void)initialize {
    
    if (self.scrollView)[self.scrollView removeFromSuperview];
    _moreBN = nil;
    
    NSMutableArray<XMFTagButton *> *buttons = self.cacheButtons[@(self.contentAry.lastObject.groudId)];
    if (self.cacheButtons.count > 0 && buttons) { // 从缓存在初始化UI
        [self initializeForCache: buttons];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    UIScrollView *scrollView = [UIScrollView new];
    self.buttonAry = [NSMutableArray<XMFTagButton *> arrayWithCapacity:self.contentAry.count];
    [self.contentAry enumerateObjectsUsingBlock:^(XMFTagContentModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XMFTagButton *button = [[XMFTagButton alloc] init];
        button.needRadius = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTag:TAG_NUMBER + idx];
        [button setTitle:model.content forState:UIControlStateNormal];
        [button setTitleColor:weakSelf.normalColor forState:UIControlStateNormal];
        [button setTitleColor:weakSelf.hightlightColor forState:UIControlStateHighlighted];
        [button setTitleColor:weakSelf.hightlightColor forState:UIControlStateSelected];
        [button setBackgroundColor:weakSelf.itembackgroundColor];
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 5;
        [button setSelected:model.isSelected];
        if (button.isSelected) {
            button.xmf_maskCornerRadius = 5;
            button.layer.borderWidth = 0.f;
        }
        else {
            button.layer.borderWidth = 0.5f;
        }
        [button addTarget:weakSelf action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [button xmf_addChangeScaleWithDuration:0.3 fromValue:0 toValue:1 autoreverses:NO];
        [scrollView addSubview:button];
        [weakSelf.buttonAry addObject:button];
        
    }];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    _scrollView = scrollView;
    [self addSubview:_scrollView];
}

- (void)initializeForCache : ( NSMutableArray<XMFTagButton *> *)buttons {
    
    self.buttonAry = buttons;
    UIScrollView *scrollView = [UIScrollView new];
    for (XMFTagButton *btn in buttons) {
        [scrollView addSubview: btn];
    }
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    _scrollView = scrollView;
    [self addSubview:_scrollView];
}

- (void)clearCache {
    
    if (self.cacheButtons) {
        [self.cacheButtons removeAllObjects];
    }
}

- (void)clickButton : (XMFTagButton *)button {
    
    [self changeSelectStatusForButtonWithTag:button.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagContentView:pushItemWithTag:)]) {
        [self.delegate tagContentView:self pushItemWithTag:button.tag - TAG_NUMBER];
    }
    if (self.action) {
        self.action(button.tag - TAG_NUMBER);
    }
}

/*!
 点击更多按钮
 */
- (void)moreAction {
    
    const CGFloat SPEED = CGRectGetHeight(self.scrollView.frame) - self.vPadding;
    CGFloat lastY = self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.frame);
    if (self.scrollView.contentOffset.y > lastY) return;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + SPEED > lastY ?  lastY : self.scrollView.contentOffset.y + SPEED) animated:YES];
}


/*!
 改变button选择状态
 */
- (void)changeSelectStatusForButtonWithTag : (NSInteger) tag {
    
    if (self.isRadioMode) {
        NSInteger currentP = tag - TAG_NUMBER;
        if (self.contentAry[currentP].isSelected) return;
        for (int i = 0; i < self.contentAry.count; i++) {
            XMFTagContentModel *tagModel = self.contentAry[i];
            UIButton *button = self.buttonAry[i];
            tagModel.selected = NO;
            button.selected = NO;
        }
        self.contentAry[currentP].selected = YES;
        self.buttonAry[currentP].selected = YES;
    }
    else {
        NSInteger currentP = tag - TAG_NUMBER;
        self.contentAry[currentP].selected = !self.contentAry[currentP].isSelected;
        self.buttonAry[currentP].selected = self.contentAry[currentP].isSelected;
    }
}

/*!
 布局button
 */
- (void)layoutButtons {
    
    __block CGPoint prePoint = CGPointMake(self.hPadding, self.vPadding);
    __weak typeof(self) weakSelf = self;
    [self.buttonAry enumerateObjectsUsingBlock:^(XMFTagButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [button sizeToFit];
        CGFloat maxWidth = CGRectGetWidth(weakSelf.bounds);
        CGFloat width = CGRectGetWidth(button.frame) + LEFT_PADDING + RIGHT_PADDING;
        CGFloat height = CGRectGetHeight(button.frame) - TOP_PADDING - BOTTOM_PADDIN;
        CGFloat x;
        CGFloat y;
        
        CGFloat preX;
        CGFloat preY = prePoint.y;
        if (prePoint.x + width + weakSelf.hPadding > maxWidth) {
            x = weakSelf.hPadding;
            y = prePoint.y + height + weakSelf.vPadding;
            preY = preY + height + weakSelf.vPadding;
            preX = x + width + weakSelf.hPadding;
        }
        else {
            x = prePoint.x;
            y = prePoint.y;
            preX = prePoint.x + width + weakSelf.hPadding;
        }
        button.frame = CGRectMake(x, y, width, height);
        button.xmf_maskCornerRadius = 5;
        button.selected = button.isSelected; // 第一次加载配置样式
        prePoint = CGPointMake(preX, preY);
    }];
}


/*!
 布局
 */
- (void)layoutItems {
    
    __weak typeof(self) weakSelf = self;
    
    [self layoutButtons];
    const CGFloat MORE_BUTTON_HEIGHT = 30.f;
    CGFloat maxHeight = CGRectGetMaxY(self.buttonAry.lastObject.frame) + self.vPadding;
    if (maxHeight > CGRectGetHeight(self.bounds)) {
        CGRect svFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - MORE_BUTTON_HEIGHT);
        self.scrollView.frame = svFrame;
        weakSelf.moreBN.alpha = 0.1;
        weakSelf.moreBN.frame = CGRectMake(0, CGRectGetMaxY(svFrame), CGRectGetWidth(weakSelf.bounds), MORE_BUTTON_HEIGHT);
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.moreBN.alpha = 1;
        }];
    }
    else {
        self.scrollView.frame = self.bounds;
        if (_moreBN) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.moreBN.transform = CGAffineTransformMakeScale(0.1, 0.1);
            } completion:^(BOOL finished) {
                if (finished) {
                    [weakSelf.moreBN removeFromSuperview];
                }
            }];
        };
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.buttonAry.lastObject.frame) + self.vPadding);
}

- (void)layoutSubviews {
    
    [self layoutItems];
    [super layoutSubviews];
}

@end
