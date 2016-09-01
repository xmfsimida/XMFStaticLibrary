//
//  XMFMPMoviePlayerViewController.m
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/8/25.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "XMFMPMoviePlayerViewController.h"

@implementation XMFMPMoviePlayerViewController

//当前viewcontroller默认的屏幕方向 - 横屏显示
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsLandscape(interfaceOrientation);
}

-(BOOL)shouldAutorotate{
    return YES;
}

@end
