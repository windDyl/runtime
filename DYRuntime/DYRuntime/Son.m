//
//  Son.m
//  DYRuntime
//
//  Created by Ethank on 16/9/1.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "Son.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Son
+ (void)load {
    Method dogM = class_getInstanceMethod([self class], @selector(printDag));
    Method catM = class_getInstanceMethod([self class], @selector(printCat));
    method_exchangeImplementations(dogM, catM);
}
- (void)setName:(NSString *)yourName andAge:(NSUInteger)age {
    [self setAge:age];
    [super setName:yourName];
    NSLog(@"%@------%@", [self class], [super class]);
    NSLog(@"%@=========",self->_name);
}
- (void)setAge:(NSUInteger)age {
    _age = age;
}
- (void)printDag {
    NSLog(@"I am a dog");
}
- (void)printCat {
    NSLog(@"I am a cat");
}
@end
