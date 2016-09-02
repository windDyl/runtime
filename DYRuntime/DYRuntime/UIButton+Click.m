//
//  UIButton+Click.m
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "UIButton+Click.h"
#import <objc/runtime.h>
#import <objc/message.h>
static const void * btnKey = "associated";
@implementation UIButton (Click)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        Method systemM = class_getInstanceMethod(cls, @selector(sendAction:to:forEvent:));
        Method customM = class_getInstanceMethod(cls, @selector(mySendAction:to:forEvent:));
        BOOL addSuccess = class_addMethod(cls, @selector(sendAction:to:forEvent:), method_getImplementation(customM), method_getTypeEncoding(customM));
        if (addSuccess) {
            class_replaceMethod(cls, @selector(mySendAction:to:forEvent:), method_getImplementation(systemM), method_getTypeEncoding(systemM));
        } else {
            method_exchangeImplementations(systemM, customM);
        }
        
    });
}
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"走了我自己定义的方法了");
    [self mySendAction:action to:target forEvent:event];
}
//一下是添加点击事件
-(void)setClick:(ClickBlock)click {
    objc_setAssociatedObject(self, btnKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (click) {
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(ClickBlock)click {
    return objc_getAssociatedObject(self, btnKey);
}
- (void)buttonClick {
    if (self.click) {
        self.click();
    }
}

@end
