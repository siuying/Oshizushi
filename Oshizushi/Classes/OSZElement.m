//
//  OSZElement.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZElement.h"

@implementation OSZElement

-(BOOL) isMetric {
    return NO;
}

-(BOOL) isConstant {
    return NO;
}

-(BOOL) isDefault {
    return NO;
}

-(NSInteger) constant
{
    return NSNotFound;
}

-(NSString*) metricName
{
    return nil;
}

@end
