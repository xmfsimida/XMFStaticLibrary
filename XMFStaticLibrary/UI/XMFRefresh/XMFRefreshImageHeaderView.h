//
//  XMFRefreshImageHeaderView.h
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/8/9.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFRefreshConst.h"
@class XMFHeaderRefreshBaseClass;

@interface XMFRefreshImageHeaderView : UIView

- (void)headerRefresh: (RefreshAction _Nullable) action;

- (void)endRefreshing;

- (void)setImage : (UIImage * _Nullable)image withStatus : (XMFRefreshStatus)status;

- (void)removeAllObservers;

@end
