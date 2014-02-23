//
//  OSZView.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSZElement.h"

@class OSZConnection;
@class OSZPredicate;

@interface OSZView : OSZElement

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) OSZPredicate* predicate;

-(NSArray*) references;

-(NSInteger) constant;

-(NSString*) metricName;

/**
 * If this connection has metric name.
 */
-(BOOL) isMetric;

/**
 * If this connection has value.
 */
-(BOOL) isConstant;

/**
 * If this connection has no metric name and value (and thus should use defaults)
 */
-(BOOL) isDefault;

@end
