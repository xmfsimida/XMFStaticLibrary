//
//  UIAlertView+Category.m
//  Tfunchat
//
//  Created by mr kiki on 16/3/31.
//  Copyright © 2016年 外语高手. All rights reserved.
//

#import "UIAlertView+XMFCategory.h"
#import "UIAlertController+XMFCategory.h"
#import <objc/runtime.h>

@interface UIAlertView () <UIAlertViewDelegate>

@property (nonatomic, copy) XMFAlertViewHandler alertHandle;

@end

@implementation UIAlertView (XMFCategory)

- (void)setAlertHandle:(XMFAlertViewHandler)alertHandle {
    
    return objc_setAssociatedObject(self, @selector(alertHandle), alertHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (XMFAlertViewHandler)alertHandle {
    
    return objc_getAssociatedObject(self, @selector(alertHandle));
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.alertHandle) self.alertHandle(buttonIndex);
}

- (void)clickedButtonWithAction:(XMFAlertViewHandler )action {
    
    self.delegate = self;
    self.alertHandle = action;
}

+ (void)showAlertViewInViewController: (UIViewController *)vc  action : (XMFAlertViewHandler) action Title: (NSString *)title message: (NSString *)message cancelButtonTitle: (NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    
    vc = vc ? vc : [[[UIApplication sharedApplication] delegate] window].rootViewController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        alertController.alertViewHandler = action;
        if (cancelButtonTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                if (alertController.alertViewHandler) alertController.alertViewHandler(0);
            }];
            [alertController addAction:cancelAction];
        }
        
        NSMutableArray<NSString *> *ary = [NSMutableArray<NSString *> array];
        va_list params; //定义一个指向个数可变的参数列表指针;
        va_start(params,otherButtonTitles);//va_start 得到第一个可变参数地址,
        id arg;
        if (otherButtonTitles) {
            //将第一个参数添加到array
            id prev = otherButtonTitles;
            [ary addObject:prev];
            //va_arg 指向下一个参数地址
            //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
            
            //            NSAssert(, @"你没有在可变参数后加入nil做为结束!");
            while( (arg = va_arg(params,id)) )
            {
                if ( arg ){
                    [ary addObject:arg];
                }
            }
            //置空
            va_end(params);
        }
        
        for (int i = 0; i < ary.count; i++) {
            NSString *str = ary[i];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                if (alertController.alertViewHandler) alertController.alertViewHandler(cancelButtonTitle ? i + 1 : i);
            }];
            [alertController addAction:otherAction];
        }
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [vc presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
        [alertView clickedButtonWithAction:action];
        [alertView show];
    }
}

@end
