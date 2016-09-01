//
//  XMFTagHeaderModel.h
//  XMFTagView
//
//  Created by xumingfa on 16/5/30.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMFTagHeaderModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) NSInteger Id;

@end
