//
//  XMFTagButton.h
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/5/31.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMFTagButton : UIButton

@property (nonatomic, strong, nullable) UIColor *selectedBackgroundColor; // 默认红色

@property (nonatomic, strong, nullable) UIColor *normalBackgroundColor;

@property (nonatomic, assign, getter=isNeedRadius) BOOL needRadius; // 是否需要边框

@end
