//
//  OSZView.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZView.h"
#import "OSZPredicate.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

@implementation OSZView

-(BOOL) isMetric
{
    return [self.predicate isMetric];
}

-(BOOL) isConstant
{
    return [self.predicate isConstant];
}

-(BOOL) isDefault
{
    return [self.predicate isDefault];
}

-(NSInteger) constant
{
    return self.predicate.constant;
}

-(NSString*) metricName
{
    return self.predicate.metricName;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"%@", self.name];
}

@end
