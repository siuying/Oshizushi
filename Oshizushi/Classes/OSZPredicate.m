//
//  OSZPredicate.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZPredicate.h"
#import "RegExCategories.h"

@interface OSZPredicate()
@end

@implementation OSZPredicate

+(Rx*) predicateRx
{
    static dispatch_once_t onceToken;
    static Rx* predicateRx;
    dispatch_once(&onceToken, ^{
        predicateRx = RX(@"^"
                         @"(==|>=|<=)?"
                         @"([0-9]+|[0-9a-zA-Z]+)"
                         @"(@([0-9]{1,4}))?"
                         @"$");
    });
    return predicateRx;
}

-(instancetype) init
{
    self = [super init];
    self.relation = OSZPredicateRelationEqual;
    self.constant = NSNotFound;
    self.metricName = nil;
    self.priority = 1000;
    return self;
}

-(instancetype) initWithString:(NSString*)string
{
    self = [super init];


    RxMatch* match = [[[self class] predicateRx] firstMatchWithDetails:string];
    NSArray* groups     = [match groups];

    NSString* relationString  = groups[1] ? [(RxMatchGroup*)groups[1] value] : nil;
    self.relation = relationString ? [[self class] relationWithString:relationString] : OSZPredicateRelationEqual;

    NSString* object    = groups[2] ? [(RxMatchGroup*)groups[2] value] : nil;
    if ([object isMatch:RX(@"^[0-9]+$")]) {
        self.constant = [object integerValue];
    } else {
        self.constant = NSNotFound;
        self.metricName = object;
    }

    NSString* priority  = groups[4] ? [(RxMatchGroup*)groups[4] value] : nil;
    self.priority = priority ? [priority integerValue] : 1000;

    return self;
}

+(instancetype) predicate
{
    return [[self alloc] init];
}

+(instancetype) predicateWithString:(NSString*)string
{
    return [[self alloc] initWithString:string];
}

+(OSZPredicateRelation) relationWithString:(NSString*)relationString
{
    if ([relationString isEqualToString:@">="]) {
        return OSZPredicateRelationGreaterThanOrEqualTo;
    }

    if ([relationString isEqualToString:@"<="]) {
        return OSZPredicateRelationLessThanOrEqualTo;
    }

    if ([relationString isEqualToString:@"=="]) {
        return OSZPredicateRelationEqual;
    }
    
    [NSException raise:NSInvalidArgumentException format:@"unexpected relation: %@", relationString];
    return 0;
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

@end
