//
//  UIView+Keyboard.h
//  XBJob
//
//  Created by kk on 15/12/9.
//  Copyright © 2015年 cnmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XMFKeyboard)

- (void)xmf_addKeyboardListen;

- (void)xmf_removeKeyboardListen;

@end

@interface UIView (XMFKeyboardHeightChange)

- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout : (BOOL)autoLayout;

- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout : (BOOL)autoLayout
                                          changeForView : (__kindof UIView * __nullable)view;

- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout : (BOOL)autoLayout
                                                 custom :(BOOL)custom
                                           changeHeight : (CGFloat)changeHeight;

- (void)xmf_removeKeyboardHeightChangeListen;

@end
