//
//  OSZPadding.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZConnection.h"
#import "ObjectiveSugar.h"
#import "RegExCategories.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

@implementation OSZConnection

-(instancetype) init {
    self = [super init];
    self.constant = NSNotFound;
    return self;
}

-(instancetype) initWithValueString:(NSString*)valueString
{
    self = [self init];

    if ([valueString isMatch:RX(@"^[0-9]+$")]) {
        self.constant = [valueString integerValue];
    } else {
        self.metricName = valueString;
    }

    return self;
}

-(BOOL) isMetric
{
    return self.metricName != nil;
}

-(BOOL) isConstant
{
    return self.constant != NSNotFound;
}

-(BOOL) isDefault
{
    return ![self isConstant] && ![self isMetric];
}

-(NSString*) description
{
    if ([self isConstant]) {
        return [NSString stringWithFormat:@"-%d-", self.constant];
    } else if ([self isMetric]) {
        return [NSString stringWithFormat:@"-%@-", self.metricName];
    } else {
        return @"-";
    }
}

@end
