//
//  UIScrollView+XMFSegment.h
//  XMFSegmentDemo
//
//  Created by xumingfa on 16/7/4.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XMFScrollViewSegmentBlock)(NSSet<UITouch *> *touches ,UIEvent *event);

@interface UIScrollView (XMFSegment)

- (void)xmf_touchesEndedWithHandler : (XMFScrollViewSegmentBlock)handler;

@end
