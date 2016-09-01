//
//  XMFToastView.h
//  XMFToastView
//
//  Created by xumingfa on 16/6/8.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFToastViewParams.h"

@interface XMFToastView : UIView

/*!
 建立toast
 view 需要加入到的父组件
 content 内容
 duration 时间延迟消息 （默认0.2)
 */
+ (void)showToastViewToView : (__kindof UIView * _Nullable)view
                    content : (NSString * _Nullable)content
                   duration : (CGFloat)duration;


/*!
 建立toast
 view 需要加入到的父组件
 content 内容
 position 位置
 duration 时间延迟消息 （默认0.2)
 */
+ (void)showToastViewToView : (__kindof UIView * _Nullable)view
                    content : (NSString * _Nullable)content
                   position : (XMFToastPosition)position
                   duration : (CGFloat)duration;


@end
