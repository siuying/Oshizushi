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
    NSArray* viewObjects = [expression views];
    DDLogDebug(@"views: %@", viewObjects);
    
    OSZExpressionOrientation orientation = expression.orientation;
    
    [viewObjects eachWithIndex:^(OSZView* viewRef, NSUInteger index) {
        UIView* view = [self viewWithName:viewRef.name views:views];
        
        UIViewAutoresizing autoresizing = view.autoresizingMask;

        CGFloat position = (expression.orientation == OSZExpressionOrientationHorizontal) ?
            view.frame.origin.x : view.frame.origin.y;

        CGFloat size;
        
        if (viewRef.predicate) {
            if ([viewRef.predicate isDefault]) {
                CGSize fittingSize = [view sizeThatFits:view.superview.frame.size];
                size = (expression.orientation == OSZExpressionOrientationHorizontal) ?
                    fittingSize.width : fittingSize.height;
            } else if ([viewRef.predicate isConstant]) {
                size = viewRef.predicate.constant;
            } else if ([viewRef.predicate isMetric]) {
                size = [self metricWithName:viewRef.predicate.metricName metrics:metrics];
            }
        }

        // view is first view
        if (index == 0) {
            if (expression.pinToLeadingSuperview) {
                CGFloat padding;
                
                if (expression.leadingConnection) {
                    if ([expression.leadingConnection isMetric]) {
                        padding = [self metricWithName:expression.leadingConnection.metricName metrics:metrics];
                    } else if ([expression.leadingConnection isValue]) {
                        padding = expression.leadingConnection.value;
                    } else {
                        padding = DefaultEdgeConnection;
                    }
                } else {
                    padding = 0;
                }

                position = (orientation == OSZExpressionOrientationHorizontal) ?
                    view.superview.frame.origin.x + padding : view.superview.frame.origin.y + padding;

            } else {
                // if not pin to superview, it has flexible margin
                autoresizing = (orientation == OSZExpressionOrientationHorizontal) ?
                    autoresizing | UIViewAutoresizingFlexibleLeftMargin : autoresizing | UIViewAutoresizingFlexibleTopMargin;
            }
        }
        
        // view is last view
        if (index == [viewObjects count] - 1) {
            if (expression.pinToTrailingSuperview) {
                CGFloat padding;
                
                if (expression.trailingConnection) {
                    if ([expression.trailingConnection isMetric]) {
                        padding = [self metricWithName:expression.trailingConnection.metricName metrics:metrics];
                    } else if ([expression.trailingConnection isValue]) {
                        padding = expression.trailingConnection.value;
                    } else {
                        padding = DefaultEdgeConnection;
                    }
                } else {
                    padding = 0;
                }
                
                size = (orientation == OSZExpressionOrientationHorizontal) ?
                    view.superview.frame.size.width - position - padding : view.superview.frame.size.height - position - padding;
            } else {
                // if not pin to superview, it has flexible margin
                autoresizing = (orientation == OSZExpressionOrientationHorizontal) ?
                    (autoresizing | UIViewAutoresizingFlexibleRightMargin) : (autoresizing | UIViewAutoresizingFlexibleBottomMargin);
            }
        }
        
        // actual setting frame
        view.autoresizingMask = autoresizing;
        view.frame = (orientation == OSZExpressionOrientationHorizontal) ?
            CGRectMake(position, view.frame.origin.y, size, view.frame.size.height) :
            CGRectMake(view.frame.origin.x, position, view.frame.size.width, size);
    }];
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
