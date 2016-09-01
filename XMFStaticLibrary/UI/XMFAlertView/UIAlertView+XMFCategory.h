//
//  UIAlertView+Category.h
//  Tfunchat
//
//  Created by mr kiki on 16/3/31.
//  Copyright © 2016年 外语高手. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFAlertViewParams.h"

@interface UIAlertView (XMFCategory)

- (void)clickedButtonWithAction : (XMFAlertViewHandler __nullable) action;

+ (void)showAlertViewInViewController: (UIViewController *_Nullable)vc  action : (XMFAlertViewHandler __nullable) action Title: (nullable NSString *)title message: (nullable NSString *)message cancelButtonTitle: (nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...;


@end
