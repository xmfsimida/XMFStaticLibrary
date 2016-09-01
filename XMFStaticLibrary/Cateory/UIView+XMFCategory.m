//
//  UIView+Category.m
//  Sfunchat
//
//  Created by mr kiki on 16/3/14.
//  Copyright © 2016年 外语高手. All rights reserved.
//

#import "UIView+XMFCategory.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, weak) CAShapeLayer *boundLineLayer;

@property (nonatomic, strong) NSValue *xmf_preFrame;

@property (nonatomic, weak) CALayer *xmf_maskLayer;

@end

@implementation UIView (XMFCategory)

/*!
 获得view所在的viewController
 */
- (UIViewController *)xmf_getBelongViewController {
    
    UIResponder *superResponder = self.nextResponder;
    if ([superResponder isKindOfClass:[UIViewController class]] || superResponder == nil) return superResponder;
    return [(UIView *)superResponder xmf_getBelongViewController];
}

/*!
 获取父类的颜色
 */
- (UIColor *)xmf_getSuperViewBackgroundColor {
    
    UIView *superView = self.superview;
    if (superView == nil) return nil;
    if (CGColorGetAlpha(superView.backgroundColor.CGColor) != 0) return superView.backgroundColor;
    return [superView xmf_getSuperViewBackgroundColor];
}

- (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image{
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)xmf_layoutSubviews {
    [self xmf_layoutSubviews];
    
    if (self.xmf_maskCornerRadius > 0) {
        [self resetMaskCornerRadius];
    }
}

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL oldSEL = @selector(layoutSubviews);
        SEL newSEL = @selector(xmf_layoutSubviews);
        
        Method oldMethod = class_getInstanceMethod(self, oldSEL);
        Method newMethod = class_getInstanceMethod(self, newSEL);
        
        BOOL isADD = class_addMethod(self, oldSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        
        if (isADD) {
            class_replaceMethod(self, newMethod, method_getImplementation(oldSEL), method_getTypeEncoding(oldSEL));
        }
        else {
            method_exchangeImplementations(oldMethod, newMethod);
        }
    });
}

- (void)xmf_changeMashColor:(UIColor *)color {
    
    if (self.xmf_maskLayer) {
        ((CAShapeLayer *)self.xmf_maskLayer).fillColor = color.CGColor;
    }
}

- (void)xmf_reductionMashColor {
    
    if (self.xmf_maskLayer) {
        ((CAShapeLayer *)self.xmf_maskLayer).fillColor = [self xmf_getSuperViewBackgroundColor].CGColor;}
}

- (NSValue *)xmf_preFrame {
    
    NSValue *value = objc_getAssociatedObject(self, @selector(xmf_preFrame));
    if (value) return value;
    NSValue *defaultValue = [NSValue valueWithCGRect:CGRectZero];
    return defaultValue;
}

