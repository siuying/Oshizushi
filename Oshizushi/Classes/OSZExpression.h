//
//  OSZExpression.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPParser.h"

typedef NS_ENUM(NSUInteger, OSZExpressionDirection) {
    OSZExpressionDirectionVertical,
    OSZExpressionDirectionHorizontal
};

@class OSZDirection;

@interface OSZExpression : NSObject <CPParseResult>

@property (nonatomic, assign) OSZExpressionDirection direction;

@property (nonatomic, readonly) NSMutableArray* views;

@property (nonatomic, assign) BOOL pinToLeadingEdge;

@property (nonatomic, assign) BOOL pinToTrailingEdge;

@end
