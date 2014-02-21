//
//  OSZDirection.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZDirection.h"

@implementation OSZDirection

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [super init];
    
    if ([syntaxTree valueForTag:@"v"]) {
        self.value = OSZDirectionVertical;
    } else {
        self.value = OSZDirectionHorizontal;
    }

    return self;
}

@end
