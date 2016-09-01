//
//  XMFRefreshImageHeaderView.m
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/8/9.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFRefreshImageHeaderView.h"
#import "XMFHeaderRefreshBaseClass.h"

@interface XMFRefreshImageHeaderView ()

@property (nonatomic, copy) RefreshAction headerRefreshAction;

@property (nonatomic, strong) XMFHeaderRefreshBaseClass *refreshBaseClass;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, strong) UIImage *prepareStartImage;

@property (nonatomic, strong) UIImage *executingImage;

@property (nonatomic, strong) UIImage *prepareEndImage;

@end

@implementation XMFRefreshImageHeaderView

#define HEADER_OFFSET 64.f

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.backgroundColor = XMF_REFRESH_VIWE_COLOR;
    
    [self addSubview: self.imageView];
}

- (UIImageView *)imageView {
    
    if (_imageView) return _imageView;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView = imageView;
    return _imageView;
}

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

- (void)setImage:(UIImage *)image withStatus:(XMFRefreshStatus)status {
    
    switch (status) {
        case XMFRefreshStatusNormal:
            self.normalImage = image;
            break;
        case XMFRefreshStatusPrepareStart:
             self.prepareStartImage = image;
            break;
        case XMFRefreshStatusExecuting:
            self.executingImage = image;
            break;
        case XMFRefreshStatusPrepareEnd:
            self.prepareEndImage = image;
            break;
        default:
            break;
    }
}

- (void)changeUIWithStatus : (XMFRefreshStatus)status {
    
    switch (status) {
        case XMFRefreshStatusNormal:
        {
            self.imageView.image = self.normalImage;
        }
            break;
        case XMFRefreshStatusPrepareStart:
        {
            self.imageView.image = self.prepareStartImage;
        }
            break;
        case XMFRefreshStatusExecuting:
        {
            self.imageView.image = self.executingImage;
            [self xmf_startPullDownRefreshing];
        }
            break;
        case XMFRefreshStatusPrepareEnd:
        {
            self.imageView.image = self.prepareEndImage;
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
    
    self.imageView.frame = self.bounds;
}

@end
