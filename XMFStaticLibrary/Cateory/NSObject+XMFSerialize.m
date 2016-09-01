//
//  NSObject+XMFSerialize.m
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/5/26.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "NSObject+XMFSerialize.h"
#import <objc/runtime.h>

@implementation NSObject (XMFSerialize)

- (void)xmf_decode:(NSCoder *)decoder {
    
    Class cs = [self class];
    while (cs != [NSObject class]) {
        BOOL isMySelf = (cs == [self class]);
        unsigned int varCount;
        unsigned int propertyCount;
        Ivar *vars = class_copyIvarList([self class], &varCount);
        objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
        NSString *key = nil;
        unsigned count = isMySelf ? varCount : propertyCount;
        for (int i = 0; i < count; i++) {
            const char *name = isMySelf ? ivar_getName(vars[i]) : property_getName(propertys[i]);
            key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [decoder decodeObjectForKey: key];
            if (!value) continue;
            [self setValue:value forKey:key];
        }
        free(vars);
        free(propertys);
        cs = class_getSuperclass(cs);
    }
}

- (void)xmf_encode:(NSCoder *)encoder {
    
    Class cs = [self class];
    while (cs != [NSObject class]) {
        BOOL isMyself = (cs == [self class]);
        unsigned int varsCount;
        unsigned int propertyCount;
        Ivar *vars = class_copyIvarList([self class], &varsCount);
        objc_property_t *propertys = class_copyPropertyList(cs, &propertyCount);
        NSString *key = nil;
        unsigned int count = isMyself ? varsCount : propertyCount;
        for (int i = 0; i < count; i ++) {
            const char *name = isMyself ? ivar_getName(vars[i]) : property_getName(propertys[i]);
            key = [NSString stringWithCString: name encoding:NSUTF8StringEncoding];
            id value = [self valueForKey: key];
            if (!value) continue;
            [encoder encodeObject:value forKey: key];
        }
        free(vars);
        free(propertys);
        cs = class_getSuperclass(cs);
    }
    
}

- (id)xmf_copyWithZone:(NSZone *)zone {
    
    Class cs = [self class];
    id oj;
    while (cs != [NSObject class]) {
        oj = [[cs allocWithZone:zone] init];
        BOOL isMyself = (cs == [self class]);
        unsigned int varsCount;
        unsigned int propertyCount;
        Ivar *vars = class_copyIvarList([self class], &varsCount);
        objc_property_t *propertys = class_copyPropertyList(cs, &propertyCount);
        NSString *key = nil;
        unsigned int count = isMyself ? varsCount : propertyCount;
        for (int i = 0; i < count; i++) {
            const char *name = isMyself ? ivar_getName(vars[i]) : property_getName(propertys[i]);
            key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [self valueForKey:key];
            [oj setValue:[value copy] forKey:key];
        }
        free(vars);
        free(propertys);
        cs = class_getSuperclass(cs);
    }
    return oj;

}

@end
