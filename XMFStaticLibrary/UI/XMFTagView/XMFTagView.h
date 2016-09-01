//
//  XMFTagView.h
//  XMFTagView
//
//  Created by xumingfa on 16/5/31.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMFTagModel;

@interface XMFTagView : UIView

@property (nonatomic, strong) NSArray <XMFTagModel *> *datas;

@property (nonatomic, strong) UIImage *topMoreImage;

@property (nonatomic, strong) UIImage *bottomMoreImage;

@end
