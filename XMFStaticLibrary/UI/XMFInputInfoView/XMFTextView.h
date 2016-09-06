//
//  XMFTextView.h
//  Tfunchat
//
//  Created by mr kiki on 16/3/21.
//  Copyright © 2016年 外语高手. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMFTextView;

@protocol XMFTextViewDelegate <NSObject>

@optional

- (BOOL)XMFTextView:(XMFTextView *_Nonnull)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *_Nonnull)text;

@end

@interface XMFTextView : UIView

@property (nonatomic, weak, readonly, null_resettable) UITextView *textView;

@property (nonatomic, assign, getter=isNeedPlaceholder) BOOL needPlaceholder;

@property (nonatomic, assign, getter=isNeedwordLimit) BOOL needwordLimit;

@property (nonatomic, copy, nullable) NSString *placeholder;

@property (nonatomic, assign) NSUInteger maxWordLenght;

@property (nonatomic, strong, nullable) UIColor * placeholerColor;

@property (nonatomic, strong, nullable) UIColor * wordLimitColor;

@property (nonatomic, weak, nullable) id<XMFTextViewDelegate> delegate;

@property(nullable,nonatomic,strong) UIFont *font;

@property(null_resettable,nonatomic,copy) NSString *text;

@property (nonatomic) UIReturnKeyType returnKeyType;

@property(nullable,nonatomic,strong) UIColor *textColor;

@end
