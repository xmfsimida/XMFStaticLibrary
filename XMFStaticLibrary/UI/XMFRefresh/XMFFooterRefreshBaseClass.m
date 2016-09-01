//
//  XMFFooterRefreshBaseClass.m
//  RefreshTest
//
//  Created by xumingfa on 16/7/20.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFFooterRefreshBaseClass.h"

@interface XMFFooterRefreshBaseClass ()

@property (nonatomic, copy) XMFScrollViewFooterAction action;
@property (nonatomic, copy) XMFScrollViewFooterContentInsetChangeAction contentInsetChangeAction;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign, getter=isAutoRefresh) BOOL autoRefresh;

@end

@implementation XMFFooterRefreshBaseClass

- (void)handleWithScrollView:(UIScrollView *)scrollView autoRefresh : (BOOL)autoRefresh EventWithAction:(XMFScrollViewFooterAction)action contentInsetChange:(XMFScrollViewFooterContentInsetChangeAction _Nullable)contentInsetChangeAction{
    
    _scrollView = scrollView;
    UIEdgeInsets edge = self.scrollView.contentInset;
    edge.bottom = self.dragOffset;
    _scrollView.contentInset = edge;
    _autoRefresh = autoRefresh;
    _action = action;
    _contentInsetChangeAction = contentInsetChangeAction;
    [_scrollView addObserver:self forKeyPath:XMF_REFRESH_CONTENTOFFSET_KEY options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [_scrollView addObserver:self forKeyPath:XMF_REFRESH_CONTENTSIZE_KEY options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (self.scrollView != object) return;
    CGFloat contentHeight = _scrollView.contentSize.height;
    CGFloat scrollViewHeight = _scrollView.bounds.size.height;
    CGPoint newPoint = [change[@"new"] CGPointValue];
    CGFloat bottomOffset = contentHeight - scrollViewHeight;
    
    if ([keyPath isEqualToString:XMF_REFRESH_CONTENTOFFSET_KEY] && self.scrollView == object) {
        if (bottomOffset > 0) {
            XMFRefreshStatus preStatus = self.refreshStatus;
            if (self.refreshStatus != XMFRefreshStatusPrepareEnd) { // 不是正在刷新
                if (self.autoRefresh) { // 是否自动刷新
                    if (newPoint.y - bottomOffset > self.dragOffset) {
                        self.refreshStatus = XMFRefreshStatusExecuting;
                    }
                    else {
                        self.refreshStatus = XMFRefreshStatusNormal;
                    }
                    if (self.action && preStatus != self.refreshStatus) self.action(self.refreshStatus, self.scrollView.contentOffset);
                }
                else {
                    if (self.scrollView.dragging) { // 是否在拖动
                        if (newPoint.y - bottomOffset > self.dragOffset) {
                            self.refreshStatus = XMFRefreshStatusPrepareStart;
                        }
                        else {
                            self.refreshStatus = XMFRefreshStatusNormal;
                        }
                    }
                    else {
                        if (newPoint.y - bottomOffset > self.dragOffset) {
                            self.refreshStatus = XMFRefreshStatusExecuting;
                        }
                        else {
                            self.refreshStatus = XMFRefreshStatusNormal;
                        }
                    }
                    if (self.action && preStatus != self.refreshStatus) self.action(self.refreshStatus, self.scrollView.contentOffset);
                }
            }
            else {
                if (newPoint.y - bottomOffset <=  self.dragOffset) {
                    self.refreshStatus = XMFRefreshStatusNormal;
                    self.action(self.refreshStatus, self.scrollView.contentOffset);
                }
            }
        }
    }
    else if ([keyPath isEqualToString: XMF_REFRESH_CONTENTSIZE_KEY] && self.scrollView == object) {
        CGSize newSize = [change[@"new"] CGSizeValue];
        CGSize oldSize = [change[@"old"] CGSizeValue];
        if (self.contentInsetChangeAction) self.contentInsetChangeAction(self.scrollView.contentInset, !CGSizeEqualToSize(newSize, oldSize));
    }
    
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)startRefreshWithHandle:(dispatch_block_t)handle {
    
    if (self.refreshStatus != XMFRefreshStatusExecuting) return;
    UIEdgeInsets edge = self.scrollView.contentInset;
    edge.bottom = self.dragOffset;
    self.scrollView.contentInset = edge;
    if (handle) handle();
}

- (void)endRefreshWithHandle:(dispatch_block_t)handle {
    
    if (self.refreshStatus != XMFRefreshStatusExecuting) return;
    if (!self.autoRefresh) {
        UIEdgeInsets edge = self.scrollView.contentInset;
        edge.bottom = 0;
        self.scrollView.contentInset = edge;
    }
    self.refreshStatus = XMFRefreshStatusPrepareEnd;
    if (self.action) self.action(self.refreshStatus, self.scrollView.contentOffset);
    if (handle) handle();
}

@end
