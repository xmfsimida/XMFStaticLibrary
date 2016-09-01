//
//  UIView+Keyboard.m
//  XBJob
//
//  Created by kk on 15/12/9.
//  Copyright © 2015年 cnmobi. All rights reserved.
//

#import "UIView+XMFKeyboard.h"
#import <objc/runtime.h>

@interface UIView()

@property (nonatomic, strong) UITapGestureRecognizer *xmf_tapGesture;

@property (nonatomic, strong) NSLayoutConstraint *xmf_topConstraint;

@property (nonatomic, assign) BOOL xmf_autoLayout;

@property (nonatomic, assign) BOOL xmf_custom;

@property (nonatomic, strong) NSNumber *xmf_changeOffset;

@property (nonatomic, assign) CGFloat xmf_originalY;

@property (nonatomic, assign) CGFloat xmf_contentOffsetY; // 当moveView是scollView的时候记录原有offsetY

@property (nonatomic, weak) __kindof UIView *xmf_moveView;

@end

@implementation UIView (XMFKeyboard)

- (UITapGestureRecognizer *)xmf_tapGesture {
    
    return objc_getAssociatedObject(self, @selector(xmf_tapGesture));
}

- (void)setXmf_tapGesture:(UITapGestureRecognizer *)xmf_tapGesture {
    
    objc_setAssociatedObject(self, @selector(xmf_tapGesture), xmf_tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)xmf_addKeyboardListen {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xmf_keyboardPushAction)];
    [self setXmf_tapGesture: tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmf_tapkeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmf_tapkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)xmf_removeKeyboardListen {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name:UIKeyboardWillHideNotification object:nil];
}


- (void)xmf_tapkeyboardWillShow: (NSNotification *)notification{
    
    
    BOOL isExist = [self.gestureRecognizers containsObject: self.xmf_tapGesture];
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    if (isExist == NO) {
        [self addGestureRecognizer: self.xmf_tapGesture];
    }
    [lock unlock];
}

- (void)xmf_tapkeyboardWillHide: (NSNotification *)notification{
    if (self.xmf_tapGesture) {
        [self removeGestureRecognizer:self.xmf_tapGesture];
    }
}

- (void)xmf_keyboardPushAction {
    [self endEditing:YES];
}

@end


@implementation UIView (XMFKeyboardHeightChange)

-(BOOL)xmf_custom {
    
    return [objc_getAssociatedObject(self, @selector(xmf_custom)) boolValue];
}

