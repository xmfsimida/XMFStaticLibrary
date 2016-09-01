//
//  XMFFooterRefreshBaseClass.h
//  RefreshTest
//
//  Created by xumingfa on 16/7/20.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFRefreshConst.h"

@interface XMFFooterRefreshBaseClass : NSObject

/// 允许拖动的最大距离
@property (nonatomic, assign) CGFloat dragOffset;
/// 状态
@property (nonatomic, assign) XMFRefreshStatus refreshStatus;

- (void)endRefreshWithHandle : (dispatch_block_t __nullable)handle;

- (void)startRefreshWithHandle : (dispatch_block_t __nullable)handle;

- (void)handleWithScrollView : (UIScrollView *__nonnull)scrollView autoRefresh : (BOOL)autoRefresh EventWithAction : (XMFScrollViewFooterAction __nullable) action contentInsetChange : (XMFScrollViewFooterContentInsetChangeAction __nullable)contentInsetChangeAction;
@end
