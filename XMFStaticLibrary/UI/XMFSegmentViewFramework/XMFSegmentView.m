//
//  XMFSegmentView.m
//  XMFSegment
//
//  Created by xumingfa on 16/7/3.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFSegmentView.h"
#import "UIScrollView+XMFSegment.h"

@interface XMFSegmentView ()

@property (nonatomic, strong) NSMutableArray<NSValue *> *frameAry;

@property (nonatomic, assign) NSUInteger defaultIndex; //  设置默认位置

@property (nonatomic, weak) CALayer *highlightLayer;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, copy) XMFSegmentViewBlock handlerBlock;

@property (atomic, assign, getter=isMoveLock) BOOL moveLock;

@end

#define LINE_HEIGHT 2.f

#define PADDING 10.f

#define SEGMENT_TAG 10020

#define TITLE_FONT_SIZE 15

@implementation XMFSegmentView

+ (instancetype)createColumViewWithDefaultIndex:(NSUInteger)index {
    XMFSegmentView *segmentView = [XMFSegmentView new];
    [segmentView setDefaultIndex: index];
    return segmentView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
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

- (void)initUI {
    
    self.userInteractionEnabled = YES;
    [self addSubview: self.scrollView];
}

- (UIScrollView *)scrollView {
    
    if (_scrollView) return _scrollView;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView xmf_touchesEndedWithHandler:^(NSSet<UITouch *> *touches, UIEvent *event) {
        UITouch *touch = [touches anyObject];
        CGPoint point  = [touch locationInView: scrollView];
        NSInteger index = [self getCurrentIndexWithCurrentX: point.x];
        [self pushItemWithIndex:index];
    }];
    _scrollView = scrollView;
    return _scrollView;
}


- (NSMutableArray<NSValue *> *)frameAry {
    
    if (_frameAry) return _frameAry;
    _frameAry = [NSMutableArray array];
    return _frameAry;
}

- (NSArray<NSString *> *)titleAry {
    
    if (_titleAry) return _titleAry;
    _titleAry = [NSArray array];
    return _titleAry;
}

- (UIColor *)instructionsColor {
    
    if (_instructionsColor) return _instructionsColor;
    _instructionsColor = [UIColor redColor];
    return _instructionsColor;
}

- (UIColor *)fontNormalColor {
    
    if (_fontNormalColor) return _fontNormalColor;
    _fontNormalColor = [UIColor blackColor];
    return _fontNormalColor;
}

- (UIColor *)fontSelectedColor {
    
    if (_fontSelectedColor) return _fontSelectedColor;
    _fontSelectedColor = [UIColor redColor];
    return _fontSelectedColor;
}

- (void)reloadData {
    
    if (self.scrollView ) [self.scrollView removeFromSuperview];
    [self initUI];
    [self bulidView];
}

#pragma mark 设置默认item
- (void)setDefaultIndex:(NSUInteger)defaultIndex {
    _defaultIndex = defaultIndex;
}

#pragma mark - item初始化
- (void)bulidView {
    
    NSUInteger count = self.titleAry.count;
    for (int i = 0; i < count; i ++) {[self.scrollView addSubview: [self createTiltleWithIndex:i]];}
    
    [self layoutIfNeeded];
    [self initInstructions];
    [self layoutInstructions];
}

#pragma mark 创建高亮背景
- (void)initInstructions {
    
    CALayer *highlightLayer = [CALayer layer];
    UIColor *highlightColor = self.instructionsColor;
    highlightLayer.backgroundColor = highlightColor.CGColor;
    _highlightLayer = highlightLayer;
    [self.scrollView.layer addSublayer: _highlightLayer];
}

/*!
 初始化指示器frame
 */
- (void)layoutInstructions {
    
    CGRect initFrame = [self.frameAry[self.defaultIndex] CGRectValue];
    CGRect bounds = self.highlightLayer.frame;
    if (self.highlightLayer && self.style == XMFSegmentViewStyleLine) {
        bounds.origin =  CGPointMake(CGRectGetMinX(initFrame), CGRectGetHeight(initFrame) - LINE_HEIGHT);
        bounds.size = CGSizeMake(CGRectGetWidth(initFrame), LINE_HEIGHT);
    }
    else {
        bounds = initFrame;
    }
    self.highlightLayer.frame = bounds;
}

