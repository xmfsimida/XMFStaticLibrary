//
//  UITextField+Category.h
//  ChatDemo
//
//  Created by xumingfa on 16/4/11.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (XMFCategory)

- (void)xmf_addLeftView : (UIImage *_Nonnull)image;

- (void)xmf_addLeftView : (UIImage *_Nonnull)image
    backgroundColor : (UIColor *_Nonnull)color;

- (void)xmf_addLeftView:(UIImage *_Nonnull)image
    backgroundColor:(UIColor *_Nonnull)color
    rightLineColor : (UIColor *_Nonnull)lineColor
    rightLineWidth : (CGFloat)lineWidth;

- (void)xmf_addLeftView:(UIImage *_Nonnull)image
              imageSize:(CGSize)imageSize
        backgroundColor:(UIColor *_Nonnull)color
        rightLineColor : (UIColor *_Nonnull)lineColor
        rightLineWidth : (CGFloat)lineWidth;

@end
