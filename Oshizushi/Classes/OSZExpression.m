//
//  OSZExpression.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZExpression.h"
#import "OSZView.h"
#import "OSZElement.h"

#import "ObjectiveSugar.h"
#import "OSZConnection.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

@interface OSZExpression()
@property (nonatomic, strong) NSMutableArray* elements;
@end

@implementation OSZExpression

-(id) init
{
    self = [super init];
    self.elements = [NSMutableArray array];
    return self;
}

-(void) addElement:(OSZElement*)element
{
    [self.elements addObject:element];
}

@end
