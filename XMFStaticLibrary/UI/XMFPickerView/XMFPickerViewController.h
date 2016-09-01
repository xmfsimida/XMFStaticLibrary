//
//  XMFPickerViewController.h
//  XMFPickerView
//
//  Created by xumingfa on 16/6/3.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 普通picker
 strAry 字符数据
 indexAry 字符在传入数组对应位置
 */
typedef void (^XMFPickerViewNormalAction)( NSArray<NSString *>  * _Nonnull strAry, NSArray<NSNumber *> * _Nonnull indexAry);

typedef void(^XMFPickerViewDateAction)(NSDate *_Nonnull date);

typedef NS_ENUM(NSInteger, XMFPickerViewType) {
    
    XMFPickerViewTypeNormal, // 普通
    XMFPickerViewTypeDate   //  时间
};

@interface XMFPickerViewController : UIViewController

@property (nonatomic, copy, nullable) NSString *pickerTitle;

@property (nonatomic, copy, null_resettable) NSString *cancelText;

@property (nonatomic, copy, null_resettable) NSString *confirmText;

@property (nonatomic, assign) XMFPickerViewType type;

@property (nonatomic, strong, nullable) NSArray<NSArray<NSString *> *> *datas;

- (void)pushConfirmNormalAction : (XMFPickerViewNormalAction __nonnull)action;

- (void)pushConfirmDateAction : (XMFPickerViewDateAction __nonnull)action;

- (void)sourceViewController : (UIViewController * __nonnull)sourceViewControllerView popPickerViewControllerWithCompletion : (void (^ __nullable)(void))completion;

@end
