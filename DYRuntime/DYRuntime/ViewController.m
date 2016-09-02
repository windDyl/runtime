//
//  ViewController.m
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Click.h"
#import "NSObject+KeyValues.h"

#import "TestModel.h"
#import "Model.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "NSMutableArray+AddObject.h"

#import "Son.h"
#import "Father.h"
#import "GradeFather.h"

@interface ViewController ()
@property (nonatomic, strong)NSDictionary *dictionary;
@end

@implementation ViewController

- (NSDictionary *)dictionary {
    if (!_dictionary) {
        _dictionary = @{
                       @"name":@"Dave Ping",
                       @"sex":@"n",
                       @"url":@"http://www.baidu.com",
                       @"age":@24.0,
                       @"phoneNumber":@18718871111,
                       @"height":@180.5,
                       @"isPerson":@"true",
                       @"info":@{
                                    @"address":@"BeiJing",
                               },
                       @"son":@{
                                    @"name":@"Jack",
                                    @"info":@{
                                                @"address":@"London",
                                             },
                               },
                       @"icon":@[
                               @{
                                   @"name":@"Janne",
                                   @"info":@{
                                           @"address":@"Lcondon"
                                           }
                                   },
                               @{
                                   @"name":@"jackSon",
                                   @"info":@{
                                           @"address":@"12432r34t"
                                           }
                                   }
                               ]
                       };
    }
    return _dictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testButtonClick];
//    [self testKeyValues];
//    [self testMutableArray];
//    [self test];
//    [self changeFatherClassInstanceOfName];
    [self addFunction];
//    [self exchangeFunctionImplation];
//    [self interceptAndexchangFunctionImplation];
}
//button click事件
- (void)testButtonClick {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.view.bounds;
    [self.view addSubview:button];
    button.click = ^ {
        NSLog(@"hello, click button...");
    };
}
//字典转模型
- (void)testKeyValues {
    TestModel *model = [TestModel objectWithKeyValues:self.dictionary];
    NSLog(@"name = %@\nage = %u\nisPerson = %d\nsex = %@\nson.name = %@\nicon = %@", model.name, model.age, model.isPerson, model.sex, model.son.name, model.icon);
}

- (void)testMutableArray {
    NSMutableArray *mutA = [NSMutableArray array];
    [mutA addObject:@"123"];
    NSLog(@"=======%@==", mutA);
}

//测试 【self class】和【supper class】
- (void)test {
    Father *father = [[Father alloc] init];
    Son * son = [[Son alloc] init];
    [son setName:@"aaa" andAge:18];
    NSLog(@"%@", father->_name);
    
}
//动态改变变量的值
- (void)exchangeFatherClassInstanceOfName {
    Father *father = [[Father alloc] init];
    father->_name = @"123";
    NSLog(@"---%@", father->_name);
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([Father class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[0];
        const char * name = ivar_getName(ivar);
        NSString *ocName = [NSString stringWithUTF8String:name];
        if ([ocName isEqualToString:@"_name"]) {
            object_setIvar(father, ivar, @"321");
            break;
        }
    }
    NSLog(@"===%@", father->_name);
}
//动态添加方法
- (void)addFunction {
    Father *father = [[Father alloc] init];
    [father setName:@"123"];
    [father performSelector:@selector(printSay)];
    NSLog(@"%@", father->_name);
}
//动态交换方法的实现
- (void)exchangeFunctionImplation {
    Method fm = class_getInstanceMethod([Father class], @selector(sayHello));
    Method gm = class_getInstanceMethod([GradeFather class], @selector(say));
    method_exchangeImplementations(fm, gm);
    [[[Father alloc] init] sayHello];
}
//拦截并动态交换方法的实现
- (void)interceptAndexchangFunctionImplation {
    Son *son = [[Son alloc] init];
    [son printCat];
}

@end
