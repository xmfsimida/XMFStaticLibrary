//
//  XMFPickerViewController.m
//  XMFPickerView
//
//  Created by xumingfa on 16/6/3.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFPickerViewController.h"

typedef NS_ENUM(NSInteger, XMFPickerViewButtonStyle) {
    
    XMFPickerViewButtonStyleConfirm,
    XMFPickerViewButtonStyleCancel
};

@interface XMFPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;
@property (weak, nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *cancelBN;
@property (weak, nonatomic) IBOutlet UIButton *confirmBN;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (copy, nonatomic) XMFPickerViewNormalAction normalAction;
@property (copy, nonatomic) XMFPickerViewDateAction dateAction;

@end

@implementation XMFPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (NSString *)cancelText {
    
    if (_cancelText) return _cancelText;
    _cancelText = @"Cancel";
    return _cancelText;
}

- (NSString *)confirmText {
    
    if (_confirmText) return _confirmText;
    _confirmText = @"Confirm";
    return _confirmText;
}

- (void)layoutItems {
    
    UIView *view = nil;
    if (self.type == XMFPickerViewTypeNormal) {
        view = _pickerView;
    } else {
        view= _datePicker;
    }
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *layouts = @[
                         [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.centerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                         [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.centerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                         [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.centerView attribute:NSLayoutAttributeWidth multiplier:1 constant:-16],
                         [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.centerView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]
                         ];
    [self.centerView addConstraints:layouts];
}

- (void)sourceViewController:(UIViewController *)sourceViewControllerView popPickerViewControllerWithCompletion:(void (^)(void))completion {
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    sourceViewControllerView.definesPresentationContext = YES;
    [sourceViewControllerView presentViewController:self animated:YES completion:completion];
}

- (void)pushConfirmNormalAction:(XMFPickerViewNormalAction)action {
    
    _normalAction = action;
}

- (void)pushConfirmDateAction:(XMFPickerViewDateAction)action {
    
    _dateAction = action;
}

- (IBAction)pushAction:(UIButton *)sender {
    
    if (sender.tag == XMFPickerViewButtonStyleConfirm) {
        
        if (self.type == XMFPickerViewTypeNormal) {
            NSMutableArray *indexAry= [NSMutableArray arrayWithCapacity: self.pickerView.numberOfComponents];
            NSMutableArray *strAry = [NSMutableArray arrayWithCapacity: self.pickerView.numberOfComponents];
            
            for (int i = 0; i < self.pickerView.numberOfComponents; i++) {
                
                [indexAry addObject: @([self.pickerView selectedRowInComponent:i])];
                [strAry addObject: [self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:i] forComponent:i]];
            }
            
            if (_normalAction) {
                self.normalAction(strAry, indexAry);
            }
        }
        else {
            if (_dateAction) {
                self.dateAction(self.datePicker.date);
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([touches anyObject].view == self.centerView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)initUI {
    
    [self.cancelBN setTitle:_cancelText forState: UIControlStateNormal];
    [self.confirmBN setTitle:_confirmText forState: UIControlStateNormal];
    
    if (self.type == XMFPickerViewTypeNormal) {
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        [self.centerView addSubview:pickerView];
        _pickerView = pickerView;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }
    else {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_SC"]];
        [self.centerView addSubview: datePicker];
        _datePicker = datePicker;
    }
    [self layoutItems];
    
    self.confirmBN.tag = XMFPickerViewButtonStyleConfirm;
    self.cancelBN.tag = XMFPickerViewButtonStyleCancel;
    
    if (self.pickerTitle && self.pickerTitle.length > 0) {
        self.topViewTopConstraint.constant = 49.f;
        self.titleLB.text = self.pickerTitle;
    }
    else {
        self.topViewTopConstraint.constant = 0.f;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.datas[component].count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return self.datas.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.datas[component][row];
}


@end
