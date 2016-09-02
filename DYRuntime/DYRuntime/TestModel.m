//
//  TestModel.m
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "TestModel.h"
#import "Model.h"
#import "NSObject+KeyValues.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation TestModel
+ (NSDictionary *)modelClassInArray {
    return @{
             @"icon":[Model class]
             };
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        unsigned count = 0;
        Ivar * ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char * name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"--%@--%@--%c--%@--%u--%@--%f--%@--%@--%@", _name, _sex, _isPerson, _url, _age, _phoneNumber, _height, _info, _son, _icon];
}
@end
