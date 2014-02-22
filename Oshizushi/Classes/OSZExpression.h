//
//  OSZExpression.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OSZExpressionOrientation) {
    OSZExpressionOrientationVertical,
    OSZExpressionOrientationHorizontal
};

@class OSZConnection;
@class OSZView;
@class OSZElement;

@interface OSZExpression : NSObject

@property (nonatomic, assign) OSZExpressionOrientation orientation;

@property (nonatomic, readonly) NSMutableArray* elements;

@property (nonatomic, assign) BOOL pinToLeadingSuperview;
@property (nonatomic, strong) OSZConnection* leadingConnection;

@property (nonatomic, assign) BOOL pinToTrailingSuperview;
@property (nonatomic, strong) OSZConnection* trailingConnection;

-(void) addElement:(OSZElement*)element;

@end
