//
//  OSZPredicate.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OSZPredicateRelation) {
    OSZPredicateRelationEqual,
    OSZPredicateRelationGreaterThanOrEqualTo,
    OSZPredicateRelationLessThanOrEqualTo
};

@interface OSZPredicate : NSObject

@property (nonatomic, assign) OSZPredicateRelation relation;

@property (nonatomic, assign) NSInteger constant;

@property (nonatomic, copy) NSString* metricName;

@property (nonatomic, assign) NSUInteger priority;

-(instancetype) initWithString:(NSString*)string;

/**
 * Create a predicate with input string.
 * @param predicate string
 */
+(instancetype) predicateWithString:(NSString*)string;

/**
 * Create a default predicate
 */
+(instancetype) predicate;

/**
 * If this connection has metric name.
 */
-(BOOL) isMetric;

/**
 * If this connection has constant.
 */
-(BOOL) isConstant;

/**
 * If this connection has no metric name and value (and thus should use defaults)
 */
-(BOOL) isDefault;

@end
