//
//  XMFTextView.m
//  Tfunchat
//
//  Created by mr kiki on 16/3/21.
//  Copyright © 2016年 外语高手. All rights reserved.
//

#import "XMFTextView.h"

#define PADDING 6.f

#define KEY_PATH @"contentOffset"

@interface XMFTextView () <UITextViewDelegate>

@property (nonatomic, weak) UILabel *placeholderLB;

@property (nonatomic, weak) UILabel *wordLimitLB;

@property (nonatomic, weak) UITextView *textView;

@end

@implementation XMFTextView

- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 200, 200)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self bulidView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self bulidView];
    }
    return self;
}


- (void)bulidView {
    
    UITextView *textView = [[UITextView alloc] init];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    _textView = textView;
    [self addSubview:textView];
    
    UILabel *placeholderLB = [UILabel new];
    placeholderLB.textColor = [UIColor grayColor];
    placeholderLB.font = [UIFont systemFontOfSize:15];
    _placeholderLB = placeholderLB;
    [self addSubview: _placeholderLB];
    
    UILabel *wordLimitLB = [UILabel new];
    wordLimitLB.textColor = placeholderLB.textColor;
    wordLimitLB.font = [UIFont systemFontOfSize:15];
    _wordLimitLB = wordLimitLB;
    [self addSubview: _wordLimitLB];
    
    [self resizeWordLimit];
}

- (void)setNeedPlaceholder:(BOOL)needPlaceholder {
    _needPlaceholder = needPlaceholder;
    self.placeholderLB.hidden = !_needPlaceholder;
}

- (void)setNeedwordLimit:(BOOL)needwordLimit {
    _needwordLimit = needwordLimit;
    self.wordLimitLB.hidden = !_needwordLimit;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLB.text = placeholder;
}

- (void)setMaxWordLenght : (NSUInteger)maxWordLenght {
    _maxWordLenght = maxWordLenght;
    self.wordLimitLB.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)self.textView.text.length, (unsigned long)self.maxWordLenght];
}

- (void)setPlaceholerColor:(UIColor *)placeholerColor {
    _placeholerColor = placeholerColor;
    self.placeholderLB.textColor = placeholerColor;
}

- (void)setWordLimitColor:(UIColor *)wordLimitColor {
    _wordLimitColor = wordLimitColor;
    self.wordLimitLB.textColor = wordLimitColor;
}

- (void)layoutSubviews {
    
    const CGFloat PH_X = PADDING;
    const CGFloat PH_Y = PADDING;
    const CGSize PH_SIZE = [_placeholderLB sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    const CGFloat PH_W = PH_SIZE.width;
    const CGFloat PH_H = PH_SIZE.height                                                                                                                   ;
    self.placeholderLB.frame = CGRectMake(PH_X, PH_Y, PH_W, PH_H);
    
    CGRect frame = self.bounds;
    frame.size.height = self.bounds.size.height - self.wordLimitLB.font.pointSize;
    self.textView.frame = frame;
    
    [self resizeWordLimit];
    
    [super layoutSubviews];
}

- (void)resizeWordLimit {
    const CGSize WL_SIZE = [_wordLimitLB sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    const CGFloat WL_W = WL_SIZE.width;
    const CGFloat WL_H = WL_SIZE.height;
    const CGFloat WL_X = CGRectGetWidth(self.frame) - WL_W - PADDING;
    const CGFloat WL_Y = CGRectGetHeight(self.frame) - WL_H;
    _wordLimitLB.frame = CGRectMake(WL_X, WL_Y, WL_W, WL_H);

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@""]) {return YES;}
    if(textView.text.length >= self.maxWordLenght) return NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(XMFTextView:shouldChangeTextInRange:replacementText:)]) {
        [self.delegate XMFTextView:self shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.wordLimitLB.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)textView.text.length, (unsigned long)self.maxWordLenght];
    [self resizeWordLimit];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.wordLimitLB.font = font;
    self.placeholderLB.font = font;
    self.textView.font = font;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    self.textView.returnKeyType = returnKeyType;
}

- (UIReturnKeyType)returnKeyType {
    return self.textView.returnKeyType;
}

- (void)setTextColor:(UIColor *)textColor {
    self.textView.textColor = textColor;
}

- (UIColor *)textColor {
    return self.textView.textColor;
}

- (BOOL)resignFirstResponder {
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

@end
