//
//  XMFTagButton.m
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/5/31.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFTagButton.h"
#import "UIView+XMFCategory.h"
#import "XMFTagBase.h"

@implementation XMFTagButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (UIColor *)normalBackgroundColor {
    
    if (_normalBackgroundColor) return _normalBackgroundColor;
    return [UIColor whiteColor];
}

- (UIColor *)selectedBackgroundColor {
    
    if (_selectedBackgroundColor) return _selectedBackgroundColor;
    return TAG_RED;
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        if (self.needRadius) {
            self.layer.borderWidth = 0.f;
        };
        self.backgroundColor =  self.selectedBackgroundColor;
    }
    else {
        if (self.needRadius) {
            self.layer.borderWidth = 0.5f;
        };
        self.backgroundColor = self.normalBackgroundColor;
    }
    [super setSelected:selected];
}


@end
