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
static const CGFloat DefaultInnerConnection = 5.0;

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

    [self calculateLayoutWithExpression:expression metrics:metrics views:views reversed:NO];
    [self calculateLayoutWithExpression:expression metrics:metrics views:views reversed:YES];

    [[elements select:^BOOL(id object) {
        return [object isKindOfClass:[OSZView class]];
    }] eachWithIndex:^(OSZView* view, NSUInteger index) {
        [self layoutViewWithViewElement:view orientation:expression.orientation metrics:metrics views:views];
    }];
}

#pragma mark - 

-(void) calculateLayoutWithExpression:(OSZExpression*)expression metrics:(NSDictionary*)metrics views:(NSDictionary*)views reversed:(BOOL)reversed
{
    OSZExpressionOrientation orientation = expression.orientation;
    __block NSNumber* position = nil;
    __block OSZView* lastView = nil;
    NSArray* elements = reversed ? [[expression elements] reverse] : [expression elements];

    if ((expression.pinToLeadingSuperview && !reversed) ||
        (expression.pinToTrailingSuperview && reversed)) {
        position = @0;
    }

    [elements enumerateObjectsUsingBlock:^(OSZElement* element, NSUInteger idx, BOOL *stop) {
        DDLogInfo(@"processing element: %@", element);
        if (idx == 0) {
            if (orientation == OSZExpressionOrientationHorizontal) {
                if (reversed) {
                    // position
                    element.right = position;
                    
                    // size
                    if ([element isConstant]) {
                        element.width = @(element.constant);
                    } else if ([element isMetric]) {
                        element.width = @([self metricWithName:element.metricName metrics:metrics]);
                    } else if ([element isDefault] && [element isKindOfClass:[OSZConnection class]]) {
                        if (element == expression.trailingConnection) {
                            element.width = @(DefaultEdgeConnection);
                        } else {
                            element.width = @(DefaultInnerConnection);
                        }
                    }
                    
                    if (element.width && element.right) {
                        position = @(element.right.floatValue + element.width.floatValue);
                    } else {
                        NSLog(@"position of next element not set");
                        position = nil;
                    }
                } else {
                    // position
                    element.left = position;
                    
                    // size
                    if ([element isConstant]) {
                        element.width = @(element.constant);
                    } else if ([element isMetric]) {
                        element.width = @([self metricWithName:element.metricName metrics:metrics]);
                    } else if ([element isDefault] && [element isKindOfClass:[OSZConnection class]]) {
                        if (element == expression.leadingConnection) {
                            element.width = @(DefaultEdgeConnection);
                        } else {
                            element.width = @(DefaultInnerConnection);
                        }
                    }
                    
                    if (element.width && element.left) {
                        position = @(element.left.floatValue + element.width.floatValue);
                    } else {
                        NSLog(@"position of next element not set");
                        position = nil;
                    }
                }
            } else if (orientation == OSZExpressionOrientationVertical) {
                if (reversed) {
                    // position
                    element.bottom = position;
                    
                    // size
                    if ([element isConstant]) {
                        element.height = @(element.constant);
                    } else if ([element isMetric]) {
                        element.height = @([self metricWithName:element.metricName metrics:metrics]);
                    } else if ([element isDefault] && [element isKindOfClass:[OSZConnection class]]) {
                        if (element == expression.trailingConnection) {
                            element.height = @(DefaultEdgeConnection);
                        } else {
                            element.height = @(DefaultInnerConnection);
                        }
                    }
                    
                    if (element.height && element.bottom) {
                        position = @(element.bottom.floatValue + element.height.floatValue);
                    } else {
                        NSLog(@"position of next element not set");
                        position = nil;
                    }
                } else {
                    // position
                    element.top = position;
                    
                    // size
                    if ([element isConstant]) {
                        element.height = @(element.constant);
                    } else if ([element isMetric]) {
                        element.height = @([self metricWithName:element.metricName metrics:metrics]);
                    } else if ([element isDefault] && [element isKindOfClass:[OSZConnection class]]) {
                        if (element == expression.leadingConnection) {
                            element.height = @(DefaultEdgeConnection);
                        } else {
                            element.height = @(DefaultInnerConnection);
                        }
                    }

                    if (element.height && element.top) {
                        position = @(element.top.floatValue + element.height.floatValue);
                    } else {
                        NSLog(@"position of next element not set");
                        position = nil;
                    }
                }
            }
            
        } else {
            if (orientation == OSZExpressionOrientationHorizontal) {
                if (reversed) {
                    // position
                    element.right = position;
                    element.rightRef = lastView.name;

                    // size
                    if ([element isConstant]) {
                        element.width = @(element.constant);
                    } else if ([element isMetric]) {
                        element.width = @([self metricWithName:element.metricName metrics:metrics]);
                    }
                    
                    if (element.width && element.right) {
                        position = @(element.right.floatValue + element.width.floatValue);
                    } else {
                        NSLog(@"position of next element not set");
                        position = nil;
                    }
                } else {
                    // position
                    element.left = position;
                    element.leftRef = lastView.name;

                    // size
                    if ([element isConstant]) {
                        element.width = @(element.constant);
                    } else if ([element isMetric]) {
                        element.width = @([self metricWithName:element.metricName metrics:metrics]);
                    }
                    
                    if (element.width && element.left) {
                        position = @(element.left.floatValue + element.width.floatValue);
                    } else {
                        NSLog(@"position of next element not set");
                        position = nil;
                    }
                }
            } else if (orientation == OSZExpressionOrientationVertical) {
                if (reversed) {
                    // position
                    element.bottom = position;
                    element.bottomRef = lastView.name;
                    
                    // size
                    if ([element isConstant]) {
                        element.height = @(element.constant);
                    } else if ([element isMetric]) {
                        element.height = @([self metricWithName:element.metricName metrics:metrics]);
                    }
                    
                    if (element.height && element.bottom) {
                        position = @(element.height.floatValue + element.bottom.floatValue);
                    } else {
                        NSLog(@"position of next element not set");
                        position = nil;
                    }

                } else {
                    // position
                    element.top = position;
                    element.topRef = lastView.name;
                    
                    // size
                    if ([element isConstant]) {
                        element.height = @(element.constant);
                    } else if ([element isMetric]) {
                        element.height = @([self metricWithName:element.metricName metrics:metrics]);
                    }
                    
                    if (element.height && element.top) {
                        position = @(element.height.floatValue + element.top.floatValue);
                    } else {
                        NSLog(@"position of next element not set");
                        position = nil;
                    }
                }
            }
        }
        
        if ([element isKindOfClass:[OSZView class]]) {
            lastView = (OSZView*) element;
        }
    }];
}

