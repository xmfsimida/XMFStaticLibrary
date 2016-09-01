//
//  NSObject+XMFSerialize.h
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/5/26.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XMFSerialize)

/*!
  解码
 */
- (void)xmf_decode:(NSCoder *)decoder;
/*!
  编码
 */
- (void)xmf_encode:(NSCoder *)encoder;

/*!
 深拷贝
 */
- (id)xmf_copyWithZone : (NSZone *)zone;

#define XMF_CODING() \
- (instancetype)initWithCoder:(NSCoder *)aDecoder { \
self = [super init]; \
[self xmf_decode:aDecoder]; \
return self; \
} \
- (void)encodeWithCoder:(NSCoder *)coder    \
{   \
[self xmf_encode:coder];\
}   \


#define XMF_COPY()   \
- (id)copyWithZone:(NSZone *)zone { \
return [self xmf_copyWithZone:zone];\
}   \


@end
