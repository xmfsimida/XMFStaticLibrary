//
//  XMFRefreshLocalizable.m
//  RefreshTest
//
//  Created by xumingfa on 16/7/20.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFRefreshLocalizable.h"
#import <UIKit/UIKit.h>

@implementation XMFRefreshLocalizable

static NSString *_newLanguage = nil;

+ (void)xmf_changeLoacalizableWithNewLanguage:(NSString *)newLanguage {
 
    _newLanguage = newLanguage;
}

+ (NSString *)xmf_getDefaultLanguage {
    
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        NSRange range = [language rangeOfString:@"-" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            language = [language substringToIndex:range.location];
        }
    }
    if (language.length == 0) {
        language = @"en";
    }
    return language;
}

+ (NSString *)xmf_getLocalizableStringWithKey:(NSString *)key {
    
    NSString *language = _newLanguage ? _newLanguage : [XMFRefreshLocalizable xmf_getDefaultLanguage];
    return [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"XMFRefresh.bundle/%@", language] ofType:@"lproj"]] localizedStringForKey:key value:nil table:@"Localizable"];
}

@end
