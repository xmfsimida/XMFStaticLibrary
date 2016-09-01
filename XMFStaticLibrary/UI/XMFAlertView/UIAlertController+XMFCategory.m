//
//  UIAlertController+XMFCategory.m
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/6/23.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "UIAlertController+XMFCategory.h"
#import <objc/runtime.h>

@implementation UIAlertController (XMFCategory)

- (XMFAlertViewHandler)alertViewHandler {
    
    return objc_getAssociatedObject(self, @selector(alertViewHandler));
}

- (void)setAlertViewHandler:(XMFAlertViewHandler)alertViewHandler {
    
    objc_setAssociatedObject(self, @selector(alertViewHandler), alertViewHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
