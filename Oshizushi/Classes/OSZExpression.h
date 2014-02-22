//
//  OSZExpression.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPParser.h"

typedef NS_ENUM(NSUInteger, OSZExpressionOrientation) {
    OSZExpressionOrientationVertical,
    OSZExpressionOrientationHorizontal
};

@class OSZConnection;

@interface OSZExpression : NSObject <CPParseResult>

@property (nonatomic, assign) OSZExpressionOrientation orientation;

@property (nonatomic, readonly) NSMutableArray* views;

@property (nonatomic, assign) BOOL pinToLeadingSuperview;
@property (nonatomic, strong) OSZConnection* leadingConnection;

@property (nonatomic, assign) BOOL pinToTrailingSuperview;
@property (nonatomic, strong) OSZConnection* trailingConnection;

@end
