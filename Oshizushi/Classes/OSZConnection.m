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
    self.value = NSNotFound;
    return self;
}

-(instancetype) initWithValueString:(NSString*)valueString
{
    self = [self init];

    if ([valueString isMatch:RX(@"^[0-9]+$")]) {
        self.value = [valueString integerValue];
    } else {
        self.merticName = valueString;
    }

    return self;
}

-(BOOL) isMetric
{
    return self.merticName != nil;
}

-(BOOL) isValue
{
    return self.value != NSNotFound;
}

-(BOOL) isDefault
{
    return ![self isValue] && ![self isMetric];
}

-(NSString*) description
{
    if ([self isValue]) {
        return [NSString stringWithFormat:@"-%d-", self.value];
    } else if ([self isMetric]) {
        return [NSString stringWithFormat:@"-%@-", self.merticName];
    } else {
        return @"-";
    }
}

@end