#pragma mark 创建标题
- (UILabel *)createTiltleWithIndex : (NSUInteger)index{
    
    UIColor *fontColor = self.fontNormalColor;
    UIColor *selectedColor = self.fontSelectedColor;
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = SEGMENT_TAG + index;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titleAry[index];
    titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    titleLabel.textColor = fontColor;
    titleLabel.highlightedTextColor = selectedColor;
    titleLabel.highlighted = self.defaultIndex == index ? YES : NO;
    titleLabel.userInteractionEnabled = YES;
    return titleLabel;
}

#pragma mark - item点击事件
- (void)pushItemWithIndex : (NSInteger)index {
    
    [self changeLabelStutasWithIndex: index];
    [self moveToHighlightWithCurrentIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didSelectItemsAtIndex:)]) {
        [self.delegate segmentView:self didSelectItemsAtIndex:index];
    }
    if (self.handlerBlock) self.handlerBlock(index);
}

- (void)didSelectWithHandler:(XMFSegmentViewBlock)handler {
    
    _handlerBlock = handler;
}

/*!
 通过frame获取当前位置
 */
- (NSUInteger)getCurrentIndexWithCurrentX : (CGFloat)currentX {
    
    for (int i = 0; i < self.frameAry.count - 1; i++) {
        NSValue *value = self.frameAry[i];
        CGRect frame = [value CGRectValue];
        if (CGRectGetMaxX(frame) > currentX) return i;
    }
    return self.frameAry.count - 1;
}


/*!
 需改label状态
 */
- (void)changeLabelStutasWithIndex : (NSUInteger) index {
    
    //  取消之前状态
    ((UILabel *)[self viewWithTag:SEGMENT_TAG + self.self.defaultIndex]).highlighted = NO;
    //  更新当前状态
    ((UILabel *)[self viewWithTag:SEGMENT_TAG + index]).highlighted = YES;
    self.defaultIndex = index;
}

#pragma mark - 高亮

- (void)moveToHighlightWithPX : (CGFloat) px {
    
    if (self.isMoveLock) return;
    
    CGFloat newPX = [self savaOneSmallNum:px];
    if (newPX > 1 || newPX < 0) return;
    
    NSUInteger currentIndex = [self getCurrentIndexWithPX:newPX];
    const CGFloat currentX = (self.scrollView.contentSize.width - CGRectGetWidth([self.frameAry[self.defaultIndex] CGRectValue])) * newPX;
    
    CGRect frame = _highlightLayer.frame;
    if (self.style == XMFSegmentViewStyleLine) {
        frame.origin.y = CGRectGetHeight(self.frame) - LINE_HEIGHT;
        frame.size.height = LINE_HEIGHT;
    }
    if (self.defaultIndex != currentIndex) {
        
        CGRect currentFrame = [self.frameAry[currentIndex] CGRectValue];
        frame.size.width = CGRectGetWidth(currentFrame);
        [self changeLabelStutasWithIndex: currentIndex];
    }
    frame.origin.x = currentX;
    _highlightLayer.frame = frame;
    
    const CGFloat moveX = [self countMoveXWithItemFrame: [self.frameAry[currentIndex] CGRectValue]];
    [self.scrollView setContentOffset: CGPointMake(moveX, self.scrollView.contentOffset.y) animated:YES];
}

/*!
 获得当前位置
 */
- (NSUInteger)getCurrentIndexWithPX : (CGFloat)px {
    
    //  item的数量
    NSUInteger count = self.frameAry.count;
    NSUInteger currentIndex = 0;
    if (px == 0) {
        currentIndex = 0;
    }
    else {
        currentIndex =  ceilf(px / (1.0 / count)) - 1  >= count ? count - 1 : ceilf(px / (1.0 / count)) - 1;
    }
    return currentIndex;
}

/*！
 小数位数
 */
