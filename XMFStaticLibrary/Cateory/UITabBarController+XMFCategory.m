//
//  UITabBarController+XMFCategory.m
//  ChatDemo
//
//  Created by xumingfa on 16/4/14.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "UITabBarController+XMFCategory.h"

@implementation UITabBarController (XMFCategory)

- (void)xmf_setTitleFontSize:(CGFloat)size {
    
    for (UIBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont systemFontOfSize:size], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} forState:UIControlStateSelected];
    }
}

- (void)xmf_setItemSelectedImage : (UIImage *)image
          selectedTitleColor : (UIColor *)color
                   itemIndex : (NSUInteger)index {
    
    UIImage *img = image;
    img =  [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = self.tabBar.items[index];
    [item setSelectedImage:img];
    if (color) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : color}
                           forState : UIControlStateSelected];
    }
}


@end
