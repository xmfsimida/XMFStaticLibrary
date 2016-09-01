//
//  UIViewController+XMFBaseViewController.m
//  ChatDemo
//
//  Created by xumingfa on 16/4/12.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "UIViewController+XMFBaseViewController.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, XMFItemStyle)
{
    XMFItemStyleLeft = 0x110,
    XMFItemStyleRight = 0x120
};

@interface UIViewController () <UINavigationControllerDelegate>

@property (nonatomic, copy) dispatch_block_t xmf_leftItemAction;

@property (nonatomic, copy) dispatch_block_t xmf_rightItemAction;

@end


@implementation UIViewController (XMFBaseViewController)

- (dispatch_block_t)xmf_leftItemAction {
    return objc_getAssociatedObject(self, @selector(xmf_leftItemAction));
}

- (dispatch_block_t)xmf_rightItemAction {
    return objc_getAssociatedObject(self, @selector(xmf_rightItemAction));
}

- (void)setXmf_leftItemAction:(dispatch_block_t)xmf_leftItemAction {
    objc_setAssociatedObject(self, @selector(xmf_leftItemAction), xmf_leftItemAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setXmf_rightItemAction:(dispatch_block_t)xmf_rightItemAction {
    objc_setAssociatedObject(self, @selector(xmf_rightItemAction), xmf_rightItemAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setXmf_title:(NSString *)xmf_title {
    
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor blackColor];
    title.text = xmf_title;
    [title sizeToFit];
    self.navigationItem.titleView = title;
}

- (NSString *)xmf_title {
    UILabel *title = (UILabel *)self.navigationItem.titleView;
    return title.text;
}

- (UIButton *)xmf_setNavgationItemWithLeftTitle:(NSString *)title textColor:(UIColor *)color image:(UIImage *)image action:(dispatch_block_t _Nullable)action{
    
    if (!title && !image) {
        self.navigationItem.rightBarButtonItem = nil;
        return nil;
    }
    
    UIButton *leftBtn = [UIButton new];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    leftBtn.titleLabel.preferredMaxLayoutWidth = 150.f;
    leftBtn.tag = XMFItemStyleLeft;
    [leftBtn addTarget:self action:@selector(xmf_pushItemActionWithButton:) forControlEvents:UIControlEventTouchUpInside];
    if (title) {
        [leftBtn setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [leftBtn setTitleColor:color forState:UIControlStateNormal];
        [leftBtn setTitleColor:[color colorWithAlphaComponent: 0.1] forState:UIControlStateHighlighted];
    }
    if (image) {
        [leftBtn setImage:image forState:UIControlStateNormal];
    }
    [leftBtn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView: leftBtn];
    self.xmf_leftItemAction = action;
    self.navigationItem.leftBarButtonItem = item;
    return leftBtn;
}

- (UIButton *)xmf_setNavgationItemWithRightTitle:(NSString *)title textColor:(UIColor *)color image:(UIImage *)image action:(dispatch_block_t _Nullable)action{
    
    if (!title && !image) {
        self.navigationItem.rightBarButtonItem = nil;
        return nil;
    }
    
    UIButton *rightBtn = [UIButton new];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.tag = XMFItemStyleRight;
    [rightBtn addTarget:self action:@selector(xmf_pushItemActionWithButton:) forControlEvents:UIControlEventTouchUpInside];
    if (title) {
        [rightBtn setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [rightBtn setTitleColor:color forState:UIControlStateNormal];
        [rightBtn setTitleColor:[color colorWithAlphaComponent: 0.1] forState:UIControlStateHighlighted];
    }
    if (image) {
        [rightBtn setImage:image forState:UIControlStateNormal];
    }
    [rightBtn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView: rightBtn];
    self.xmf_rightItemAction = action;
    self.navigationItem.rightBarButtonItem = item;
    return rightBtn;
}

- (void)xmf_pushItemActionWithButton : (UIButton *)sender {
    
    if (sender.tag == XMFItemStyleLeft) {
        if (self.xmf_leftItemAction) self.xmf_leftItemAction();
        else [self xmf_popVC];
    }
    else if (sender.tag == XMFItemStyleRight) {
        if (self.xmf_rightItemAction) self.xmf_rightItemAction();
    }
}

- (void)xmf_popVC {
    
    if (self.navigationController)[self.navigationController popViewControllerAnimated:YES];
    else [self dismissViewControllerAnimated:YES completion:NULL];
}

+ (NSString *)xmf_getSegueIdentifier
{
    return NSStringFromClass([self class]);
}

@end