- (void)setXmf_preFrame:(NSValue *)xmf_preFrame {
    
    objc_setAssociatedObject(self, @selector(xmf_preFrame), xmf_preFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)boundLineLayer {
    
    return objc_getAssociatedObject(self, @selector(boundLineLayer));
}

- (void)setBoundLineLayer:(CAShapeLayer *)boundLineLayer {
    
    objc_setAssociatedObject(self, @selector(boundLineLayer), boundLineLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setXmf_cornerRadius:(CGFloat)xmf_cornerRadius {
    
    self.layer.masksToBounds = xmf_cornerRadius > 0 ? YES : NO;
    self.layer.cornerRadius = xmf_cornerRadius;
}

- (CGFloat)xmf_cornerRadius {
    return self.layer.mask.cornerRadius;
}

static char xmf_mask_corner_radius;
- (void)setXmf_maskCornerRadius:(CGFloat)xmf_maskCornerRadius {
    
    if ([self versionAndImageViewJudge]) {
        self.layer.cornerRadius = xmf_maskCornerRadius;
        self.layer.masksToBounds = YES;
    }
    else {
        objc_setAssociatedObject(self, &xmf_mask_corner_radius, @(xmf_maskCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (CGFloat)xmf_maskCornerRadius {
    
    return [objc_getAssociatedObject(self, &xmf_mask_corner_radius) floatValue];
}

static char xmf_mask_layer;
- (void)setXmf_maskLayer:(CALayer *)xmf_maskLayer {
    
    objc_setAssociatedObject(self, &xmf_mask_layer, xmf_maskLayer, OBJC_ASSOCIATION_ASSIGN);
}

- (CALayer *)xmf_maskLayer {
    
    return objc_getAssociatedObject(self,  &xmf_mask_layer);
}

- (void)resetMaskCornerRadius {
    
    if (CGRectEqualToRect([self.xmf_preFrame CGRectValue], self.bounds)) return;
    if (self.xmf_maskLayer) [self.xmf_maskLayer removeFromSuperlayer];
    
    const CGFloat cornerRadius = self.xmf_maskCornerRadius;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    self.xmf_maskLayer = layer;
    
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
    layer.fillColor = [self xmf_getSuperViewBackgroundColor].CGColor;
    [self.layer addSublayer: layer];
    
    self.xmf_preFrame = [NSValue valueWithCGRect:self.bounds];
}

/*!
 判断版本是否9.0以上和类型是否为UIImageView
 */
- (BOOL)versionAndImageViewJudge {
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0 && [self isKindOfClass:[UIImageView class]]) {
        return YES;
    }
    return NO;
}

- (void)xmf_setMaskCornerRadiusWithUIRectCorner:(UIRectCorner)options CornerRadius:(CGFloat)cornerRadius {
    
    if (options == -404) return;
    if (CGRectEqualToRect([self.xmf_preFrame CGRectValue], self.bounds)) return;
    if (self.xmf_maskLayer) [self.xmf_maskLayer removeFromSuperlayer];
    CAShapeLayer *layer = [CAShapeLayer layer];
    self.xmf_maskLayer = layer;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:options cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(0, 0)];
    [path2 addLineToPoint:CGPointMake(0, CGRectGetMaxY(self.bounds))];
    [path2 addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    [path2 addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), 0)];
    [path appendPath:path1];
    [path appendPath:path2];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.fillColor = [self xmf_getSuperViewBackgroundColor].CGColor;
    [self.layer addSublayer: layer];
    
    
    self.xmf_preFrame = [NSValue valueWithCGRect:self.bounds];
}

-(CABasicAnimation *)rotationDuration:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: degree ];
    rotationAnimation.duration = dur;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeatCount;
    
    return rotationAnimation;
    
}

- (void)xmf_setRoundedBoxWithCornerRadius:(CGFloat)cornerRadius color:(UIColor *)color {
    [self xmf_setRoundedBoxWithCornerRadius:cornerRadius color:color lineWidth:1];
}

- (void)xmf_setRoundedBoxWithCornerRadius:(CGFloat)cornerRadius color:(UIColor *)color lineWidth : (CGFloat) lineWidth{
    
    if (CGRectEqualToRect([self.xmf_preFrame CGRectValue], self.bounds)) return;
    if (self.boundLineLayer) [self.boundLineLayer removeFromSuperlayer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = lineWidth;
    layer.path = path.CGPath;
    self.boundLineLayer = layer;
    [self.layer addSublayer: layer];
    self.xmf_preFrame = [NSValue valueWithCGRect:self.bounds];
}

- (void)xmf_removeRoundedBox{
    
    if (self.boundLineLayer) [self.boundLineLayer removeFromSuperlayer];
}

- (void)xmf_lineAddWithXMFLineOptions : (XMFLineOptions)lineOptions color : (UIColor *)color lineWidth : (CGFloat)lineWidth {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = color.CGColor;
    layer.lineWidth = lineWidth;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    UIBezierPath *topBezierPath = [UIBezierPath bezierPath];
    UIBezierPath *leftBezierPath = [UIBezierPath bezierPath];
    UIBezierPath *bottomBezierPath = [UIBezierPath bezierPath];
    UIBezierPath *rightBezierPath = [UIBezierPath bezierPath];
    
    CGPoint leftTop = CGPointMake(0, 0);
    CGPoint rightTop = CGPointMake(CGRectGetWidth(self.bounds), 0);
    CGPoint leftBottom = CGPointMake(0, CGRectGetHeight(self.bounds));
    CGPoint rightBottom = CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    if (lineOptions & XMFLineOptionsTop) {
        [topBezierPath moveToPoint:leftTop];
        [topBezierPath addLineToPoint:rightTop];
        [bezierPath appendPath:topBezierPath];
    }
    if (lineOptions & XMFLineOptionsLeft) {
        [leftBezierPath moveToPoint:leftTop];
        [leftBezierPath addLineToPoint: leftBottom];
        [bezierPath appendPath:leftBezierPath];
    }
    if (lineOptions & XMFLineOptionsBottom) {
        [bottomBezierPath moveToPoint:leftBottom];
        [bottomBezierPath addLineToPoint: rightBottom];
        [bezierPath appendPath: bottomBezierPath];
    }
    if (lineOptions & XMFLineOptionsRight) {
        [rightBezierPath moveToPoint: rightTop];
        [rightBezierPath addLineToPoint: rightBottom];
        [bezierPath appendPath: rightBezierPath];
    }
    layer.path = bezierPath.CGPath;
    [self.layer addSublayer: layer];
}

- (void)xmf_lineAddWithXMFLineOptions : (XMFLineOptions)lineOptions color : (UIColor *)color {
    [self xmf_lineAddWithXMFLineOptions:lineOptions color:color lineWidth:1];
}

- (void)xmf_lineAddWithXMFLineOptions : (XMFLineOptions)lineOptions lineWidth : (CGFloat)lineWidth  {
    [self xmf_lineAddWithXMFLineOptions:lineOptions color:[UIColor blackColor] lineWidth:lineWidth];
}

- (void)xmf_lineAddWithXMFLineOptions : (XMFLineOptions)lineOptions{
    [self xmf_lineAddWithXMFLineOptions:lineOptions color:[UIColor blackColor] lineWidth:1];
}


- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions color : (UIColor *)color lineWidth : (CGFloat)lineWidth padding:(CGFloat)padding{
    
    if (lineOptions & XMFLineOptionsTop) {
        
        UIView *topLine = [UIView new];
        topLine.translatesAutoresizingMaskIntoConstraints = NO;
        topLine.backgroundColor = color;
        [self addSubview: topLine];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:topLine
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                          constant:- padding * 2]];
        [topLine addConstraint:[NSLayoutConstraint constraintWithItem:topLine
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:lineWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:topLine
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:topLine
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
    }
    if (lineOptions & XMFLineOptionsLeft) {
        
        UIView *leftLine = [UIView new];
        leftLine.translatesAutoresizingMaskIntoConstraints = NO;
        leftLine.backgroundColor = color;
        [self addSubview: leftLine];
        [leftLine addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:lineWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant: -padding * 2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:leftLine
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:leftLine
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:0]];
    }
    if (lineOptions & XMFLineOptionsBottom) {
        UIView *bottomLine = [UIView new];
        bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
        bottomLine.backgroundColor = color;
        [self addSubview: bottomLine];
        //设置子视图的宽度和父视图的宽度相等
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:bottomLine
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                          constant:-padding * 2]];
        [bottomLine addConstraint:[NSLayoutConstraint constraintWithItem:bottomLine
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:lineWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:bottomLine
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:bottomLine
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
    }
    if (lineOptions & XMFLineOptionsRight) {
        UIView *rightLine = [UIView new];
        rightLine.translatesAutoresizingMaskIntoConstraints = NO;
        rightLine.backgroundColor = color;
        [self addSubview: rightLine];
        //设置子视图的宽度和父视图的宽度相等
        [rightLine addConstraint:[NSLayoutConstraint constraintWithItem:rightLine
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:lineWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:-padding * 2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:rightLine
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:rightLine
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:0]];
        
    }
}

- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions color : (UIColor *)color lineWidth : (CGFloat)lineWidth {
    
    [self xmf_autoLineAddWithXMFLineOptions:lineOptions color:color lineWidth:lineWidth padding:0];
}

- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions color : (UIColor *)color{
    [self xmf_autoLineAddWithXMFLineOptions:lineOptions color:color lineWidth:1];
}

- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions lineWidth : (CGFloat)lineWidth {
    [self xmf_autoLineAddWithXMFLineOptions:lineOptions color:[UIColor blackColor] lineWidth:lineWidth];
}

- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions {
    [self xmf_autoLineAddWithXMFLineOptions:lineOptions color:[UIColor blackColor] lineWidth:1];
}


@end

@implementation UIView (XMFAnimation)

- (void)xmf_addYRotateWithDuration : (CGFloat) duration
                       autoreverses:(BOOL)autoreverses{
    
    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [an setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
    [an setDuration:duration];
    [an setFromValue:@1];
    [an setToValue:@-1];
    an.fillMode = kCAFillModeForwards;
    [an setAutoreverses:autoreverses];
    [self.layer addAnimation:an forKey:nil];
}

/*!
 透明度变化
 */
- (void)xmf_addChangeOpacityWithDuration : (CGFloat) duration
                               fromValue : (CGFloat) fromValue
                                 toValue : (CGFloat) toValue
                             autoreverses:(BOOL)autoreverses{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = autoreverses;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:nil];
}

- (void)xmf_addChangeScaleWithDuration:(CGFloat)duration
                             fromValue:(CGFloat)fromValue
                               toValue:(CGFloat)toValue
                          autoreverses:(BOOL)autoreverses{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = duration;
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    animation.autoreverses = autoreverses;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:nil];
}

/*!
 平移
 */
- (void)xmf_addMoveXWithDuration : (CGFloat) duration
                       fromValue : (CGFloat) fromValue
                         toValue : (CGFloat) toValue
                    autoreverses : (BOOL) autoreverses {
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = autoreverses;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:nil];
    
}

@end
