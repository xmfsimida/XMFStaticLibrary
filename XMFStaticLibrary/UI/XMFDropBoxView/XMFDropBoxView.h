//
//  XMFDropBoxView.h
//  XBJob
//
//  Created by kk on 15/11/13.
//  Copyright © 2015年 cnmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMFDropBoxView;

typedef void(^ActionBlock)(NSUInteger index);

@protocol XMFDropBoxViewDataSource <NSObject>

@required
/*!
 分配每行的item
 */
- (UIView *_Nonnull)dropBoxView : (XMFDropBoxView *_Nonnull)dropBoxView itemAtIndex : (NSUInteger)index;

/*!
 每行item的高度
 */
- (CGFloat)dropBoxView:(XMFDropBoxView *_Nonnull)dropBoxView heightForItemAtIndex:(NSUInteger)index;

/*!
 一共item数量
 */
- (NSUInteger)numberOfItemInDropBoxView : (XMFDropBoxView *_Nonnull)dropBoxView;

/*!
 view的宽度
 */
- (CGFloat)widthInDropBoxView:(XMFDropBoxView *_Nonnull)dropBoxView;

@end

@interface XMFDropBoxView : UIView

@property (nonatomic, assign, nonnull) id<XMFDropBoxViewDataSource>  dataSource;

@property (nonatomic, strong, readonly, nonnull) UIColor *backgroundColor;

// 定位的view
@property (nonatomic, weak, nullable) __kindof UIView * locationView;

// 设置backgroundColor (默认为white)
@property (nonatomic, strong, nonnull) UIColor *contentColor;

/*!
 data数据 
 view通过view的坐标确定控件的位置
 */
+ (instancetype _Nonnull)dropBoxWithLocationView : (__kindof UIView * _Nonnull) locationView dataSource: (id<XMFDropBoxViewDataSource> _Nonnull) dataSource;

/*!
 点击事件
 */
- (void)selectItemWithBlock : (_Nullable ActionBlock)handle;

/*
 显示下拉框
 */
- (void)displayDropBox;


@end
