//
//  UIButton+XMFCategory.h
//  CornerTest
//
//  Created by xumingfa on 16/7/26.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XMFCategory)

#warning 不要在layoutSubviews中使用
///  添加蒙版圆角
@property (nonatomic, assign) IBInspectable CGFloat xmf_buttonMaskCornerRadius;


@end
