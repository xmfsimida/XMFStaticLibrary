//
//  UIViewController+XMFBaseViewController.h
//  ChatDemo
//
//  Created by xumingfa on 16/4/12.
//  Copyright © 2016年 xumingfa. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIViewController (XMFBaseViewController)

/*!
 设置标题
 */
@property (nonatomic, copy, nullable) NSString *xmf_title;

/*!
 设置rightItem
 */
- (UIButton *_Nullable)xmf_setNavgationItemWithRightTitle : (NSString *_Nullable)title
                                                textColor : (UIColor *_Nullable)color
                                                    image : (UIImage *_Nullable)image
                                                   action : (dispatch_block_t _Nullable)action;

/*!
 设置letfItem
 */
- (UIButton *_Nullable)xmf_setNavgationItemWithLeftTitle : (NSString *_Nullable)title
                                               textColor : (UIColor *_Nullable)color
                                                   image : (UIImage *_Nullable)image
                                                  action : (dispatch_block_t _Nullable)action;

/*!
 获得跳转Identifier
 */
+ (NSString *_Nullable)xmf_getSegueIdentifier;


@end

