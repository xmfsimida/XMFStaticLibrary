//
//  UIButton+XMFCategory.m
//  CornerTest
//
//  Created by xumingfa on 16/7/26.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "UIButton+XMFCategory.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, weak) CALayer *xmf_maskLayer;

@end

@implementation UIButton (XMFCategory)

+ (void)load {
    
    Method oldMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method newMethod = class_getInstanceMethod(self, @selector(xmf_buttonLayoutSubviews));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (void)xmf_buttonLayoutSubviews {
    [self xmf_buttonLayoutSubviews];
    
    if (self.xmf_buttonMaskCornerRadius > 0) {
        [self resetMaskCornerRadius];
    }
}

static char xmf_button_preFrame;
- (NSValue *)xmf_preFrame {
    
    NSValue *value = objc_getAssociatedObject(self, &xmf_button_preFrame);
    if (value) return value;
    NSValue *defaultValue = [NSValue valueWithCGRect:CGRectZero];
    return defaultValue;
}

- (void)setXmf_preFrame:(NSValue *)xmf_preFrame {
    
    objc_setAssociatedObject(self, &xmf_button_preFrame, xmf_preFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char xmf_mask_layer;
- (void)setXmf_maskLayer:(CALayer *)xmf_maskLayer {
    
    objc_setAssociatedObject(self, &xmf_mask_layer, xmf_maskLayer, OBJC_ASSOCIATION_ASSIGN);
}

- (CALayer *)xmf_maskLayer {
    
    return objc_getAssociatedObject(self,  &xmf_mask_layer);
}

static char xmf_button_mask_corner_radius;

- (CGFloat)xmf_buttonMaskCornerRadius {
    
    return [objc_getAssociatedObject(self, &xmf_button_mask_corner_radius) floatValue];

}

- (void)setXmf_buttonMaskCornerRadius:(CGFloat)xmf_buttonMaskCornerRadius {
    
    objc_setAssociatedObject(self, &xmf_button_mask_corner_radius, @(xmf_buttonMaskCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (void)resetMaskCornerRadius {
    
    if (CGRectEqualToRect([self.xmf_preFrame CGRectValue], self.bounds)) return;
    if (self.xmf_maskLayer) [self.xmf_maskLayer removeFromSuperlayer];
    CAShapeLayer *layer = [CAShapeLayer layer];
    self.xmf_maskLayer = layer;
    
    const CGFloat cornerRadius = self.xmf_buttonMaskCornerRadius;
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius: cornerRadius];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(0, 0)];
    [path2 addLineToPoint:CGPointMake(0, CGRectGetMaxY(self.bounds))];
    [path2 addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    [path2 addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), 0)];
    [path appendPath:path1];
    [path appendPath:path2];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.fillColor = [self getSuperViewColor].CGColor;
    [self.layer addSublayer: layer];
    self.xmf_preFrame = [NSValue valueWithCGRect:self.bounds];
}

/*!
 获取父类的颜色
 */
- (UIColor *)getSuperViewColor {
    
    UIColor *color = [UIColor clearColor];
    UIView *superView = self.superview;
    while (superView) {
        CGFloat alpha = CGColorGetAlpha(superView.backgroundColor.CGColor);
        if (alpha != 0) {
            color = superView.backgroundColor;
            break;
        }
        superView = superView.superview;
    }
    return color;
}


@end