-(void) layoutViewWithViewElement:(OSZView*)viewElement orientation:(OSZExpressionOrientation)orientation metrics:(NSDictionary*)metrics views:(NSDictionary*)views
{
    UIView* view = [self viewWithName:viewElement.name views:views];
    UIView* superview = [view superview];

    // layout frame
    CGFloat x = view.frame.origin.x;//viewElement.left ? [viewElement.left floatValue] : view.frame.origin.x;
    CGFloat y = view.frame.origin.y;//viewElement.top ? [viewElement.top floatValue] : view.frame.origin.y;
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    
    if (orientation == OSZExpressionOrientationHorizontal) {
        if (viewElement.left && viewElement.right) {
            width = superview.frame.size.width - viewElement.right.floatValue - viewElement.left.floatValue;
        } else if (viewElement.width) {
            width = viewElement.width.floatValue;
        } else if ([viewElement isDefault]) {
            width = view.frame.size.width;
        }
        
        if (viewElement.left) {
            x = viewElement.left.floatValue;
        } else if (viewElement.right) {
            x = superview.frame.size.width - viewElement.right.floatValue - width;
        }
    } else if (orientation == OSZExpressionOrientationVertical) {
        if (viewElement.top && viewElement.bottom) {
            height = superview.frame.size.height - viewElement.bottom.floatValue - viewElement.top.floatValue;
        } else if (viewElement.height) {
            height = viewElement.height.floatValue;
        } else if ([viewElement isDefault]) {
            height = view.frame.size.height;
        }
        
        if (viewElement.top) {
            y = viewElement.top.floatValue;
        } else if (viewElement.bottom) {
            y = superview.frame.size.height - viewElement.bottom.floatValue - height;
        }
    }

    CGRect frame = CGRectMake(x, y, width, height);
    NSLog(@"%@.frame = %@; (left=%@, right=%@, top=%@, bottom=%@)", viewElement.name, NSStringFromCGRect(frame),
          viewElement.left, viewElement.right, viewElement.top, viewElement.bottom);
    view.frame = frame;
    
    // autoresizing mask
    if (orientation == OSZExpressionOrientationHorizontal) {
        if (viewElement.left && viewElement.right) {
            view.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
        } else if (viewElement.left) {
            view.autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
        } else if (viewElement.right) {
            view.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
        }
    } else {
        if (viewElement.top && viewElement.bottom) {
            view.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
        } else if (viewElement.top) {
            view.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
        } else if (viewElement.bottom) {
            view.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
        }
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
