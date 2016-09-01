//
//  UITextField+Category.m
//  ChatDemo
//
//  Created by xumingfa on 16/4/11.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "UITextField+XMFCategory.h"
#import "UIView+XMFCategory.h"

@implementation UITextField (XMFCategory)

- (void)xmf_addLeftView:(UIImage *)image {
    
    [self xmf_addLeftView:image backgroundColor:[UIColor clearColor]];
}

- (void)xmf_addLeftView:(UIImage *)image backgroundColor:(UIColor *)color{
    
    [self xmf_addLeftView:image backgroundColor:color rightLineColor:[UIColor clearColor] rightLineWidth:0];
}

- (void)xmf_addLeftView:(UIImage *)image backgroundColor:(UIColor *)color rightLineColor:(UIColor *)lineColor rightLineWidth:(CGFloat)lineWidth {
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, CGRectGetHeight(self.frame) - 1 + 10, CGRectGetHeight(self.frame) - 2)];
    leftView.backgroundColor = color;
    UIImageView *userLeftView = [UIImageView new];
    userLeftView.contentMode = UIViewContentModeScaleAspectFill;
    userLeftView.frame = CGRectMake(5, 5, CGRectGetHeight(leftView.frame) - 10 , CGRectGetHeight(leftView.frame) - 10 );
    userLeftView.image = image;
    [leftView addSubview: userLeftView];
    
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = lineColor;
    rightLine.frame = CGRectMake(CGRectGetMaxX(userLeftView.frame) + 5 , 6, lineWidth, CGRectGetHeight(leftView.frame) - 6 * 2);
    [leftView addSubview: rightLine];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftView;
}

- (void)xmf_addLeftView:(UIImage *)image imageSize:(CGSize)imageSize backgroundColor:(UIColor *)color rightLineColor:(UIColor *)lineColor rightLineWidth:(CGFloat)lineWidth {
    
    const CGFloat TOP_PADDING = 6.f;
    const CGFloat PADDING = 16.f;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, imageSize.width - lineWidth + PADDING * 3 / 2, CGRectGetHeight(self.frame) - 2)];
    leftView.backgroundColor = color;
    
    UIImageView *userLeftView = [UIImageView new];
    userLeftView.contentMode = UIViewContentModeScaleToFill;
    CGFloat imageHeight = imageSize.height > CGRectGetHeight(self.frame) ? CGRectGetHeight(self.frame) : imageSize.height;
    userLeftView.frame = CGRectMake(PADDING / 2,(CGRectGetHeight(leftView.frame) - imageHeight) / 2, imageSize.width , imageHeight);
    userLeftView.image = image;
    [leftView addSubview: userLeftView];
    
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = lineColor;
    rightLine.frame = CGRectMake(CGRectGetMaxX(leftView.frame) - PADDING / 2 - lineWidth / 2 , TOP_PADDING, lineWidth, CGRectGetHeight(leftView.frame) - TOP_PADDING * 2);
    [leftView addSubview: rightLine];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftView;
}

@end
