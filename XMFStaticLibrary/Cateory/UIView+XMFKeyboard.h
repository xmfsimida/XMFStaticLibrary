//
//  UIView+Keyboard.h
//  XBJob
//
//  Created by kk on 15/12/9.
//  Copyright © 2015年 cnmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XMFKeyboard)

/// 添加键盘监听 （当键盘弹出是，点击某个控件，停止编辑状态）
- (void)xmf_addKeyboardListen;

/// 移除键盘监听
- (void)xmf_removeKeyboardListen;

@end

@interface UIView (XMFKeyboardHeightChange)

/// 为控件添加键盘高度改变，不被遮盖的功能
///
/// - parameter autoLyout : 是否自动布局（如果是自动布局，要将此控件的纵向的约束设为弱约束
- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout : (BOOL)autoLayout;

/// 为控件添加键盘高度改变，不被遮盖的功能
///
/// - parameter autoLyout : 是否自动布局（如果是自动布局，要将此控件的纵向的约束设为弱约束
/// - parameter changeHeight : 需要改变高度
/// - parameter changeView : 需要改变高度的控件
- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout : (BOOL)autoLayout
                                          changeForView : (__kindof UIView * __nullable)view;

/// 为控件添加键盘高度改变，不被遮盖的功能
///
/// - parameter autoLyout : 是否自动布局（如果是自动布局，要将此控件的纵向的约束设为弱约束
/// - parameter changeHeight : 需要改变高度
/// - parameter custom : 是否自定义改变的高度
- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout : (BOOL)autoLayout
                                           changeHeight : (CGFloat)changeHeight;

/// 移除监听
- (void)xmf_removeKeyboardHeightChangeListen;

@end
