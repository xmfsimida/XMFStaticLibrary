//
//  UIView+FCFrame.h
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/5/19.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FCFrame)

@property (nonatomic, assign) CGFloat fc_minX;

@property (nonatomic, assign, readonly) CGFloat fc_midX;

@property (nonatomic, assign, readonly) CGFloat fc_maxX;

@property (nonatomic, assign) CGFloat fc_minY;

@property (nonatomic, assign, readonly) CGFloat fc_midY;

@property (nonatomic, assign, readonly) CGFloat fc_maxY;

@property (nonatomic, assign) CGFloat fc_width;

@property (nonatomic, assign) CGFloat fc_height;

@property (nonatomic) CGFloat fc_centerX;

@property (nonatomic) CGFloat fc_centerY;

@end
