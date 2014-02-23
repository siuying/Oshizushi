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

    [self calculateLayoutWithExpression:expression metrics:metrics views:views];
    
    [[elements select:^BOOL(id object) {
        return [object isKindOfClass:[OSZView class]];
    }] eachWithIndex:^(OSZView* view, NSUInteger index) {
        [self layoutViewWithViewElement:view metrics:metrics views:views];
    }];
}

#pragma mark - 

-(void) calculateLayoutWithExpression:(OSZExpression*)expression metrics:(NSDictionary*)metrics views:(NSDictionary*)views
{
    OSZExpressionOrientation orientation = expression.orientation;
    __block NSNumber* position = nil;
    __block OSZView* lastView = nil;
    NSArray* elements = [expression elements];

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
}

-(void) layoutViewWithViewElement:(OSZView*)viewElement metrics:(NSDictionary*)metrics views:(NSDictionary*)views
{
    UIView* view = [self viewWithName:viewElement.name views:views];

    // layout frame
    CGFloat x = viewElement.left ? [viewElement.left floatValue] : view.frame.origin.x;
    CGFloat y = viewElement.top ? [viewElement.top floatValue] : view.frame.origin.y;
    CGFloat width = viewElement.width ? [viewElement.width floatValue] : view.frame.size.width;
    CGFloat height = viewElement.height ? [viewElement.height floatValue] : view.frame.size.height;
    view.frame = CGRectMake(x, y, width, height);
    
    // autoresizing mask
    if (viewElement.top && viewElement.height) {
        view.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
    } else if (viewElement.bottom && viewElement.height) {
        view.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    } else if (viewElement.top && viewElement.bottom) {
        view.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
    }

    if (viewElement.left && viewElement.width) {
        view.autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
    } else if (viewElement.right && viewElement.width) {
        view.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
    } else if (viewElement.left && viewElement.right) {
        view.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
    }
}

#pragma mark - Metrics and Views

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
