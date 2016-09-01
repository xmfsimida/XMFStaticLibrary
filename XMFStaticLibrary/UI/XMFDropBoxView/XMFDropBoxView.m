//
//  XMFDropBoxView.m
//  XBJob
//
//  Created by kk on 15/11/13.
//  Copyright © 2015年 cnmobi. All rights reserved.
//

#import "XMFDropBoxView.h"

#define TRIANGLE_HEIGHT 10.f // 三角形的高

#define DROP_BOX_TAG 102030

@interface XMFDropBoxView ()

@property (nonatomic, copy) ActionBlock handle;

@property (nonatomic, strong) NSMutableArray<UIView *> *datas;

@property (nonatomic, assign) BOOL positive;

@property (nonatomic, weak) UIView *contentView;

@end

@implementation XMFDropBoxView

+ (instancetype)dropBoxWithLocationView:(UIView *)locationView dataSource:(id<XMFDropBoxViewDataSource>)dataSource{
    //  如果存在下拉框就删去，否则显示
    XMFDropBoxView *dropBox = [XMFDropBoxView new];
    dropBox.dataSource = dataSource;
    dropBox.locationView = locationView;
    return dropBox;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = [UIColor whiteColor];
        _contentView =  contentView;
        [self addSubview: _contentView];
    }
    return self;
}

/**
 *  动画
 */
- (void)addAnimation{
    
    CGFloat totalDuration = 0.3;
    
    CGPoint endPoint;
    CGPoint startPoint;
    
    CGFloat shadowY;
    const CGFloat shadowX = CGRectGetMinX(self.contentView.frame);
    const CGFloat shadowW = CGRectGetWidth(self.contentView.frame);
    const CGFloat shadowH =  CGRectGetHeight(self.contentView.frame) - TRIANGLE_HEIGHT;
    
    if (self.positive) {
        startPoint = CGPointMake(self.contentView.center.x, CGRectGetMinY(self.contentView.frame));
        endPoint = CGPointMake(self.contentView.center.x, self.contentView.center.y);
        shadowY = CGRectGetMinY(self.contentView.frame) + TRIANGLE_HEIGHT;
    }
    else {
        startPoint = CGPointMake(self.contentView.center.x, CGRectGetMaxY(self.contentView.frame));
        endPoint = CGPointMake(self.contentView.center.x, self.contentView.center.y);
        shadowY = CGRectGetMinY(self.contentView.frame);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: startPoint];
    [path addLineToPoint: endPoint];
    
    CAKeyframeAnimation *kfAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    kfAnimation.duration = totalDuration;
    kfAnimation.path = path.CGPath;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.duration = totalDuration;
    scaleAnimation.fromValue = @(0);
    scaleAnimation.toValue = @(1);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration		= totalDuration;
    opacityAnimation.fromValue	= @(0);
    opacityAnimation.toValue		= @(1.0);
    opacityAnimation.autoreverses = NO;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.beginTime = CACurrentMediaTime();
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.duration = totalDuration;
    groupAnimation.animations = @[kfAnimation, scaleAnimation, opacityAnimation];
    
    [self.contentView.layer addAnimation:groupAnimation forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(totalDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 5;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(shadowX, shadowY, shadowW, shadowH) cornerRadius:5];
        self.layer.shadowPath = shadowPath.CGPath;
    });
    
}

- (void)setContentColor:(UIColor *)contentColor {
    
    _contentColor = contentColor;
    self.contentView.backgroundColor = contentColor;
}

- (void)setLocationView:(UIView *)locationView {
    _locationView = locationView;
    [self setLayoutForView];
}

- (void)setDataSource:(id<XMFDropBoxViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self setLayoutForView];
}

- (void)setLayoutForView {
    if (!self.locationView) return;
    
    NSAssert(self.dataSource, @"dataSource is null");
    
    [self addItems];
    
    if (self.datas.count == 0) return;
    //  相对于屏幕的坐标
    CGRect bounds = [self.locationView convertRect:self.locationView.bounds toView:nil];
    const CGFloat VIEW_H =  CGRectGetMaxY(self.datas[self.datas.count - 1].frame); //  view的高
    CGFloat VIEW_W = 0.f;
    if ([self.dataSource respondsToSelector:@selector(widthInDropBoxView:)]) {
        VIEW_W = [self.dataSource widthInDropBoxView:self];
    }
    const CGFloat VIEW_X = CGRectGetMidX(bounds) - VIEW_W / 2;
    const CGFloat VIEW_Y = CGRectGetMaxY(bounds);
    
    //  三角形的坐标
    CGFloat triangleWidth = TRIANGLE_HEIGHT;
    CGFloat triangleX = (VIEW_W - triangleWidth) / 2;
    CGFloat triangleY = 0.f;
    BOOL positive = true;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat x = VIEW_X;
    if (VIEW_X + VIEW_W > screenBounds.size.width) {    //  是否越过屏幕右边线
        x = screenBounds.size.width - VIEW_W;
        triangleX = VIEW_W - CGRectGetWidth(bounds) / 2;
    }
    else if (VIEW_X < 0) { //  是否越过屏幕左边线
        x = 0;
        triangleX = CGRectGetWidth(bounds) / 2;
    }
    
    CGFloat y = VIEW_Y;
    if (VIEW_Y + VIEW_H > screenBounds.size.height) {   //  是否越过屏幕下边线
        y = CGRectGetMinY(bounds) - VIEW_H;
        triangleY = VIEW_H - TRIANGLE_HEIGHT;
        positive = false;
        
        // 设置item Y 值从0开始
        for (UIView *item in self.datas) {
            CGRect itemF = item.frame;
            itemF.origin.y -= TRIANGLE_HEIGHT;
            item.frame = itemF;
        }
    }
    self.positive = positive;
    self.contentView.frame = CGRectMake(x, y, VIEW_W, VIEW_H);
    
    [self addPathToLayerWithFrame: CGRectMake(triangleX, triangleY, triangleWidth, TRIANGLE_HEIGHT) positive:positive];
}

