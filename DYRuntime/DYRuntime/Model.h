//
//  Model.h
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import <Foundation/Foundation.h>
//1. 如果想要当前类可以实现归档与反归档，需要遵守一个协议NSCoding
@interface Model : NSObject<NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, copy) NSNumber *phoneNumber;
@property (nonatomic, copy) NSNumber *height;
@property (nonatomic, strong) NSDictionary *info;
@end
