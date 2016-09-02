//
//  Model.m
//  DYRuntime
//
//  Created by Ethank on 16/8/31.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "Model.h"

@implementation Model
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"--%@--%@--%@--%@--%@--", _name, _age, _phoneNumber, _height, _info];
}
@end
