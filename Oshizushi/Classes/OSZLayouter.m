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
#import "OSZPredicate.h"

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
    
    NSMutableDictionary* viewElementMappings = [NSMutableDictionary dictionary];
    [elements each:^(id object) {
        if ([object isKindOfClass:[OSZView class]]) {
            OSZView* view = object;
            [viewElementMappings setObject:view forKey:view.name];
        }
    }];
    
    NSArray* viewElements = [[viewElementMappings allValues] sortedArrayUsingComparator:^NSComparisonResult(OSZView* view1, OSZView* view2) {
        if ([[view1 references] containsObject:view2.name]) {
            return NSOrderedAscending;
        }
        if ([[view2 references] containsObject:view1.name]) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];

    [viewElements eachWithIndex:^(OSZView* view, NSUInteger index) {
        [self layoutViewWithViewElement:view mappings:viewElementMappings orientation:expression.orientation metrics:metrics views:views];
    }];
}

#pragma mark - 

-(void) calculateLayoutWithExpression:(OSZExpression*)expression metrics:(NSDictionary*)metrics views:(NSDictionary*)views reversed:(BOOL)reversed
{
    OSZExpressionOrientation orientation = expression.orientation;
    __block NSNumber* position = nil;
    __block OSZView* referencedView = nil;
    NSArray* elements = reversed ? [[expression elements] reverse] : [expression elements];

    if ((expression.pinToLeadingSuperview && !reversed) ||
        (expression.pinToTrailingSuperview && reversed)) {
        position = @0;
    }

    [elements enumerateObjectsUsingBlock:^(OSZElement* element, NSUInteger idx, BOOL *stop) {
        if ([element isKindOfClass:[OSZConnection class]]) {
            OSZConnection* connection = (OSZConnection*) element;
            if (position) {
                CGFloat width = 0;
                if ([connection isConstant]) {
                    width = connection.constant;

                } else if ([connection isMetric]) {
                    width = [self metricWithName:connection.metricName metrics:metrics];

                } else {
                    if (connection == expression.trailingConnection || connection == expression.leadingConnection) {
                        width = DefaultEdgeConnection;
                    } else {
                        width = DefaultInnerConnection;
                    }
                }

                connection.width = @(width);
                position = @(position.floatValue + width);
            }
        }
        
        if ([element isKindOfClass:[OSZView class]]) {
            OSZView* view = (OSZView*) element;
            if (orientation == OSZExpressionOrientationHorizontal) {
                if (reversed) {
                    view.right = position;
                    view.rightRef = referencedView.name;
                } else {
                    view.left = position;
                    view.leftRef = referencedView.name;
                }
                
                if (([view isConstant] && (view.predicate.relation == OSZPredicateRelationEqual)) || [view isMetric]) {
                    view.width = [view isConstant] ? @(view.constant) : @([self metricWithName:view.metricName metrics:metrics]);
                    if (position) {
                        position = @(position.floatValue + view.width.floatValue);
                    }
                } else if (position) {
                    referencedView = view;
                    position = @(0);
                    NSLog(@"view '%@' has no size, position becomes 0 and set ref", view.name);
                } else {
                    position = nil;
                    NSLog(@"view '%@' has no width and cannot determine edge", view.name);
                }

            } else if (orientation == OSZExpressionOrientationVertical) {
                if (reversed) {
                    view.bottom = position;
                    view.bottomRef = referencedView.name;
                } else {
                    view.top = position;
                    view.topRef = referencedView.name;
                }
                
                if (([view isConstant] && (view.predicate.relation == OSZPredicateRelationEqual)) || [view isMetric]) {
                    view.height = [view isConstant] ? @(view.constant) : @([self metricWithName:view.metricName metrics:metrics]);
                    if (position) {
                        position = @(position.floatValue + view.height.floatValue);
                    }
                } else if (position) {
                    referencedView = view;
                    position = @(0);
                    NSLog(@"view '%@' has no size, position becomes 0 and set ref", view.name);
                } else {
                    position = nil;
                    NSLog(@"view '%@' has no width and cannot determine edge", view.name);
                }
            }
        }
    }];
}

