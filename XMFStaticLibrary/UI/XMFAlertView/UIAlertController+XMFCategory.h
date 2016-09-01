//
//  UIAlertController+XMFCategory.h
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/6/23.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFAlertViewParams.h"

@interface UIAlertController (XMFCategory)

@property (nonatomic, copy, nullable) XMFAlertViewHandler alertViewHandler;

@end
