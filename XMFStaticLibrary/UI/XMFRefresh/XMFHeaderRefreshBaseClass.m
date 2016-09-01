//
//  XMFRefreshBaseClass.m
//  RefreshTest
//
//  Created by xumingfa on 16/7/20.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFHeaderRefreshBaseClass.h"

@interface XMFHeaderRefreshBaseClass ()

@property (nonatomic, copy) XMFScrollViewHeaderAction action;

@property (nonatomic, assign) XMFRefreshStatus refreshStatus;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation XMFHeaderRefreshBaseClass


- (void)handleWithScrollView:(UIScrollView *)scrollView EventWithAction:(XMFScrollViewHeaderAction)action {
    
    _scrollView = scrollView;
    _action = action;
    [_scrollView addObserver:self forKeyPath:XMF_REFRESH_CONTENTOFFSET_KEY options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

- (void)startRefreshWithHandle:(dispatch_block_t)handle {
    
    UIEdgeInsets edge = self.scrollView.contentInset;
    edge.top = self.dragOffset;
    self.scrollView.contentInset = edge;
    [self.scrollView setContentOffset:CGPointMake(0, -self.dragOffset) animated:YES];
    if (handle) handle();
}

- (void)endRefreshWithHandle:(dispatch_block_t)handle {
    
    if (self.refreshStatus != XMFRefreshStatusExecuting) return;
    self.refreshStatus = XMFRefreshStatusPrepareEnd;
    if (self.action) self.action(self.refreshStatus, self.scrollView.contentOffset);
    
    if (self.scrollView.contentOffset.y != 0) {
        [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.scrollView.contentOffset = CGPointZero;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIEdgeInsets edge = self.scrollView.contentInset;
                edge.top = 0;
                self.scrollView.contentInset = edge;
                self.refreshStatus = XMFRefreshStatusNormal;
                if (self.action) self.action(self.refreshStatus, self.scrollView.contentOffset);
            });
        } completion:NULL];
    }
    if (handle) handle();
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:XMF_REFRESH_CONTENTOFFSET_KEY] && object == self.scrollView) {
        
        CGPoint newPoint = [change[@"new"] CGPointValue];
        XMFRefreshStatus preStatus = self.refreshStatus;
        if (self.refreshStatus == XMFRefreshStatusExecuting || self.refreshStatus == XMFRefreshStatusPrepareEnd) return;    //  判断是否在刷新，正在刷新不做操作
        if (self.scrollView.isDragging) {         //  判断是否在拖动
            if (newPoint.y < -self.dragOffset) {
                self.refreshStatus = XMFRefreshStatusPrepareStart;
            }
            else {
                self.refreshStatus = XMFRefreshStatusNormal;
            }
        }
        else {
            
            if (fabsf(newPoint.y + self.dragOffset) >= -10) {
                if (self.refreshStatus == XMFRefreshStatusPrepareStart) {
                    self.refreshStatus = XMFRefreshStatusExecuting;
                }
            }
            else {
                self.refreshStatus = XMFRefreshStatusNormal;
            }
        }
        if (self.action && preStatus != self.refreshStatus)
            self.action(self.refreshStatus, self.scrollView.contentOffset);
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
