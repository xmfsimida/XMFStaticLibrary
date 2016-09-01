//
//  XMFLoadingButton.h
//  XMFLoadingButton
//
//  Created by xumingfa on 16/5/29.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XMFLoadingButtonStatus) {
    XMFLoadingButtonStatusNomarl = 0, // 普通状态
    XMFLoadingButtonStatusLoding  // 加载状态
};

@interface XMFLoadingButton : UIButton

@property (nonatomic, assign) XMFLoadingButtonStatus status;

/// 宽度(默认为5
@property (nonatomic, assign) CGFloat lineWidth;
/// 默认为红色
@property (nonatomic, strong, nullable) UIColor *loadingColor;

@end
