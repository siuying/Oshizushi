//
//  OSZExpression.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPParser.h"

@class OSZDirection;

@interface OSZExpression : NSObject <CPParseResult>

@property (nonatomic, strong) OSZDirection* direction;
@property (nonatomic, readonly) NSMutableArray* views;

@end
