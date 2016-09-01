//
//  SupView.m
//  ScrollViewTest
//
//  Created by xumingfa on 15/12/19.
//  Copyright © 2015年 xumingfa. All rights reserved.
//

#import "XMFRefreshNormalHeaderView.h"
#import "XMFHeaderRefreshBaseClass.h"
#import "XMFRefreshConst.h"

@interface XMFRefreshNormalHeaderView ()

@property (nonatomic, copy) RefreshAction headerRefreshAction;
///  箭头
@property (nonatomic, weak) UIImageView *jtIV;
///  提示
@property (nonatomic, weak) UILabel *tipsLB;
///  指示器
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) XMFHeaderRefreshBaseClass *refreshBaseClass;

@end

@implementation XMFRefreshNormalHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
     
        [self initUI];
    }
    return self;
}

- (UIColor *)tipsColor {
    
    if (_tipsColor) return _tipsColor;
    _tipsColor = XMF_REFRESH_TIPS_COLOR;
    return _tipsColor;
}

- (UIImage *)instructionsImage {
    
    if (_instructionsImage) _instructionsImage;
    _instructionsImage = [UIImage imageNamed: XMF_REFRESH_IMAGE_PATH(@"箭头")];
    return _instructionsImage;
}

- (void)initUI {
    
    self.backgroundColor = XMF_REFRESH_VIWE_COLOR;
    //  初始化箭头
    UIImageView *iv = [UIImageView new];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = self.instructionsImage;
    _jtIV = iv;
    [self addSubview: _jtIV];
    
    //  文字提示
    UILabel *tipsLB = [UILabel new];
    tipsLB.font = [UIFont systemFontOfSize: 15];
    tipsLB.textAlignment = NSTextAlignmentCenter;
    tipsLB.textColor = self.tipsColor;
    tipsLB.text = XMF_REFRESH_LOCALIZABLE(@"下拉可以刷新");;
    _tipsLB = tipsLB;
    [self addSubview: _tipsLB];
    
    //  指示器
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.color = [UIColor blackColor];
    _activityIndicatorView = activityIndicatorView;
    [self addSubview: _activityIndicatorView];
}

#define HEADER_OFFSET 64.f

- (void)headerRefresh:(RefreshAction)action {
    
    _headerRefreshAction = action;
    if ([self.superview isKindOfClass: [UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        _refreshBaseClass = [XMFHeaderRefreshBaseClass new];
        _refreshBaseClass.dragOffset = HEADER_OFFSET;
        XMF_REFRESH_WEAK_SELF
        [_refreshBaseClass handleWithScrollView:scrollView EventWithAction:^(XMFRefreshStatus status, CGPoint contentOffset) {
            [weakSelf changeUIWithStatus:status];
        }];
    }
}

- (void)changeUIWithStatus : (XMFRefreshStatus)status {
 
    switch (status) {
        case XMFRefreshStatusNormal:
        {
            [self.activityIndicatorView stopAnimating];
            self.jtIV.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.jtIV.transform = CGAffineTransformIdentity;
            }];
            self.tipsLB.text = XMF_REFRESH_LOCALIZABLE(@"下拉可以刷新");
        }
            break;
        case XMFRefreshStatusPrepareStart:
        {
            [self.activityIndicatorView stopAnimating];
            self.jtIV.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.jtIV.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            self.tipsLB.text = XMF_REFRESH_LOCALIZABLE(@"松开立即刷新");
        }
            break;
        case XMFRefreshStatusExecuting:
        {
            self.jtIV.hidden = YES;
            [self.activityIndicatorView startAnimating];
            self.tipsLB.text = XMF_REFRESH_LOCALIZABLE(@"正在刷新数据中...");
            [self xmf_startPullDownRefreshing];
        }
            break;
        case XMFRefreshStatusPrepareEnd:
        {
            [self.activityIndicatorView stopAnimating];
            self.jtIV.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.jtIV.transform = CGAffineTransformIdentity;
            }];
            self.tipsLB.text = XMF_REFRESH_LOCALIZABLE(@"数据加载完成");
        }
            break;
        default:
            break;
    }
}

- (void)xmf_startPullDownRefreshing {

    XMF_REFRESH_WEAK_SELF
    [self.refreshBaseClass startRefreshWithHandle:^{
        if (weakSelf.headerRefreshAction) weakSelf.headerRefreshAction();
    }];
}

- (void)endRefreshing {

    [self.refreshBaseClass endRefreshWithHandle:nil];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    const CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    const CGFloat SF_W = screenSize.width;
    const CGFloat SF_H = HEADER_OFFSET;
    const CGFloat SF_X = 0;
    const CGFloat SF_Y = - SF_H;
    self.frame = CGRectMake(SF_X, SF_Y, SF_W, SF_H);
    
    const CGFloat TIPS_W = 150;
    const CGFloat TIPS_H = 30;
    const CGFloat TIPS_X = (screenSize.width - TIPS_W) / 2;
    const CGFloat TIPS_Y = (SF_H - TIPS_H) / 2;
    self.tipsLB.frame = CGRectMake(TIPS_X, TIPS_Y, TIPS_W, TIPS_H);
    
    const CGFloat MARGIN = 16;
    
    const CGFloat JT_W = 25;
    const CGFloat JT_H = 2 * JT_W;
    const CGFloat JT_X = TIPS_X - JT_W - MARGIN;
    const CGFloat JT_Y = (SF_H - JT_H) / 2;
    self.jtIV.frame = CGRectMake(JT_X, JT_Y, JT_W, JT_H);
    
    const CGFloat AI_W = 30;
    const CGFloat AI_H = 30;
    const CGFloat AI_X = JT_X;
    const CGFloat AI_Y = (SF_H - AI_H) / 2;
    self.activityIndicatorView.frame = CGRectMake(AI_X, AI_Y, AI_W, AI_H);
}

- (void)removeAllObservers {
    
    [self.superview removeObserver:self.refreshBaseClass forKeyPath:XMF_REFRESH_CONTENTOFFSET_KEY];
}

@end
