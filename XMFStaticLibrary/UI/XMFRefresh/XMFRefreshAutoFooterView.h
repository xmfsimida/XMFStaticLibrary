//
//  RefreshFooterView.h
//  CoolCar2.0
//
//  Created by xumingfa on 15/12/23.
//  Copyright © 2015年 cars-link. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFRefreshConst.h"
@class XMFFooterRefreshBaseClass;

@interface XMFRefreshAutoFooterView : UIView

@property (nonatomic, assign, getter=isNoMoreData) BOOL noMoreData;

@property (nonatomic, strong, null_resettable) UIColor *tipsColor;

- (void)footerRefresh: (RefreshAction _Nullable)action;

- (void)endRefreshing;

- (void)removeAllObservers;


@end
