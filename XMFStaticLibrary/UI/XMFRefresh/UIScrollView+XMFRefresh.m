//
//  UIScrollView+Touch.m
//  CoolCar2.0
//
//  Created by xumingfa on 15/12/19.
//  Copyright © 2015年 cars-link. All rights reserved.
//

#import "UIScrollView+XMFRefresh.h"
#import <objc/runtime.h>
#import "XMFRefreshNormalHeaderView.h"
#import "XMFRefreshAutoFooterView.h"
#import "XMFHeaderRefreshBaseClass.h"

@implementation UITableView (XMFRefresh)

static char XMF_REFRESH_HEADER_VIEW;
static char XMF_REFRESH_FOOTER_VIEW;

- (XMFRefreshNormalHeaderView *)xmf_header {
    
    XMFRefreshNormalHeaderView *refreshHeaderView = objc_getAssociatedObject(self, &XMF_REFRESH_HEADER_VIEW);
    if (!refreshHeaderView) {
        XMFRefreshNormalHeaderView *rh = [XMFRefreshNormalHeaderView new];
        refreshHeaderView = rh;
        [self addSubview: refreshHeaderView];
        objc_setAssociatedObject(self,& XMF_REFRESH_HEADER_VIEW, refreshHeaderView, OBJC_ASSOCIATION_ASSIGN);
    }
    return refreshHeaderView;
}

- (XMFRefreshAutoFooterView *)xmf_footer {
    
    XMFRefreshAutoFooterView *refreshFooterView = objc_getAssociatedObject(self, &XMF_REFRESH_FOOTER_VIEW);
    if (!refreshFooterView) {
        XMFRefreshAutoFooterView *rf = [XMFRefreshAutoFooterView new];
        refreshFooterView = rf;
        [self addSubview: refreshFooterView];
        objc_setAssociatedObject(self, &XMF_REFRESH_FOOTER_VIEW, refreshFooterView, OBJC_ASSOCIATION_ASSIGN);
    }
    return refreshFooterView;
}

- (void)dealloc {
    
    if (objc_getAssociatedObject(self, &XMF_REFRESH_HEADER_VIEW)) {
        [self.xmf_header removeAllObservers];
    }
    if (objc_getAssociatedObject(self, &XMF_REFRESH_FOOTER_VIEW)) {
        [self.xmf_footer removeAllObservers];
    }
}

@end


@implementation UICollectionView (XMFRefresh)

static char XMF_REFRESH_HEADER_VIEW;
static char XMF_REFRESH_FOOTER_VIEW;

- (XMFRefreshNormalHeaderView *)xmf_header {
    
    XMFRefreshNormalHeaderView *refreshHeaderView = objc_getAssociatedObject(self, &XMF_REFRESH_HEADER_VIEW);
    if (!refreshHeaderView) {
        XMFRefreshNormalHeaderView *rh = [XMFRefreshNormalHeaderView new];
        refreshHeaderView = rh;
        [self addSubview: refreshHeaderView];
        objc_setAssociatedObject(self,& XMF_REFRESH_HEADER_VIEW, refreshHeaderView, OBJC_ASSOCIATION_ASSIGN);
    }
    return refreshHeaderView;
}

- (XMFRefreshAutoFooterView *)xmf_footer {
    
    XMFRefreshAutoFooterView *refreshFooterView = objc_getAssociatedObject(self, &XMF_REFRESH_FOOTER_VIEW);
    if (!refreshFooterView) {
        XMFRefreshAutoFooterView *rf = [XMFRefreshAutoFooterView new];
        refreshFooterView = rf;
        [self addSubview: refreshFooterView];
        objc_setAssociatedObject(self, &XMF_REFRESH_FOOTER_VIEW, refreshFooterView, OBJC_ASSOCIATION_ASSIGN);
    }
    return refreshFooterView;
}

- (void)dealloc {
    
    if (objc_getAssociatedObject(self, &XMF_REFRESH_HEADER_VIEW)) {
        [self.xmf_header removeAllObservers];
    }
    if (objc_getAssociatedObject(self, &XMF_REFRESH_FOOTER_VIEW)) {
        [self.xmf_footer removeAllObservers];
    }
}


@end
