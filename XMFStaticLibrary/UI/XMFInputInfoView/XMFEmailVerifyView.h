//
//  XMFEmailVerifyView.h
//  ChatDemo
//
//  Created by xumingfa on 16/4/13.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMFEmailVerifyView : UIView

///  邮箱输入框
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

///  确认按钮
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

///  验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;

/// 获取控件高度
+ (CGFloat)getHeight;

@end
