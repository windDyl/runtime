//
//  Father.m
//  DYRuntime
//
//  Created by Ethank on 16/9/1.
//  Copyright © 2016年 DY. All rights reserved.
//
#import "Father.h"
#import <objc/runtime.h>
#import <objc//message.h>

@implementation Father
//+ (void)load {
//    BOOL addSuccess = class_addMethod([Father class], @selector(alloc), class_getMethodImplementation([self class], @selector(printSay)), "v@:");
//    if (addSuccess) {
//        NSLog(@"添加方法成功");
//    } else {
//        NSLog(@"添加方法失败");
//        
//    }
//}
- (void)setName:(NSString *)yourName {
    _name = yourName;
    NSLog(@">>>>>>>>>>%@", yourName);
}
//添加一个方法
- (BOOL)addFunction {
        BOOL addSuccess = class_addMethod([Father class], @selector(setName:), class_getMethodImplementation([self class], @selector(printSay)), "v@:");
        return addSuccess;
}
- (void)printSay {
    NSLog(@"Hello, ni hao! I am in Father.---- printSay");
}
- (void)sayHello {
    NSLog(@"Hello, ni hao! I am in Father");
}
@end
