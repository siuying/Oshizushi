//
//  OSZPadding.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSZConnection : NSObject

/**
 * The value of the connection, or NSNotFound if unset.
 */
@property (nonatomic, assign) NSInteger value;

/**
 * the mertic name of this connection refering
 */
@property (nonatomic, assign) NSString* merticName;

/**
 * Initialize a connection with value string. 
 * @param valueString value of the connection.
 * If valueString is a number, it will set to the value field.
 * If valueString is a string, it will set to metricName.
 * @return initialized value
 */
-(instancetype) initWithValueString:(NSString*)valueString;

/**
 * Initialize a value with no value (use the default value)
 */
-(instancetype) init;

/**
 * If this connection has metric name.
 */
-(BOOL) isMetric;

/**
 * If this connection has value.
 */
-(BOOL) isValue;

/**
 * If this connection has no metric name and value (and thus should use defaults)
 */
-(BOOL) isDefault;

@end
