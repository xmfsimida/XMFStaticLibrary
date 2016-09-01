//
//  XMFTagContentModel.h
//  XMFTagView
//
//  Created by xumingfa on 16/5/30.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMFTagContentModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) int Id;

@property (nonatomic, assign) int groudId;

@end
