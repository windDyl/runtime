//
//  NSObject+KeyValues.m
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "NSObject+KeyValues.h"
#import <objc/objc-runtime.h>
/**
 *  成员变量类型（属性类型）
 */
NSString *const DYPropertyTypeInt = @"i";
NSString *const DYPropertyTypeShort = @"s";
NSString *const DYPropertyTypeFloat = @"f";
NSString *const DYPropertyTypeDouble = @"d";
NSString *const DYPropertyTypeLong = @"l";
NSString *const DYPropertyTypeLongLong = @"q";
NSString *const DYPropertyTypeChar = @"c";
NSString *const DYPropertyTypeBOOL1 = @"c";
NSString *const DYPropertyTypeBOOL2 = @"b";
NSString *const DYPropertyTypePointer = @"*";

NSString *const DYPropertyTypeIvar = @"^{objc_ivar=}";
NSString *const DYPropertyTypeMethod = @"^{objc_method=}";
NSString *const DYPropertyTypeBlock = @"@?";
NSString *const DYPropertyTypeClass = @"#";
NSString *const DYPropertyTypeSEL = @":";
NSString *const DYPropertyTypeId = @"@";

@implementation NSObject (KeyValues)
+ (instancetype)objectWithKeyValues:(NSDictionary *)dictionary {
    id objc = [[self alloc] init];
//    [self theCoreCode_first:dictionary idObject:objc];
    [self theCoreCode_second:dictionary idObject:objc];
    return objc;
}
//function 1
+ (void)theCoreCode_first:(NSDictionary *)dictionary idObject:(id)objc {
    unsigned int count = 0;
    //取出成员属性
    Ivar * ivars = class_copyIvarList([objc class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        //取出成员属性名字
        const char * name = ivar_getName(ivar);
        //取出成员属性类型
        const char * type = ivar_getTypeEncoding(ivar);
        //将成员属性类型转换成OC类型
        NSString *ocType = [NSString stringWithUTF8String:type];
        //将成员属性名字转换成OC类型
        NSString *instance = [NSString stringWithUTF8String:name];
        //根据成员属性名字获取字典的key
        NSString *key = [instance substringFromIndex:1];
        //通过字典的key获取值
        id value = dictionary[key];
        if (!value || value == [NSNull null]) continue;
        //如果字典中嵌套有其他model
        if ([value isKindOfClass:[NSDictionary class]] && [ocType rangeOfString:@"NS"].location == NSNotFound) {
            //一下几行代码是获取嵌套模型声明的类型
            ocType = [ocType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            ocType = [ocType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSLog(@"%@", NSClassFromString(ocType));
            Class modalClass = NSClassFromString(ocType);
            if (modalClass) {//将嵌套的字典转换成模型
                value = [modalClass objectWithKeyValues:value];
            }
        }
        //如果数组中嵌套有其他model
        if ([value isKindOfClass:[NSArray class]]) {
            //如果数组中嵌套的model实现了类的映射
            if ([self respondsToSelector:@selector(modelClassInArray)]) {
                id idSelf = self;
                //获取数组中元素的类名，并将各元素转换成模型
                Class modalClass = [idSelf modelClassInArray][key];
                NSMutableArray *arrayM = [NSMutableArray array];
                for (NSDictionary *dic in value) {
                    id model = [modalClass objectWithKeyValues:dic];
                    [arrayM addObject:model];
                }
                //将盛放转换模型的数组赋值给value
                value = arrayM;
            }
        }
        //一下几行代码是生成setter的方法并向其发送消息
        NSString *methodStr = [NSString stringWithFormat:@"set%@%@:", [key substringToIndex:1].uppercaseString, [key substringFromIndex:1]];
        SEL setter = sel_registerName(methodStr.UTF8String);
        if ([objc respondsToSelector:setter]) {
            NSArray *numbers = @[DYPropertyTypeInt, DYPropertyTypeShort, DYPropertyTypeFloat, DYPropertyTypeDouble, DYPropertyTypeLong, DYPropertyTypeLongLong, DYPropertyTypeChar, DYPropertyTypeBOOL1, DYPropertyTypeBOOL2, DYPropertyTypePointer];
            if ([numbers containsObject:ocType.lowercaseString]) {
                if ([ocType.lowercaseString isEqualToString:DYPropertyTypeInt]) {
                    ((void (*) (id,SEL,int)) objc_msgSend) (objc,setter,[value intValue]);
                } else if ([ocType.lowercaseString isEqualToString:DYPropertyTypeShort]) {
                    ((void (*) (id,SEL,short)) objc_msgSend) (objc,setter,[value shortValue]);
                } else if([ocType.lowercaseString isEqualToString:DYPropertyTypeFloat]) {
                    ((void (*) (id,SEL,float)) objc_msgSend) (objc,setter,[value floatValue]);
                } else if([ocType.lowercaseString isEqualToString:DYPropertyTypeDouble]) {
                    ((void (*) (id,SEL,double)) objc_msgSend) (objc,setter,[value doubleValue]);
                } else if ([ocType.lowercaseString isEqualToString:DYPropertyTypeLong]) {
                    ((void (*) (id,SEL,long)) objc_msgSend) (objc,setter,[value longValue]);
                } else if([ocType.lowercaseString isEqualToString:DYPropertyTypeLongLong]) {
                    ((void (*) (id,SEL,long long)) objc_msgSend) (objc,setter,[value longLongValue]);
                }
                else if ([ocType.lowercaseString isEqualToString:DYPropertyTypeChar]) {
                    if ([value isEqualToString:@"yes"] || [value isEqualToString:@"true"]) {
                        value = @YES;
                        ((void (*) (id,SEL,BOOL)) objc_msgSend) (objc,setter,[value boolValue]);
                    } else if ([value isEqualToString:@"no"] || [value isEqualToString:@"false"]) {
                        value = @NO;
                        ((void (*) (id,SEL,BOOL)) objc_msgSend) (objc,setter,[value boolValue]);
                    } else {
                        //char类型转换 ???
                        ((void (*) (id,SEL,id)) objc_msgSend) (objc,setter,value);
                    }
                } else if([ocType.lowercaseString isEqualToString:DYPropertyTypeBOOL2]) {//[ocType.lowercaseString
                    ((void (*) (id,SEL,BOOL)) objc_msgSend) (objc,setter,[value boolValue]);
                }
            } else {
                ((void (*) (id,SEL,id)) objc_msgSend) (objc,setter,value);
            }
        }
    }
    free(ivars);
}
//function 2
+ (void)theCoreCode_second:(NSDictionary *)dictionary idObject:(id)objc {
    unsigned int count = 0;
    objc_property_t * propertyList = class_copyPropertyList([objc class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        char const * name = property_getName(property);
        char const * type = property_getAttributes(property);
        NSString *ocName = [NSString stringWithUTF8String:name];
        NSString *ocType = [NSString stringWithUTF8String:type];
        ocType = [[ocType componentsSeparatedByString:@","] firstObject];
        ocType = [ocType substringFromIndex:1];
        id value = dictionary[ocName];
        //如果字典中嵌套有其他model
        if ([value isKindOfClass:[NSDictionary class]] && [ocType rangeOfString:@"NS"].location == NSNotFound) {
            //一下几行代码是获取嵌套模型声明的类型
            ocType = [ocType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            ocType = [ocType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            Class modalClass = NSClassFromString(ocType);
            if (modalClass) {//将嵌套的字典转换成模型
                value = [modalClass objectWithKeyValues:value];
            }
        }
        //如果数组中嵌套有其他model
        if ([value isKindOfClass:[NSArray class]]) {
            //如果数组中嵌套的model实现了类的映射
            if ([self respondsToSelector:@selector(modelClassInArray)]) {
                id idSelf = self;
                //获取数组中元素的类名，并将各元素转换成模型
                Class modalClass = [idSelf modelClassInArray][ocName];
                NSMutableArray *arrayM = [NSMutableArray array];
                for (NSDictionary *dic in value) {
                    id model = [modalClass objectWithKeyValues:dic];
                    [arrayM addObject:model];
                }
                //将盛放转换模型的数组赋值给value
                value = arrayM;
            }
        }
        //一下几行代码是生成setter的方法并向其发送消息
        NSString *methodStr = [NSString stringWithFormat:@"set%@%@:", [ocName substringToIndex:1].uppercaseString, [ocName substringFromIndex:1]];
        SEL setter = sel_registerName(methodStr.UTF8String);
        if ([objc respondsToSelector:setter]) {
            NSArray *numbers = @[DYPropertyTypeInt, DYPropertyTypeShort, DYPropertyTypeFloat, DYPropertyTypeDouble, DYPropertyTypeLong, DYPropertyTypeLongLong, DYPropertyTypeChar, DYPropertyTypeBOOL1, DYPropertyTypeBOOL2, DYPropertyTypePointer];
            if ([numbers containsObject:ocType.lowercaseString]) {
                if ([ocType.lowercaseString isEqualToString:DYPropertyTypeInt]) {
                    ((void (*) (id,SEL,int)) objc_msgSend) (objc,setter,[value intValue]);
                } else if ([ocType.lowercaseString isEqualToString:DYPropertyTypeShort]) {
                    ((void (*) (id,SEL,short)) objc_msgSend) (objc,setter,[value shortValue]);
                } else if([ocType.lowercaseString isEqualToString:DYPropertyTypeFloat]) {
                    ((void (*) (id,SEL,float)) objc_msgSend) (objc,setter,[value floatValue]);
                } else if([ocType.lowercaseString isEqualToString:DYPropertyTypeDouble]) {
                    ((void (*) (id,SEL,double)) objc_msgSend) (objc,setter,[value doubleValue]);
                } else if ([ocType.lowercaseString isEqualToString:DYPropertyTypeLong]) {
                    ((void (*) (id,SEL,long)) objc_msgSend) (objc,setter,[value longValue]);
                } else if([ocType.lowercaseString isEqualToString:DYPropertyTypeLongLong]) {
                    ((void (*) (id,SEL,long long)) objc_msgSend) (objc,setter,[value longLongValue]);
                }
                else if ([ocType.lowercaseString isEqualToString:DYPropertyTypeChar]) {
                    if ([value isEqualToString:@"yes"] || [value isEqualToString:@"true"]) {
                        value = @YES;
                        ((void (*) (id,SEL,BOOL)) objc_msgSend) (objc,setter,[value boolValue]);
                    } else if ([value isEqualToString:@"no"] || [value isEqualToString:@"false"]) {
                        value = @NO;
                        ((void (*) (id,SEL,BOOL)) objc_msgSend) (objc,setter,[value boolValue]);
                    } else {
                        //char类型转换 ???
                        ((void (*) (id,SEL,id)) objc_msgSend) (objc,setter,value);
                    }
                } else if([ocType.lowercaseString isEqualToString:DYPropertyTypeBOOL2]) {//[ocType.lowercaseString
                    ((void (*) (id,SEL,BOOL)) objc_msgSend) (objc,setter,[value boolValue]);
                }
            } else {
                ((void (*) (id,SEL,id)) objc_msgSend) (objc,setter,value);
            }
        }
    }
    free(propertyList);
}
@end