-(void) layoutViewWithViewElement:(OSZView*)viewElement mappings:(NSDictionary*)mappings orientation:(OSZExpressionOrientation)orientation metrics:(NSDictionary*)metrics views:(NSDictionary*)views
{
    UIView* view = [self viewWithName:viewElement.name views:views];
    UIView* superview = [view superview];

    // layout frame
    CGFloat x = view.frame.origin.x;
    CGFloat y = view.frame.origin.y;
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    UIViewAutoresizing autoresizing = view.autoresizingMask;

    NSLog(@"references: %@", [viewElement references]);
    
    if (orientation == OSZExpressionOrientationHorizontal) {
        if (!viewElement.leftRef && viewElement.left && viewElement.width) {
            x = viewElement.left.floatValue;
            width = viewElement.width.floatValue;
            autoresizing |= UIViewAutoresizingFlexibleRightMargin;

        } else if (!viewElement.rightRef && viewElement.right && viewElement.width) {
            width = viewElement.width.floatValue;
            x = superview.frame.size.width - viewElement.right.floatValue - width;
            autoresizing |= UIViewAutoresizingFlexibleLeftMargin;

        } else if (viewElement.left && viewElement.right) {
            x = viewElement.left.floatValue;
            width = CGRectGetWidth(superview.frame) - viewElement.left.floatValue - viewElement.right.floatValue;
            autoresizing |= UIViewAutoresizingFlexibleWidth;
        } else {
            if (viewElement.left) {
                x = viewElement.left.floatValue;
                autoresizing |= UIViewAutoresizingFlexibleRightMargin;
            } else if (viewElement.right) {
                x = superview.frame.size.width - viewElement.right.floatValue - view.frame.size.width;
                autoresizing |= UIViewAutoresizingFlexibleLeftMargin;
            }
        }
    } else if (orientation == OSZExpressionOrientationVertical) {
        if (!viewElement.topRef && viewElement.top && viewElement.height) {
            y = viewElement.top.floatValue;
            height = viewElement.height.floatValue;
            autoresizing |= UIViewAutoresizingFlexibleBottomMargin;
            
        } else if (!viewElement.bottomRef && viewElement.bottom && viewElement.height) {
            height = viewElement.height.floatValue;
            y = superview.frame.size.width - viewElement.bottom.floatValue - height;
            autoresizing |= UIViewAutoresizingFlexibleTopMargin;
            
        } else if (viewElement.top && viewElement.bottom) {
            y = viewElement.top.floatValue;
            height = CGRectGetWidth(superview.frame) - viewElement.top.floatValue - viewElement.bottom.floatValue;
            autoresizing |= UIViewAutoresizingFlexibleHeight;
        } else {
            if (viewElement.top) {
                y = viewElement.top.floatValue;
                autoresizing |= UIViewAutoresizingFlexibleBottomMargin;
            } else if (viewElement.bottom) {
                y = superview.frame.size.height - viewElement.bottom.floatValue - view.frame.size.height;
                autoresizing |= UIViewAutoresizingFlexibleTopMargin;
            }
        }

        if (viewElement.height) {
            height = viewElement.height.floatValue;
        } else if (viewElement.top && viewElement.bottom) {
            height = CGRectGetHeight(superview.frame) - viewElement.top.floatValue - viewElement.bottom.floatValue;
        } else if ([viewElement isDefault]) {
            height = view.frame.size.height;
        }
    }

    CGRect frame = CGRectMake(x, y, width, height);
    NSLog(@"%@.frame = %@; (left=%@, right=%@, top=%@, bottom=%@)", viewElement.name, NSStringFromCGRect(frame),
          viewElement.left, viewElement.right, viewElement.top, viewElement.bottom);
    view.frame = frame;
    view.autoresizingMask = autoresizing;
    
    // update view references
    if (viewElement.leftRef) {
        OSZView* view = [mappings objectForKey:viewElement.leftRef];
        view.right = @(superview.frame.size.width - (x - viewElement.left.floatValue));
    }
    if (viewElement.rightRef) {
        OSZView* view = [mappings objectForKey:viewElement.rightRef];
        view.left = @(x + width + viewElement.right.floatValue);
    }
    if (viewElement.topRef) {
        OSZView* view = [mappings objectForKey:viewElement.topRef];
        view.bottom = @(superview.frame.size.height - (y - viewElement.top.floatValue));
    }
    if (viewElement.bottomRef) {
        OSZView* view = [mappings objectForKey:viewElement.bottomRef];
        view.top = @(y + height + viewElement.bottom.floatValue);
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
