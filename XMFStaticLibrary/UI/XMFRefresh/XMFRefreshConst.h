//
//  XMFRefreshConst.h
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/7/21.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

//  图片路径
#define XMF_REFRESH_IMAGE_PATH(imageName) [NSString stringWithFormat:@"XMFRefresh.bundle/Images/%@", imageName]

//  提示字体的颜色
#define XMF_REFRESH_TIPS_COLOR [UIColor darkTextColor]

//  底部颜色
#define XMF_REFRESH_VIWE_COLOR [UIColor clearColor];

//  国际化
#import "XMFRefreshLocalizable.h"
#define XMF_REFRESH_LOCALIZABLE(key) \
[XMFRefreshLocalizable xmf_getLocalizableStringWithKey:key]


extern NSString *const XMF_REFRESH_CONTENTOFFSET_KEY;
extern NSString *const XMF_REFRESH_CONTENTSIZE_KEY;


#define XMF_REFRESH_WEAK_SELF \
__weak typeof(self) weakSelf = self;


typedef void (^RefreshAction) ();

typedef NS_ENUM(NSInteger, XMFRefreshStatus) {
    XMFRefreshStatusNormal, // 正常状态
    XMFRefreshStatusPrepareStart, // 准备刷新
    XMFRefreshStatusExecuting, // 正在刷新
    XMFRefreshStatusPrepareEnd, // 准备结束
};

typedef void(^XMFScrollViewHeaderAction)(XMFRefreshStatus status, CGPoint contentOffset);

typedef void(^XMFScrollViewFooterAction)(XMFRefreshStatus status, CGPoint contentOffset);

typedef void(^XMFScrollViewFooterContentInsetChangeAction)(UIEdgeInsets contentInset, BOOL isChange);
