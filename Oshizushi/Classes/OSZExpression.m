//
//  OSZExpression.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZExpression.h"

@implementation OSZExpression

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [super init];
    self.direction = [syntaxTree valueForTag:@"direction"];
    return self;
}

@end
