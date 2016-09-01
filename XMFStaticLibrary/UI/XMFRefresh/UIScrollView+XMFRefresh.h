//
//  UIScrollView+Touch.h
//  CoolCar2.0
//
//  Created by xumingfa on 15/12/19.
//  Copyright © 2015年 cars-link. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMFRefreshNormalHeaderView;
@class XMFRefreshAutoFooterView;

@interface UIScrollView (XMFRefresh)

@property (nonatomic, weak, readonly, nullable) XMFRefreshNormalHeaderView *xmf_header;

@property (nonatomic, weak, readonly, nullable) XMFRefreshAutoFooterView *xmf_footer;

@end