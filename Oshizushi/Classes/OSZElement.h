//
//  OSZElement.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSZElement : NSObject

@property (nonatomic, strong) NSNumber* top;

@property (nonatomic, strong) NSNumber* bottom;

@property (nonatomic, strong) NSNumber* left;

@property (nonatomic, strong) NSNumber* right;

@property (nonatomic, strong) NSNumber* width;

@property (nonatomic, strong) NSNumber* height;

@property (nonatomic, copy) NSString* leftRef;

@property (nonatomic, copy) NSString* rightRef;

@property (nonatomic, copy) NSString* topRef;

@property (nonatomic, copy) NSString* bottomRef;

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

-(NSInteger) constant;

-(NSString*) metricName;

@end
