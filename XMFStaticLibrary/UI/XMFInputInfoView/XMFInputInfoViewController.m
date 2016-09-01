//
//  CCChangeCarInfoViewController.m
//  CoolCar2.0
//
//  Created by kk on 15/8/27.
//  Copyright (c) 2015年 cars-link. All rights reserved.
//
#import "XMFInputInfoViewController.h"

#import "XMFTextView.h"
#import "XMFEmailVerifyView.h"
#import "NSString+LH.h"

#import "UIViewController+XMFBaseViewController.h"

#define MAX_LENGTH 5

@interface XMFInputInfoViewController () <UITextFieldDelegate, UITextViewDelegate, XMFTextViewDelegate>
/**
 *  单行输入框
 */
@property (weak, nonatomic) UITextField *dataTF;

@property (weak, nonatomic) XMFTextView *textView;

@property (weak, nonatomic) XMFEmailVerifyView *emailVerifyView;

/**
 *  数据传输的block
 */
@property (nonatomic, copy) ChangeData changeData;

@property (nonatomic, copy) EmailAction emailAction;

// 邮箱验证码
@property (nonatomic, copy) NSString *emailCode;


@end

@implementation XMFInputInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    [self xmf_setNavgationItemWithRightTitle:nil textColor:nil image:[UIImage imageNamed:@"XMFInputInfo.bundle/Images/save@2x.png"] action:^{
        [weakSelf saveData];
    }];
    [self xmf_setNavgationItemWithLeftTitle:nil textColor:nil image:[UIImage imageNamed:@"XMFInputInfo.bundle/Images/back.png"] action:nil];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    if (self.inputViewStyle == InputViewStyleTextField) {
        [self createChangeBasicDataView];
    }
    else if (self.inputViewStyle == InputViewStyleEmail) {
        [self createEmailTF];
    }
    else {
        [self createTextView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.inputViewStyle == InputViewStyleTextField)
        [self.dataTF becomeFirstResponder];
    else
        [self.textView becomeFirstResponder];
    [super viewDidAppear:animated];
}

/*!
 创建邮箱输入
 */
- (void)createEmailTF {
    
    XMFEmailVerifyView *emailVerifyView = [XMFEmailVerifyView new];
    emailVerifyView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    emailVerifyView.emailTF.text = self.defaultText;
    [emailVerifyView.commitBtn addTarget:self action:@selector(commitAction) forControlEvents:
     UIControlEventTouchUpInside];
    self.emailVerifyView = emailVerifyView;
    [self.view addSubview: self.emailVerifyView];
    
    emailVerifyView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:emailVerifyView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[XMFEmailVerifyView getHeight]];
    [emailVerifyView addConstraint: heightConstraint];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:emailVerifyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:emailVerifyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:emailVerifyView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraints:@[topConstraint, leftConstraint, rightConstraint]];
}

- (void)commitAction {
    if ([self.emailVerifyView.emailTF.text isValidateEmail]) {
        
        if (self.emailAction) {
            self.emailCode = self.emailAction(self.emailVerifyView.emailTF.text);
        }
    }
    else {
        NSLog(@"输入邮箱格式不正确！");
    }
}

- (void)commitEmailWithEmailAction : (EmailAction) action {
    
    self.emailAction = action;
}
                                                          

/*!
 创建修改个人资料的文本框视图
 */
- (void)createChangeBasicDataView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    
    UITextField *dataTF = [[UITextField alloc] init];
    dataTF.borderStyle = UITextBorderStyleNone;
    dataTF.returnKeyType = UIReturnKeyDone;
    dataTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    dataTF.text = self.defaultText;
    dataTF.placeholder = self.placeholder;
    dataTF.delegate = self;
    
    [topView addSubview:dataTF];
    [self.view addSubview:topView];
    self.dataTF = dataTF;
    
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTF.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraints:@[topConstraint, leftConstraint, rightConstraint]];
    
    NSLayoutConstraint *tf_heightConstraint = [NSLayoutConstraint constraintWithItem:dataTF attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *tf_LeftConstraint = [NSLayoutConstraint constraintWithItem:dataTF attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    NSLayoutConstraint *tf_RightConstraint = [NSLayoutConstraint constraintWithItem:dataTF attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    NSLayoutConstraint *tf_centerYConstraint = [NSLayoutConstraint constraintWithItem:dataTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [topView addConstraints:@[heightConstraint, tf_LeftConstraint, tf_RightConstraint, tf_centerYConstraint, tf_heightConstraint]];
}

- (NSString *)defaultText {
    if (!_defaultText) {
        return @"";
    }
    return _defaultText;
}

- (NSString *)placeholder {
    if (!_placeholder) {
        return @"";
    }
    return _placeholder;
}

- (void)createTextView {
    
    XMFTextView *textView = [[XMFTextView alloc] init];
    textView.returnKeyType = UIReturnKeyDone;
    textView.font = [UIFont systemFontOfSize:15];
    textView.text = self.defaultText;
    textView.placeholder = self.placeholder;
    textView.needPlaceholder = YES;
    textView.needwordLimit = YES;
    textView.maxWordLenght = 60;
    textView.backgroundColor = [UIColor whiteColor];
    textView.delegate = self;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textView = textView;
    
    [self.view addSubview: _textView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.textView) {
        [self.textView resignFirstResponder];
    }
    
    else if (self.dataTF) {
        [self.dataTF resignFirstResponder];
    }
    
    else if (self.emailVerifyView) {
        [self.emailVerifyView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

/**
 *  保存数据
 */
- (void)saveData {
    
    __weak typeof(self) weakSelf = self;
    void (^block) (NSString *errStr) = ^(NSString *errStr){
        if (weakSelf.inputViewStyle == InputViewStyleTextField) {
            if ([weakSelf.dataTF.text isValidateEmail]) {
                [weakSelf backData];
            }
            else {
                NSLog(@"%@", errStr);
            }
        }
        else if (weakSelf.inputViewStyle == InputViewStyleTextView) {
            if ([weakSelf.textView.text isValidateEmail]) {
                [weakSelf backData];
            }
            else {
                NSLog(@"%@", errStr);
            }
        }
        else if (weakSelf.inputViewStyle == InputViewStyleEmail) {
            if (self.emailCode == self.emailVerifyView.verificationCodeTF.text) {
                [weakSelf backData];
            }
            else {
                NSLog(@"%@", errStr);
            }
        }
    };
    
    if (self.inputViewStyle == InputViewStyleEmail) {
        block(@"验证码不正确！");
    }
    else {
        if (self.inputViewStyleAuthType == InputViewStyleAuthTypeEmail)
        {
            block(@"输入邮箱格式不正确！");
        }
        else if (self.inputViewStyleAuthType == InputViewStyleAuthTypeTelNo){
            block(@"输入手机格式不正确！");
        }
        
        else {
            [self backData];
        }
    }
    
}

- (void)backData {
    
    if (self.changeData != nil) {
        NSString *backData = @"";
        if (self.inputViewStyle == InputViewStyleTextField)
            backData = self.dataTF.text;
        else if (self.inputViewStyle == InputViewStyleEmail)
            backData = self.emailVerifyView.emailTF.text;
        else
            backData = self.textView.text;
        self.changeData(backData);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  传输数据方法
 */
- (void)commitChangeData:(ChangeData)changeData {
    self.changeData = changeData;
}

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)XMFTextView:(XMFTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

@end
