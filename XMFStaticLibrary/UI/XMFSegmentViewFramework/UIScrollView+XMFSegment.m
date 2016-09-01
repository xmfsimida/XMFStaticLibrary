//
//  UIScrollView+XMFSegment.m
//  XMFSegmentDemo
//
//  Created by xumingfa on 16/7/4.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "UIScrollView+XMFSegment.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@property (nonatomic, copy) XMFScrollViewSegmentBlock xmf_segmentHandler;

@end

@implementation UIScrollView (XMFSegment)

- (XMFScrollViewSegmentBlock)xmf_segmentHandler {
    
    return objc_getAssociatedObject(self, @selector(xmf_segmentHandler));
}

- (void)setXmf_segmentHandler:(XMFScrollViewSegmentBlock)xmf_segmentHandler {
    
    objc_setAssociatedObject(self, @selector(xmf_segmentHandler), xmf_segmentHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    if (self.xmf_segmentHandler) self.xmf_segmentHandler(touches, event);
}

- (void)xmf_touchesEndedWithHandler:(XMFScrollViewSegmentBlock)handler {
    
    self.xmf_segmentHandler = handler;
}

@end
