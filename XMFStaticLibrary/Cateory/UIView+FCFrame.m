//
//  UIView+FCFrame.m
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/5/19.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "UIView+FCFrame.h"

@implementation UIView (FCFrame)

- (CGFloat)fc_minX {
    
    return CGRectGetMidX(self.frame);
}

- (void)setFc_minX:(CGFloat)fc_minX {
    
    CGRect frame = self.frame;
    frame.origin.x = fc_minX;
    self.frame = frame;
}

- (CGFloat)fc_midX {
    
    return CGRectGetMidX(self.frame);
}

- (CGFloat)fc_maxX {
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)fc_minY {
    
    return CGRectGetMidY(self.frame);
}

- (void)setFc_minY:(CGFloat)fc_minY {
    
    CGRect frame = self.frame;
    frame.origin.y = fc_minY;
    self.frame = frame;
}

- (CGFloat)fc_midY {
    
    return CGRectGetMidY(self.frame);
}

- (CGFloat)fc_maxY {
    
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)fc_width {
    
    return CGRectGetWidth(self.frame);
}

- (void)setFc_width:(CGFloat)fc_width {
    
    CGRect frame = self.frame;
    frame.size.width = fc_width;
    self.frame = frame;
}

- (CGFloat)fc_height {
    
    return CGRectGetHeight(self.frame);
}

- (void)setFc_height:(CGFloat)fc_height {
 
    CGRect frame = self.frame;
    frame.size.height = fc_height;
    self.frame = frame;
}

- (CGFloat)fc_centerX {
    return self.center.x;
}

- (void)setFc_centerX:(CGFloat)fc_centerX {
    
    self.center = CGPointMake(fc_centerX, self.center.y);
}

- (CGFloat)fc_centerY {
    return self.center.y;
}

- (void)setFc_centerY:(CGFloat)fc_centerY {
    self.center = CGPointMake(self.center.x, fc_centerY);
}


@end
