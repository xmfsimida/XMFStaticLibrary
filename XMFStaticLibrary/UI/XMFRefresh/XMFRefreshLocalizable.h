//
//  XMFRefreshLocalizable.h
//  RefreshTest
//
//  Created by xumingfa on 16/7/20.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMFRefreshLocalizable : NSObject

/*!
 获得系统当前语言
 */
+ (NSString * __nonnull)xmf_getDefaultLanguage;

/*!
 根据键获得对应的国际化字符串
 */
+ (NSString * __nullable)xmf_getLocalizableStringWithKey : (NSString * __nonnull)key;

/*!
 更改当前语言
 */
+ (void)xmf_changeLoacalizableWithNewLanguage : (NSString * __nonnull)newLanguage;

@end