- (CGFloat)savaOneSmallNum : (CGFloat)num{
    
//    NSString *numStr = [NSString stringWithFormat:@"%f", 1.0 / self.frameAry.count];
//    int decimalNum = 0; //保留的小数位数
//    for (int i = 0; i < numStr.length; i++) {
//        char ch = [numStr characterAtIndex:i];
//        if (ch == '.') {
//            decimalNum = 0;
//            continue;
//        }
//        decimalNum ++;
//        if (ch != '0') {
//            break;
//        }
//    }
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:2];
    return [[nFormat stringFromNumber:@(num)] floatValue];
}

- (void)moveToHighlightWithCurrentIndex : (NSUInteger)currentIndex {
    
    __weak typeof(self) weakSelf = self;
    CGRect currentFrame = [self.frameAry[currentIndex] CGRectValue];
    CGRect frame = _highlightLayer.frame;
    frame.origin.x = CGRectGetMinX(currentFrame);
    if (weakSelf.style == XMFSegmentViewStyleLine) {
        frame.origin.y = CGRectGetHeight(currentFrame) - LINE_HEIGHT;
        frame.size = CGSizeMake(CGRectGetWidth(currentFrame), LINE_HEIGHT);
    }
    self.moveLock = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _highlightLayer.frame = frame;
    }  completion:^(BOOL finished) {
        weakSelf.moveLock = NO;
    }];
    const CGFloat moveX = [self countMoveXWithItemFrame: [self.frameAry[currentIndex] CGRectValue]];
    [self.scrollView setContentOffset: CGPointMake(moveX, self.scrollView.contentOffset.y) animated:YES];
}

#pragma mark - item移动算法
- (CGFloat)countMoveXWithItemFrame : (CGRect) frame {
    
    const CGFloat x = CGRectGetMinX(frame);
    const CGFloat width = CGRectGetWidth(frame);
    const CGFloat currtWith = CGRectGetWidth(self.frame);
    CGFloat moveX = x - (currtWith - width) / 2;
    if (moveX < 0.f) {
        moveX = 0.f;
    }
    else if (moveX > self.scrollView.contentSize.width - self.scrollView.bounds.size.width){
        moveX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    }
    return moveX;
}

/*!
 计算字符串的长度
 */
- (float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeToFit.width;
}

- (CGFloat)getTitleMaxWidth {
    NSString *maxString = nil;
    for (NSString *title in self.titleAry) {
        if (maxString == nil) {
            maxString = title;
        }
        else {
            if (maxString.length < title.length)
                maxString = title;
        }
    }
    return [self widthForString:maxString fontSize:TITLE_FONT_SIZE andHeight: CGRectGetHeight(self.bounds)];
}

#pragma mark item布局
- (void)layoutItems : (CGFloat)padding maxWidth : (CGFloat)maxWidth {
    
    self.scrollView.frame = self.bounds;
    
    const CGFloat WIDTH = self.bounds.size.width;
    _frameAry = [NSMutableArray arrayWithCapacity: self.titleAry.count];
    if (self.titleAry.count == 0) return;
    
    CGFloat temp = 0;
    for (int i = 0; i < self.titleAry.count; i++) {
        UILabel *label = [self viewWithTag:SEGMENT_TAG + i];
        const CGFloat x = i == 0 ? 0 : CGRectGetMaxX([self.frameAry[i - 1] CGRectValue]);
        CGRect lbFrame = CGRectMake(x, 0, maxWidth + padding * 2, CGRectGetHeight(self.frame));
        [_frameAry insertObject:[NSValue valueWithCGRect:lbFrame] atIndex:i];
        label.frame = lbFrame;
        if (i == self.titleAry.count - 1) {
            if (WIDTH - CGRectGetMaxX(label.frame) > 0) { // 是否少于scrollview 的宽度
                CGFloat offset = (WIDTH - CGRectGetMaxX(label.frame)) / self.titleAry.count / 2;
                [self layoutItems: PADDING + offset maxWidth:maxWidth];
                return;
            }
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(label.frame), self.scrollView.contentSize.height);
        }
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self layoutItems: PADDING maxWidth:  [self getTitleMaxWidth]];
}


@end
