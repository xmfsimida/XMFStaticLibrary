//
//  HeaderColumView.h
//  MaskDemo
//
//  Created by xumingfa on 16/2/29.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XMFSegmentViewBlock)(NSUInteger index);

typedef NS_ENUM(NSInteger, XMFSegmentViewStyle) {
    XMFSegmentViewStyleLine, // 指示线
    XMFSegmentViewStyleNoodles //   指示面
    
};

@class XMFSegmentView;

@protocol XMFSegmentViewDelegate <NSObject>

@optional
//  点击按事件
- (void)segmentView:(XMFSegmentView * _Nonnull)segmentView didSelectItemsAtIndex: (NSUInteger) index;

@end

@interface XMFSegmentView : UIView

@property (nonatomic, strong, null_resettable) NSArray<NSString *> *titleAry; // 标题数据

@property (nonatomic, strong, null_resettable) UIColor *instructionsColor; // 指示颜色

@property (nonatomic, strong, null_resettable) UIColor *fontNormalColor; // 普通状态颜色

@property (nonatomic, strong, null_resettable) UIColor *fontSelectedColor; // 高亮颜色和已选择颜色

@property (nonatomic, weak, nullable) id<XMFSegmentViewDelegate> delegate;

@property (nonatomic, assign) XMFSegmentViewStyle style;

+ (instancetype _Nonnull)createColumViewWithDefaultIndex : (NSUInteger) index;

- (void)didSelectWithHandler : (XMFSegmentViewBlock _Nullable) handler;

- (void)moveToHighlightWithPX : (CGFloat) px; // 移动指示器

- (void)reloadData; // 设置数据

@end
