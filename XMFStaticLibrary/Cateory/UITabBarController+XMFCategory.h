//
//  UITabBarController+XMFCategory.h
//  ChatDemo
//
//  Created by xumingfa on 16/4/14.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (XMFCategory)

/*!
 设置文字大小
 */
- (void)xmf_setTitleFontSize : (CGFloat) size;

/*!
 设置图片去掉蓝色
 */
- (void)xmf_setItemSelectedImage : (UIImage * __nullable)image
          selectedTitleColor : (UIColor *__nullable)color
                   itemIndex : (NSUInteger)index ;

@end