- (void)setXmf_custom:(BOOL)xmf_custom {
    objc_setAssociatedObject(self, @selector(xmf_custom), @(xmf_custom), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)xmf_autoLayout {
    
    return [objc_getAssociatedObject(self, @selector(xmf_autoLayout)) boolValue];
}

- (void)setXmf_autoLayout:(BOOL)xmf_autoLayout {
    
    objc_setAssociatedObject(self, @selector(xmf_autoLayout), @(xmf_autoLayout), OBJC_ASSOCIATION_ASSIGN);
}


- (NSLayoutConstraint *)xmf_topConstraint {
    
    return objc_getAssociatedObject(self, @selector(xmf_topConstraint));
}

- (void)setXmf_topConstraint:(NSLayoutConstraint *)xmf_topConstraint {
    
    objc_setAssociatedObject(self, @selector(xmf_topConstraint), xmf_topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (CGFloat)xmf_originalY {
    
    return [objc_getAssociatedObject(self, @selector(xmf_originalY)) floatValue];
}

- (void)setXmf_originalY:(CGFloat)xmf_originalY {
    
    objc_setAssociatedObject(self, @selector(xmf_originalY), @(xmf_originalY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)xmf_contentOffsetY {
    
    return [objc_getAssociatedObject(self, @selector(xmf_contentOffsetY)) floatValue];
}

- (void)setXmf_contentOffsetY:(CGFloat)xmf_contentOffsetY {
    
    objc_setAssociatedObject(self, @selector(xmf_contentOffsetY), @(xmf_contentOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)xmf_changeOffset {
    
    return objc_getAssociatedObject(self, @selector(xmf_changeOffset));
}

- (void)setXmf_changeOffset:(NSNumber *)xmf_changeOffset {
    
    objc_setAssociatedObject(self, @selector(xmf_changeOffset), xmf_changeOffset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)xmf_moveView {
    
    return objc_getAssociatedObject(self, @selector(xmf_moveView));
}

- (void)setXmf_moveView:(__kindof UIView *)xmf_moveView {
    
    objc_setAssociatedObject(self, @selector(xmf_moveView), xmf_moveView, OBJC_ASSOCIATION_ASSIGN);
}

- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout:(BOOL)autoLayout {
    
    self.xmf_autoLayout = autoLayout;
    self.xmf_originalY = self.xmf_moveView ? CGRectGetMidY(self.xmf_moveView.frame) : CGRectGetMidY(self.frame);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmf_changeHeightKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmf_changeHeightkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout:(BOOL)autoLayout changeForView:(__kindof UIView *)view {
    
    self.xmf_moveView = view;
    [self xmf_addKeyboardHeightChangeListenWithAutoLayout:autoLayout];
}

- (void)xmf_addKeyboardHeightChangeListenWithAutoLayout : (BOOL)autoLayout custom :(BOOL)custom changeHeight : (CGFloat)changeHeight {
    
    self.xmf_custom = custom;
    self.xmf_changeOffset = @(changeHeight);
    [self xmf_addKeyboardHeightChangeListenWithAutoLayout:autoLayout];
}

- (void)xmf_removeKeyboardHeightChangeListen {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)xmf_changeHeightKeyboardWillShow: (NSNotification *)notification{
    
    UIView *moveView = self.xmf_moveView ? self.xmf_moveView : self; // 移动的组件
    
    CGFloat keyboardHeight  =   [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration        =   [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewKeyframeAnimationOptions curve = [[notification.userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    CGFloat keyboardY = CGRectGetHeight([UIScreen mainScreen].bounds) - keyboardHeight;
    CGRect currentFrame = [self convertRect:self.bounds toView:nil];
    CGFloat offet = CGRectGetMaxY(currentFrame) - keyboardY;
    
    if ([self.xmf_moveView isKindOfClass:[UIScrollView class]]) { // 是否scrollview子类
        UIScrollView *sv = self.xmf_moveView;
        self.xmf_contentOffsetY = sv.contentOffset.y;
    }
    if (offet == 0) return;
    offet = self.xmf_custom ? [self.xmf_changeOffset floatValue] : offet; // 是否自定义view
    offet += self.xmf_contentOffsetY;
    
    if (self.xmf_autoLayout) {
        if (self.xmf_topConstraint) {[moveView.superview removeConstraint:self.xmf_topConstraint];}
        self.xmf_topConstraint = [NSLayoutConstraint constraintWithItem : moveView
                                                              attribute : NSLayoutAttributeTop
                                                              relatedBy : NSLayoutRelationEqual
                                                                 toItem : moveView.superview
                                                              attribute : NSLayoutAttributeTop
                                                             multiplier : 1
                                                               constant : CGRectGetMinY(moveView.frame) - offet];
        [moveView.superview addConstraint: self.xmf_topConstraint];
    }
    else {
        CGRect bounds = self.frame;
        bounds.origin.y = CGRectGetMidY(moveView.bounds) - offet;
        moveView.frame = bounds;
    }
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:curve animations:^{
        [moveView.superview layoutIfNeeded];
    } completion:NULL];
}

- (void)xmf_changeHeightkeyboardWillHide: (NSNotification *)notification{
    
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewKeyframeAnimationOptions curve = [[notification.userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    UIView *moveView = self.xmf_moveView ? self.xmf_moveView : self; // 移动的组件
    if (self.xmf_autoLayout) {
        [moveView.superview removeConstraint:self.xmf_topConstraint];
    }
    else {
        CGRect bounds = self.frame;
        bounds.origin.y = self.xmf_originalY;
        moveView.frame = bounds;
    }
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:curve animations:^{
        [moveView.superview layoutIfNeeded];
        if ([self.xmf_moveView isKindOfClass:[UIScrollView class]]) { // 是否scrollview子类
            UIScrollView *sv = self.xmf_moveView;
            sv.contentOffset = CGPointMake(sv.contentOffset.x, self.xmf_contentOffsetY);
            [self xmf_cleanAssociatedObjects];
        }
    } completion:NULL];
}

- (void)xmf_cleanAssociatedObjects {
    
    objc_setAssociatedObject(self, @selector(xmf_topConstraint), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(xmf_autoLayout), nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(xmf_custom), nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(xmf_changeOffset), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(xmf_originalY), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(xmf_contentOffsetY), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(xmf_moveView), nil , OBJC_ASSOCIATION_ASSIGN);
}

@end
