//
//  OSZExpression.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZExpression.h"
#import "OSZView.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

@interface OSZExpression()
@property (nonatomic, strong) NSMutableArray* views;
@end

@implementation OSZExpression

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [super init];
    self.direction = [syntaxTree valueForTag:@"direction"];
    _views = [NSMutableArray array];

    OSZView* view = [[syntaxTree children] objectAtIndex:2];
    if (view) {
        [self.views addObject:view];
    }

    return self;
}

@end
