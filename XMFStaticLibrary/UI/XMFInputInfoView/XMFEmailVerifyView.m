//
//  XMFEmailVerifyView.m
//  ChatDemo
//
//  Created by xumingfa on 16/4/13.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFEmailVerifyView.h"

@implementation XMFEmailVerifyView

- (instancetype)init
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XMFEmailVerifyView" owner:nil options:nil] lastObject];
}

+ (CGFloat)getHeight {
    return 60.f;
}

@end
