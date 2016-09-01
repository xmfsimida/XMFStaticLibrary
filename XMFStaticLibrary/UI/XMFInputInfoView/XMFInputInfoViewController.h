//
//  CCChangeCarInfoViewController.h
//  CoolCar2.0
//
//  Created by kk on 15/8/27.
//  Copyright (c) 2015年 cars-link. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChangeData) (NSString *data);

typedef NSString * (^EmailAction) (NSString *email);

typedef NS_ENUM(NSInteger, InputViewStyle){
    InputViewStyleTextField,
    InputViewStyleTextView,
    InputViewStyleEmail
};

typedef NS_ENUM(NSInteger, InputViewStyleAuthType){
    InputViewStyleAuthTypeNone = 0,
    InputViewStyleAuthTypeEmail,
    InputViewStyleAuthTypeTelNo
};

@interface XMFInputInfoViewController : UIViewController

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) NSString *defaultText;

@property (nonatomic, assign) InputViewStyle inputViewStyle;

@property (nonatomic, assign) InputViewStyleAuthType inputViewStyleAuthType;

/*!
数据传输
 */
- (void)commitChangeData : (ChangeData) changeData;

/*! 
 邮箱模式点击确认按钮回调
 */
- (void)commitEmailWithEmailAction : (EmailAction) action;

@end
