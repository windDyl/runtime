//
//  NSObject+KeyValues.h
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ModelDelegate<NSObject>
@optional
+ (NSDictionary *)modelClassInArray;
@end

@interface NSObject (KeyValues)

+ (instancetype)objectWithKeyValues:(NSDictionary *)dictionary;
@end
