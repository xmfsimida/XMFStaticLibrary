//
//  XMFTagHeaderView.h
//  XMFTagView
//
//  Created by xumingfa on 16/5/30.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMFTagHeaderModel.h"

typedef void(^XMFTagHeaderViewAction)(NSUInteger index);

typedef NS_ENUM(NSInteger, XMFTagHeadertType) {
    
    XMFTagHeaderTypeNormal = 0, // 普通模式
    XMFTagHeaderTypeSelect  // 选择模式
};

@protocol XMFTagHeaderViewDelegate;

@interface XMFTagHeaderView : UIView

@property (nonatomic, strong, nullable) NSArray<XMFTagHeaderModel *> *titleAry;

@property (nonatomic, assign) XMFTagHeadertType type; // 类型

@property (nonatomic, strong, nullable) UIColor *hightlightColor; // 默认红色

@property (nonatomic, strong, nullable) UIColor *normalColor; // 默认灰色

@property (nonatomic, strong, nullable) UIColor *itembackgroundColor; // 默认白色

@property (nonatomic, strong, nullable) UIColor *selectedBackgroundColor; // 默认红色

@property (nonatomic, strong, nullable) UIColor *moreBackgroundColor; // 默认白色

@property (nonatomic, assign, getter=isNotNeedRadius) BOOL notNeedRadius; // 是否需要边框

@property (nonatomic, strong, nullable) UIImage *moreImage;

@property (nonatomic, weak, nullable) id<XMFTagHeaderViewDelegate> delegate;

@property (nonatomic, assign) CGFloat hPadding; // 左右边距

@property (nonatomic, assign) CGFloat vPadding; // 上下边距 不能大于高度的一半

- (void)pushItemWithAction : (XMFTagHeaderViewAction __nullable)action;

@end

@protocol XMFTagHeaderViewDelegate <NSObject>

@optional
- (void)tagHeaderView : (XMFTagHeaderView *__nonnull)headerView pushItemWithIndex : (NSUInteger)Index;

@end
