//
//  XMFStarView.h
//  XMFStarView
//
//  Created by xumingfa on 16/7/5.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMFStarView : UIView

/// 前景图
@property (nonatomic, strong, nonnull) IBInspectable UIImage *hightlightImage;

/// 背景图
@property (nonatomic, strong, nonnull) IBInspectable UIImage *normalImage;

/// 当前星星数量
@property (nonatomic, assign, getter=isStarValue) IBInspectable NSUInteger starValue; // 最大为5

/// 是否可以改变
@property (nonatomic, assign, getter=isChange) IBInspectable BOOL change;

@end
