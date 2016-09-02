//
//  NSMutableArray+AddObject.m
//  DYRuntime
//
//  Created by Ethank on 16/9/1.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "NSMutableArray+AddObject.h"
#import <objc/objc-runtime.h>

@implementation NSMutableArray (AddObject)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        
        
        
    });
}


- (void)logAddObject:(id)object {
//    [self addObject:@"345"];
    NSLog(@"Add object: %@ to array: %@", object, self);
}
@end
