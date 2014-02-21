//
//  OSZPadding.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPParser.h"

@interface OSZConnection : NSObject <CPParseResult>

/**
 * The value of the connection, or -1 if unset.
 */
@property (nonatomic, assign) NSInteger value;

/**
 * the mertic name of this connection refering
 */
@property (nonatomic, assign) NSString* merticName;

@end
