//
//  XMFBaseBadge.h
//  XMFBadgeView
//
//  Created by xumingfa on 16/6/2.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XMFBadgePositionStyle) {
    
    XMFBadgePositionStyleTopLeft, // 左上角
    XMFBadgePositionStyleTopRight, // 右上角
    XMFBadgePositionStyleBottomLeft, // 左下角
    XMFBadgePositionStyleBottomRight, // 右下角
    XMFBadgePositionStyleCenter // 中心
};

@interface XMFBaseBadge : UIView

@property (nonatomic, assign) XMFBadgePositionStyle style;

- (__kindof UIView * __nonnull)loadSubView;

@end
