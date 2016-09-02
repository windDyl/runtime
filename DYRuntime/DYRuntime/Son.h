//
//  Son.h
//  DYRuntime
//
//  Created by Ethank on 16/9/1.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "Father.h"

@interface Son : Father
{
    NSUInteger _age;
}
- (void)setAge:(NSUInteger)age;
- (void)setName:(NSString *)yourName andAge:(NSUInteger)age;
- (void)printDag;
- (void)printCat;
@end
