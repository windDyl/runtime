//
//  TestModel.h
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Model;
//1. 如果想要当前类可以实现归档与反归档，需要遵守一个协议NSCoding
@interface TestModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic) char isPerson;
@property (nonatomic, strong)NSURL *url;
@property (nonatomic, assign)unsigned int age;
@property (nonatomic, copy) NSNumber *phoneNumber;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) Model *son;
@property (nonatomic, strong) NSArray *icon;
@end
