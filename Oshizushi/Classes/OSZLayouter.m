//
//  OSZLayouter.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZLayouter.h"
#import "OSZExpression.h"
#import "OSZConnection.h"
#import "OSZPredicate.h"
#import "OSZElement.h"

#import "OSZParser.h"
#import "OSZView.h"

#import "ObjectiveSugar.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

static const CGFloat DefaultEdgeConnection = 10.0;

@implementation OSZLayouter

-(void) layoutWithVisualFormat:(NSString*)visualFormat
                       metrics:(NSDictionary*)metrics
                         views:(NSDictionary*)views
{
    OSZParser* parser = [[OSZParser alloc] init];
    OSZExpression* expression = [parser parseVisualFormatLanguage:visualFormat];
    [self layoutWithVisualFormatExpression:expression metrics:metrics views:views];
}

-(void) layoutWithVisualFormatExpression:(OSZExpression*)expression
                                 metrics:(NSDictionary*)metrics
                                   views:(NSDictionary*)views
{
    NSArray* elements = [expression elements];
    DDLogDebug(@"views: %@", elements);
    
    OSZExpressionOrientation orientation = expression.orientation;

    __block NSNumber* position = nil;
    __block OSZView* lastView = nil;
    void(^processElements)(NSArray*) = ^(NSArray* elements){
        if (expression.pinToLeadingSuperview) {
            position = @0;
        }
        [elements enumerateObjectsUsingBlock:^(OSZElement* element, NSUInteger idx, BOOL *stop) {
            DDLogInfo(@"processing element: %@", element);
            if (idx == 0) {
                if (orientation == OSZExpressionOrientationHorizontal) {
                    // position
                    element.left = position;
                    
                    // size
                    if ([element isConstant]) {
                        element.width = @(element.constant);
                    } else if ([element isMetric]) {
                        element.width = @([self metricWithName:element.metricName metrics:metrics]);
                    }
                } else if (orientation == OSZExpressionOrientationVertical) {
                    // position
                    element.top = position;
                    
                    // size
                    if ([element isConstant]) {
                        element.height = @(element.constant);
                    } else if ([element isMetric]) {
                        element.height = @([self metricWithName:element.metricName metrics:metrics]);
                    }
                }

            } else {
                OSZElement* lastElement = [elements objectAtIndex:idx-1];
                if (orientation == OSZExpressionOrientationHorizontal) {
                    // position
                    if (lastElement.width) {
                        element.left = @(position.integerValue + lastElement.width.integerValue);
                        element.leftRef = lastView.name;
                    } else {
                        element.leftRef = lastView.name;
                    }
                    
                    // size
                    if ([element isConstant]) {
                        element.width = @(element.constant);
                    } else if ([element isMetric]) {
                        element.width = @([self metricWithName:element.metricName metrics:metrics]);
                    }
                } else if (orientation == OSZExpressionOrientationVertical) {
                    // position
                    if (lastElement.height) {
                        element.top = @(position.integerValue + lastElement.height.integerValue);
                        element.topRef = lastView.name;
                    } else {
                        element.topRef = lastView.name;
                    }
                    
                    // size
                    if ([element isConstant]) {
                        element.height = @(element.constant);
                    } else if ([element isMetric]) {
                        element.height = @([self metricWithName:element.metricName metrics:metrics]);
                    }
                }

            }
        }];
    };

    processElements(elements);
}

-(UIView*) viewWithName:(NSString*)name views:(NSDictionary*)views {
    if ([views hasKey:name]) {
        return [views objectForKey:name];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"View %@ not found", name];
        return 0;
    }
}

-(CGFloat) metricWithName:(NSString*)name metrics:(NSDictionary*)metrics {
    if ([metrics hasKey:name]) {
        return [[metrics objectForKey:name] floatValue];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"Metric %@ not found", name];
        return 0;
    }
}

@end
