//
//  XMFTagHeaderView.m
//  XMFTagView
//
//  Created by xumingfa on 16/5/30.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFTagHeaderView.h"
#import "XMFTagButton.h"
#import "UIView+XMFCategory.h"

@interface XMFTagHeaderView ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIButton *moreBN;

@property (nonatomic, strong) NSMutableArray<XMFTagButton *> *buttonAry;

@property (nonatomic, copy) XMFTagHeaderViewAction action;

@end

#define LEFT_PADDING 8.f
#define RIGHT_PADDING LEFT_PADDING

#define TOP_PADDING LEFT_PADDING
#define BOTTOM_PADDIN LEFT_PADDING

#define TAG_NUMBER 101010

@implementation XMFTagHeaderView

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

- (UIColor *)selectedBackgroundColor {
    
    if (_selectedBackgroundColor) return _selectedBackgroundColor;
    return [UIColor redColor];
}

- (UIColor *)moreBackgroundColor {
    
    if (_moreBackgroundColor) return _moreBackgroundColor;
    return [UIColor clearColor];
}

- (UIImage *)moreImage {
    
    if (_moreImage) return _moreImage;
    return [UIImage imageNamed:@"XMFTagViewResource.bundle/Image/right-jiantou@2x.png"];
}

- (instancetype)init {
    
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)setTitleAry:(NSArray<XMFTagHeaderModel *> *)titleAry {
    
    _titleAry = titleAry;
    [self initialize];
    [self layoutIfNeeded];
}

- (UIButton *)moreBN {
    
    if (_moreBN) return _moreBN;
    UIButton *moreBN = [UIButton new];
    [moreBN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreBN setImage:self.moreImage forState:UIControlStateNormal];
    moreBN.backgroundColor = self.moreBackgroundColor;
    [moreBN addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    _moreBN = moreBN;
    [self addSubview: _moreBN];
    return _moreBN;
}

- (void)initialize {
    
    __weak typeof(self) weakSelf = self;
    UIScrollView *scrollView = [UIScrollView new];
    self.buttonAry = [NSMutableArray<XMFTagButton *> arrayWithCapacity:self.titleAry.count];
    [self.titleAry enumerateObjectsUsingBlock:^(XMFTagHeaderModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XMFTagButton *button = [[XMFTagButton alloc] init];
        button.needRadius = !weakSelf.notNeedRadius;
        [button setTag:TAG_NUMBER + idx];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:model.title forState:UIControlStateNormal];
        [button setTitleColor:weakSelf.normalColor forState:UIControlStateNormal];
        [button setTitleColor:weakSelf.hightlightColor forState:UIControlStateHighlighted];
        [button setTitleColor:weakSelf.hightlightColor forState:UIControlStateSelected];
        [button setSelectedBackgroundColor:weakSelf.selectedBackgroundColor];
        [button setNormalBackgroundColor:weakSelf.itembackgroundColor];
        [button setBackgroundColor:weakSelf.itembackgroundColor];
        [button setSelected:model.isSelected];
        [button addTarget:weakSelf action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        [weakSelf.buttonAry addObject:button];
    }];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    _scrollView = scrollView;
    [self addSubview:_scrollView];
}

- (void)pushItemWithAction:(XMFTagHeaderViewAction)action {
    
    _action = action;
}


- (void)clickButton : (XMFTagButton *)button {
    
    [self changeSelectStatusForButtonWithTag:button.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagHeaderView:pushItemWithIndex:)]) {
        [self.delegate tagHeaderView:self pushItemWithIndex:button.tag - TAG_NUMBER];
    }
    if (self.action) {
        self.action(button.tag - TAG_NUMBER);
    }
}

/*!
 改变button选择状态
 */
- (void)changeSelectStatusForButtonWithTag : (NSInteger) tag {
    
    if (self.type == XMFTagHeaderTypeNormal) {
        for (XMFTagButton *btn in self.buttonAry) {
            btn.selected = tag == btn.tag ? YES : NO;
        }
    }else {
        NSInteger currentP = tag - TAG_NUMBER;
        self.titleAry[currentP].selected = !self.titleAry[currentP].isSelected;
        self.buttonAry[currentP].selected = self.titleAry[currentP].isSelected;
    }
    
}

/*!
 点击更多按钮
 */
- (void)moreAction {
    
    const CGFloat SPEED = CGRectGetWidth(self.scrollView.frame) / 2;
    CGFloat lastX = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame);
    if (self.scrollView.contentOffset.x > lastX) return;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + SPEED > lastX ?  lastX : self.scrollView.contentOffset.x + SPEED, self.scrollView.contentOffset.y) animated:YES];
}

/*!
 布局button
 */
- (void)layoutButtonsOutOfBounds : (BOOL) isTrue avgWidth : (CGFloat) avgWidth {
    
    __weak typeof(self) weakSelf = self;
    __block CGFloat preMaxX = 0.0;
    [self.buttonAry enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [button sizeToFit];
        CGRect frame = button.frame;
        frame.size.width = isTrue ? avgWidth : frame.size.width + LEFT_PADDING + RIGHT_PADDING;
        frame.size.height = self.vPadding > CGRectGetHeight(weakSelf.bounds) / 2 ? 0 : weakSelf.vPadding;
        if (self.vPadding >  CGRectGetHeight(weakSelf.bounds) / 2) { // 上下边距
            frame.origin.y = 0;
            frame.size.height = CGRectGetHeight(weakSelf.bounds);
        }
        else {
            frame.origin.y = self.vPadding;
            frame.size.height = CGRectGetHeight(weakSelf.bounds) - weakSelf.vPadding * 2;
        }
        frame.origin.x = preMaxX + weakSelf.hPadding;
        button.frame = frame;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 5;
        if (!self.notNeedRadius) {
            if (button.isSelected) {
                button.xmf_maskCornerRadius = 5;
                button.layer.borderWidth = 0.f;
            }
            else {
                button.layer.borderWidth = 0.5f;
            }
        }
        preMaxX = CGRectGetMaxX(frame);
    }];
    
    CGFloat superWidth = CGRectGetMaxX(self.buttonAry.lastObject.frame);
    CGFloat maxWidth = CGRectGetMaxX(self.buttonAry.lastObject.frame) + self.hPadding;
    if (maxWidth >= superWidth || maxWidth == 0.f) return;   // 总长度少于ios
    CGFloat newWidth = (CGRectGetWidth(self.bounds) - (self.buttonAry.count + 1) * self.hPadding) / self.buttonAry.count;
    [self layoutButtonsOutOfBounds:YES avgWidth:newWidth];
    
}

/*!
 布局
 */
- (void)layoutItems {
    
    __weak typeof(self) weakSelf = self;
    [self layoutButtonsOutOfBounds:NO avgWidth:0.f];
    CGFloat maxWidth = CGRectGetMaxX(self.buttonAry.lastObject.frame) + self.hPadding;
    const CGFloat MORE_WIDTH = 60.f;
    if (maxWidth > CGRectGetWidth(self.bounds)) { // 判断长度是否比父类大
        CGRect svFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - MORE_WIDTH, CGRectGetHeight(self.bounds));
        self.scrollView.frame = svFrame;
        self.moreBN.frame = CGRectMake(CGRectGetMaxX(svFrame), 0, MORE_WIDTH, CGRectGetHeight(self.bounds));
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
    self.scrollView.contentSize = CGSizeMake(maxWidth, CGRectGetHeight(self.scrollView.frame));
}

- (void)layoutSubviews {
    
    [self layoutItems];
    [super layoutSubviews];
}

@end
