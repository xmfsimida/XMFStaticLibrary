//
//  RefreshFooterView.m
//  CoolCar2.0
//
//  Created by xumingfa on 15/12/23.
//  Copyright © 2015年 cars-link. All rights reserved.
//

#import "XMFRefreshAutoFooterView.h"
#import "XMFFooterRefreshBaseClass.h"

@interface XMFRefreshAutoFooterView ()

@property (nonatomic, copy) RefreshAction footerRefreshAction;

@property (nonatomic, strong) XMFFooterRefreshBaseClass *refreshBaseClass;
///  指示器
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
///  tip
@property (nonatomic, weak) UILabel *tipsLabel;
/// 是否点击
@property (nonatomic, assign, getter=isClick) BOOL click;

@end

#define FOOTER_OFFSET 60

@implementation XMFRefreshAutoFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    //  指示器
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView = activityIndicatorView;
    [self addSubview: _activityIndicatorView];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = self.tipsColor;
    tipsLabel.text = XMF_REFRESH_LOCALIZABLE(@"点击或上拉加载更多");
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:15];
    _tipsLabel = tipsLabel;
    [self addSubview: _tipsLabel];
}

- (UIColor *)tipsColor {
    
    if (_tipsColor) return _tipsColor;
    _tipsColor = XMF_REFRESH_TIPS_COLOR;
    return _tipsColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.refreshBaseClass.refreshStatus == XMFRefreshStatusNormal && self.isClick == NO) { // 普通状态
        self.click = YES;
        self.refreshBaseClass.refreshStatus = XMFRefreshStatusExecuting;
        [self changeUIWithStatus:self.refreshBaseClass.refreshStatus];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)footerRefresh: (RefreshAction) action {
    
    _footerRefreshAction = action;
    if ([self.superview isKindOfClass: [UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        _refreshBaseClass = [XMFFooterRefreshBaseClass new];
        _refreshBaseClass.dragOffset = FOOTER_OFFSET;
        XMF_REFRESH_WEAK_SELF
        [_refreshBaseClass handleWithScrollView:scrollView autoRefresh:YES EventWithAction:^(XMFRefreshStatus status, CGPoint contentOffset) {
            [weakSelf changeUIWithStatus:status];
        } contentInsetChange:^(UIEdgeInsets contentInset, BOOL isChange) {
            if (isChange) {
                [weakSelf setNeedsLayout];
                [weakSelf layoutIfNeeded];
            }
        }];
    }
}

- (void)changeUIWithStatus : (XMFRefreshStatus)status {
    
    if (self.noMoreData) { // 是否没有更多数据
        self.tipsLabel.text = XMF_REFRESH_LOCALIZABLE(@"已经全部加载完毕");
        [self.activityIndicatorView stopAnimating];
        [self.tipsLabel sizeToFit];
        return;
    }
    
    switch (status) {
        case XMFRefreshStatusNormal:
            self.tipsLabel.text = XMF_REFRESH_LOCALIZABLE(@"点击或上拉加载更多");
            [self.activityIndicatorView stopAnimating];
            break;
        case XMFRefreshStatusExecuting:
            [self xmf_startPullOnRefreshing];
        case XMFRefreshStatusPrepareEnd:
            [self.activityIndicatorView startAnimating];
            self.tipsLabel.text = XMF_REFRESH_LOCALIZABLE(@"正在加载更多的数据...");
            break;
        case XMFRefreshStatusPrepareStart:
            self.tipsLabel.text = XMF_REFRESH_LOCALIZABLE(@"松手加载");
            [self.activityIndicatorView stopAnimating];
            break;
        default:
            break;
    }
    [self.tipsLabel sizeToFit];
}

- (void)xmf_startPullOnRefreshing{
    
    XMF_REFRESH_WEAK_SELF
    [self.refreshBaseClass startRefreshWithHandle:^{
        if (weakSelf.footerRefreshAction) weakSelf.footerRefreshAction();
    }];

}

- (void)endRefreshing {
    
    XMF_REFRESH_WEAK_SELF
    [self.refreshBaseClass endRefreshWithHandle:^{
        if (weakSelf.isClick == YES) {
            weakSelf.click = NO;
            weakSelf.refreshBaseClass.refreshStatus = XMFRefreshStatusNormal;
            weakSelf.tipsLabel.text = XMF_REFRESH_LOCALIZABLE(@"点击或上拉加载更多");
            [weakSelf.activityIndicatorView stopAnimating];
        }
    }];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    
    const CGFloat RFV_W = CGRectGetWidth(scrollView.frame);
    const CGFloat RFV_H = FOOTER_OFFSET;
    const CGFloat RFV_X = 0;
    const CGFloat RFV_Y = CGRectGetHeight(scrollView.frame) > scrollView.contentSize.height ? CGRectGetHeight(scrollView.frame) : scrollView.contentSize.height;
    self.frame = CGRectMake(RFV_X, RFV_Y, RFV_W, RFV_H);
    
    const CGFloat TIPS_H = RFV_H;
    const CGFloat TIPS_W = [self.tipsLabel sizeThatFits:CGSizeMake(RFV_W, TIPS_H)].width;
    const CGFloat TIPS_X = (RFV_W - TIPS_W) / 2;
    const CGFloat TIPS_Y = 0;
    self.tipsLabel.frame = CGRectMake(TIPS_X, TIPS_Y, TIPS_W, TIPS_H);
    
    const CGFloat ATI_H = RFV_H;
    const CGFloat ATI_W = 50;
    const CGFloat ATI_X = TIPS_X - ATI_W;
    const CGFloat ATI_Y = 0;
    self.activityIndicatorView.frame = CGRectMake(ATI_X, ATI_Y, ATI_W, ATI_H);
}

- (void)removeAllObservers {
    
    [self.superview removeObserver:self.refreshBaseClass forKeyPath:XMF_REFRESH_CONTENTOFFSET_KEY];
    [self.superview removeObserver:self.refreshBaseClass forKeyPath:XMF_REFRESH_CONTENTSIZE_KEY];
}

@end
