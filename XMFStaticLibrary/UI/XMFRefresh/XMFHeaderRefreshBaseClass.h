//
//  XMFRefreshBaseClass.h
//  RefreshTest
//
//  Created by xumingfa on 16/7/20.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFRefreshConst.h"

@interface XMFHeaderRefreshBaseClass : NSObject

/// 允许拖动的最大距离
@property (nonatomic, assign) CGFloat dragOffset;

- (void)endRefreshWithHandle : (dispatch_block_t __nullable)handle;

- (void)startRefreshWithHandle : (dispatch_block_t __nullable)handle;

- (void)handleWithScrollView : (UIScrollView *__nonnull)scrollView EventWithAction : (XMFScrollViewHeaderAction __nullable) action;

@end
