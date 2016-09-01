//
//  XMFTagModel.h
//  XMFTagView
//
//  Created by xumingfa on 16/5/31.
//  Copyright © 2016年 ifunchat. All rights reserved.
//

#import "XMFTagHeaderModel.h"
#import "XMFTagContentModel.h"

@interface XMFTagModel : XMFTagHeaderModel

@property (nonatomic, strong) NSArray<XMFTagContentModel *> *tagContentAry;

@end