- (void)addItems {
    
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector: @selector(numberOfItemInDropBoxView:)]) {
        count = [self.dataSource numberOfItemInDropBoxView:self];
    }
    
    UIView *view;
    CGFloat height = 0.f;
    CGFloat y = TRIANGLE_HEIGHT;
    CGFloat width = 0.f;
    if ([self.dataSource respondsToSelector:@selector(widthInDropBoxView:)]) {
        width = [self.dataSource widthInDropBoxView:self];
    }
    _datas = [NSMutableArray<UIView *> arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        
        if ([self.dataSource respondsToSelector:@selector(dropBoxView:itemAtIndex:)]) {
            view = [self.dataSource dropBoxView:self itemAtIndex:i];
            
            if ([self.dataSource respondsToSelector: @selector(dropBoxView:heightForItemAtIndex:)]) {
                height = [self.dataSource dropBoxView:self heightForItemAtIndex:i];
            }
            
            if (i != 0) {
                y = CGRectGetMaxY(self.datas[i - 1].frame);
            }
            
            CGRect frame = CGRectMake(0, y, width, height);
            view.frame = frame;
            view.tag = DROP_BOX_TAG + i;
            view.userInteractionEnabled = YES;
            [self.datas insertObject:view atIndex:i];
            [self.contentView addSubview: view];
        }
    }
}

- (void)addPathToLayerWithFrame: (CGRect) frame positive : (BOOL) positive {
    
    const CGFloat radius = 5; // 圆角
    
    self.layer.cornerRadius = radius;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.contentView.bounds;
    
    //  画三角形
    CGRect bounds = self.contentView.bounds;
    bounds.size.height -= TRIANGLE_HEIGHT;
    
    CGFloat topY;
    CGFloat bottomY;
    
    if (positive) {
        topY = 0.f;
        bottomY = TRIANGLE_HEIGHT;
        
        bounds.origin.y = TRIANGLE_HEIGHT;
    }
    else {
        bottomY = frame.origin.y;
        topY = bottomY + CGRectGetHeight(frame);
        
        bounds.origin.y = 0.f;
    }
    
    const CGPoint startPoint = CGPointMake(CGRectGetMinX(frame), bottomY);
    const CGPoint widthPoint = CGPointMake(CGRectGetMaxX(frame), bottomY);
    const CGPoint endPoint = CGPointMake(CGRectGetMidX(frame), topY);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //  上左角
    [path moveToPoint: CGPointMake(0, radius + CGRectGetMinY(bounds))];
    [path addQuadCurveToPoint:CGPointMake(radius, CGRectGetMinY(bounds)) controlPoint:CGPointMake(0, CGRectGetMinY(bounds))];
    
    if (topY == 0.f) {
        [path addLineToPoint:startPoint];
        [path addLineToPoint: endPoint];
        [path addLineToPoint: widthPoint];
    }
    
    //  上右角
    [path addLineToPoint:CGPointMake(CGRectGetWidth(bounds) - radius, CGRectGetMinY(bounds))];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetWidth(bounds), radius + CGRectGetMinY(bounds)) controlPoint:CGPointMake(CGRectGetWidth(bounds), CGRectGetMinY(bounds))];
    
    //  下右角
    [path addLineToPoint: CGPointMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds) - radius + CGRectGetMinY(bounds))];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetWidth(bounds) - radius, CGRectGetHeight(bounds) + CGRectGetMinY(bounds)) controlPoint:CGPointMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds) + CGRectGetMinY(bounds))];
    
    if (topY > 0.f) {
        [path addLineToPoint:startPoint];
        [path addLineToPoint: endPoint];
        [path addLineToPoint: widthPoint];
    }
    
    //  下左角
    [path addLineToPoint: CGPointMake(radius, CGRectGetHeight(bounds) + CGRectGetMinY(bounds))];
    [path addQuadCurveToPoint: CGPointMake(0, CGRectGetHeight(bounds) - radius + CGRectGetMinY(bounds)) controlPoint:CGPointMake(0, CGRectGetHeight(bounds) + CGRectGetMinY(bounds))];
    
    //  关闭路径
    [path closePath];
    
    layer.path = path.CGPath;
    self.contentView.layer.mask = layer;

    [self addAnimation];
}

- (void)displayDropBox {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview: self];
}

- (void)dismissDropBox {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0.1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf removeFromSuperview];
    });
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *view = touches.anyObject.view;
    if (view.tag >= DROP_BOX_TAG && view.tag < self.datas.count + DROP_BOX_TAG) {
        NSUInteger idx = view.tag - DROP_BOX_TAG;
        if (self.handle) {
            self.handle(idx);
        }
    }
    [self dismissDropBox];
}

- (void)selectItemWithBlock:(ActionBlock)handle {
    
    _handle = handle;
}

@end
