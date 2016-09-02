//
//  UIButton+Click.h
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock)();
@interface UIButton (Click)
@property (nonatomic, copy)ClickBlock click;
@end
