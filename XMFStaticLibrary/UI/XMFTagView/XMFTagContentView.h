//
//  XMFTagContentView.h
//  XMFTagView
//
//  Created by xumingfa on 16/5/30.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMFTagContentModel;

typedef void(^XMFTagContentViewAction)(NSUInteger index);

@protocol XMFTagContentViewDelegate;

@interface XMFTagContentView : UIView

@property (nonatomic, strong, nullable) NSArray<XMFTagContentModel *> *contentAry;

@property (nonatomic, strong, nullable) UIColor *hightlightColor; // 默认白色

@property (nonatomic, strong, nullable) UIColor *normalColor; // 默认灰色

@property (nonatomic, strong, nullable) UIColor *itembackgroundColor; // 默认白色

@property (nonatomic, strong, nullable) UIColor *moreBackgroundColor; // 默认白色

@property (nonatomic, strong, nullable) UIImage *moreImage;

@property (nonatomic, assign) CGFloat hPadding; // 左右边距

@property (nonatomic, assign) CGFloat vPadding; // 上下边距 

@property (nonatomic, assign, getter=isRadioMode) BOOL radioMode; // 是否单选模式 （默认多选模式）

@property (nonatomic, assign, nullable) id<XMFTagContentViewDelegate> delegate;

- (void)pushItemWithAction : (XMFTagContentViewAction __nullable)action;

/*!
 清楚缓存
 */
- (void)clearCache;

@end

@protocol XMFTagContentViewDelegate <NSObject>

@optional
- (void)tagContentView : (XMFTagContentView *__nonnull)contentView pushItemWithTag : (NSUInteger)tag;

@end
