//
//  Father.h
//  DYRuntime
//
//  Created by Ethank on 16/9/1.
//  Copyright © 2016年 DY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Father : NSObject
{
    @public
    NSString * _name;
}
- (void)setName:(NSString *)yourName;
- (BOOL)addFunction;
- (void)sayHello;
@end
