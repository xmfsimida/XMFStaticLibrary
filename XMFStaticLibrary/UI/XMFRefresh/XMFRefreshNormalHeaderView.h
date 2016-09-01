//
//  SupView.h
//  ScrollViewTest
//
//  Created by xumingfa on 15/12/19.
//  Copyright © 2015年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFRefreshConst.h"
@class XMFHeaderRefreshBaseClass;

@interface XMFRefreshNormalHeaderView : UIView

@property (nonatomic, strong, null_resettable) UIColor *tipsColor;

@property (nonatomic, strong, nullable) UIImage *instructionsImage;

- (void)headerRefresh: (RefreshAction _Nullable) action;

- (void)endRefreshing ;

- (void)removeAllObservers;

@end
