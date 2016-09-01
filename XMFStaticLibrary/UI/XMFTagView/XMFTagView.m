//
//  XMFTagView.m
//  XMFTagView
//
//  Created by xumingfa on 16/5/31.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFTagView.h"
#import "XMFTagHeaderView.h"
#import "XMFTagContentView.h"
#import "XMFTagModel.h"

@interface XMFTagView ()

@property (nonatomic, weak) XMFTagHeaderView *headerView;

@property (nonatomic, weak) XMFTagContentView *contentView;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, weak) CALayer *lineLayer;

@end

@implementation XMFTagView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)setDatas:(NSArray<XMFTagModel *> *)datas {
    
    if (_datas == datas) return;
    _datas = datas;
    [self initUI];
}

- (void)initUI {
    
    __weak typeof(self) weakSelf = self;
    XMFTagContentView *contentView = [XMFTagContentView new];
    contentView.moreImage = self.bottomMoreImage;
    contentView.vPadding = 8;
    contentView.hPadding = 8;
    _contentView = contentView;
    [self addSubview: _contentView];
    
    XMFTagHeaderView *headerView = [XMFTagHeaderView new];
    headerView.moreImage = self.topMoreImage;
    headerView.vPadding = 8;
    headerView.hPadding = 8;
    headerView.type = XMFTagHeaderTypeNormal;
    headerView.titleAry = (NSArray<XMFTagHeaderModel *> *)self.datas;
    [headerView pushItemWithAction:^(NSUInteger index) {
        if (weakSelf.currentIndex != index) {
            contentView.contentAry = weakSelf.datas[index].tagContentAry;
            weakSelf.currentIndex = index;
        }
    }];
    if (self.datas.count > 0) {
        contentView.contentAry = weakSelf.datas[self.currentIndex].tagContentAry;   
    }
    _headerView = headerView;
    [self addSubview: _headerView];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [UIColor colorWithRed:240 / 255.f green:240 / 255.f blue:240 / 255.f alpha:1].CGColor;
    _lineLayer = lineLayer;
    [self.layer addSublayer: _lineLayer];
}

- (void)layoutItems {
    
    const CGFloat LINE_HEIGHT = 0.5f; // 线的高度
    
    const CGFloat headerHeight = 36.f;
    CGRect headerRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), headerHeight);
    self.headerView.frame = headerRect;
    
    CGRect lineRect = CGRectMake(0, CGRectGetMaxY(headerRect), CGRectGetWidth(self.bounds), LINE_HEIGHT);
    self.lineLayer.frame = lineRect;
    
    CGRect contentRect = CGRectMake(0, CGRectGetMaxY(lineRect) - LINE_HEIGHT, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - headerHeight - LINE_HEIGHT);
    self.contentView.frame = contentRect;
    
    
}

- (void)layoutSubviews {
    
    [self layoutItems];
    [super layoutSubviews];
}

@end
