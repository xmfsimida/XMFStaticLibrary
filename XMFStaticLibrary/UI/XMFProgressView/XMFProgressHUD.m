//
//  XMFProgressView.m
//  XMFProgressView
//
//  Created by xumingfa on 16/3/29.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFProgressHUD.h"
#import "XMFHUDConst.h"
#import "UIView+XMFKeyboard.h"

@interface XMFProgressHUD ()

@property (nonatomic, weak) CAShapeLayer *bgLayer;

@property (nonatomic, weak) CAShapeLayer *loadingLayer;

@property (nonatomic, copy) NSString *statusText;

@property (nonatomic, assign) CGFloat currentAngle;

@end

@implementation XMFProgressHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    const CGFloat LINE_WIDTH = 5.f;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bgFrame = CGRectMake(PROGRESS_CENTER_PADDING , PROGRESS_CENTER_PADDING, PROGRESS_CENTER_WIDTH - 2 * PROGRESS_CENTER_PADDING, PROGRESS_CENTER_HEIGHT - 2 * PROGRESS_CENTER_PADDING);
    
    UIBezierPath *bigBgPath = [UIBezierPath bezierPathWithOvalInRect: bgFrame];
    CGContextAddPath(ctx, bigBgPath.CGPath);
    CGContextSetLineWidth(ctx, LINE_WIDTH);
    [[XMF_PROGRESS_HUD_LOADING_BACKGROUND_COLOR colorWithAlphaComponent:0.5] setFill];
    CGContextFillPath(ctx);

    UIBezierPath *bgPath = [UIBezierPath bezierPathWithOvalInRect: bgFrame];
    CGContextAddPath(ctx, bgPath.CGPath);
    CGContextSetLineWidth(ctx, LINE_WIDTH);
    [XMF_PROGRESS_HUD_LOADING_BACKGROUND_COLOR setStroke];
    CGContextStrokePath(ctx);

    UIBezierPath *loadingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(PROGRESS_CENTER_WIDTH / 2, PROGRESS_CENTER_HEIGHT / 2) radius:(PROGRESS_CENTER_HEIGHT - 2 * PROGRESS_CENTER_PADDING) / 2 startAngle:0 endAngle:self.currentAngle clockwise:YES];
    CGContextAddPath(ctx, loadingPath.CGPath);
    CGContextSetLineWidth(ctx, LINE_WIDTH);
    CGContextSetLineJoin(ctx, kCALineJoinRound);
    CGContextSetLineCap(ctx, kCALineCapRound);
    [XMF_PROGRESS_HUD_LOADING_FOREGROUND_COLOR setStroke];
    CGContextStrokePath(ctx);
    
    NSString *statuStr = self.statusText;
    const CGFloat FONT_SIZE = 15;
    const CGFloat LB_WIDTH = PROGRESS_CENTER_WIDTH;
    const CGFloat LB_HEIGTH = FONT_SIZE;
    const CGFloat LB_X = (PROGRESS_CENTER_WIDTH - LB_WIDTH) / 2;
    const CGFloat LB_Y = (PROGRESS_CENTER_HEIGHT - LB_HEIGTH) / 2;
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE],
                            NSForegroundColorAttributeName : [UIColor whiteColor],
                            NSParagraphStyleAttributeName: paragraphStyle
                            };
    [statuStr drawInRect:CGRectMake(LB_X, LB_Y, LB_WIDTH, LB_HEIGTH) withAttributes:attrs];
}

- (void)refreshViewWithTotalLenght : (CGFloat) totalLenght currentLenght : (CGFloat) currentLenght{
  
    CGFloat percentage = currentLenght / totalLenght;
    CGFloat endAngle = 2 * M_PI;
    CGFloat startAngle = 0.0f;
    CGFloat currentAngle = percentage <= 1 ? percentage * endAngle : endAngle;
    self.currentAngle = currentAngle;
    self.statusText = [NSString stringWithFormat:@"%.2f%%", percentage <= 1 ? percentage * 100 : 100];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)dealloc {
    
    [self xmf_removeKeyboardHeightChangeListen];
}

@end
