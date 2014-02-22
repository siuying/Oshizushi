//
//  OshizushiParser.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZParser.h"
#import "RegExCategories.h"

#import "OSZExpression.h"
#import "OSZConnection.h"
#import "OSZView.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

static NSString*    OshConnectionRx = @"\\-(([0-9a-zA-Z]+|[0-9]+)\\-)?";
static NSUInteger   OshConnectionRxNumberGroup = 2;

//static NSString*    OshViewRx = @"^\\[([a-zA-Z][a-zA-Z0-9]*)(\\((>|<|==|>=|<=)?([a-zA-Z][a-zA-Z0-9]*)(@[0-9a-zA-Z]+)?\\))?\\]";
static NSString*    OshViewRx = @"\\[([a-zA-Z][a-zA-Z0-9]*)\\]";
static NSUInteger   OshViewRxNameGroup = 1;

@interface OSZParser()
@property (nonatomic, strong) Rx* connectionRx;
@property (nonatomic, strong) Rx* viewRx;
@end

@implementation OSZParser

-(instancetype) init
{
    self = [super init];
    
    self.connectionRx = RX(OshConnectionRx);
    self.viewRx = RX(OshViewRx);

    return self;
}

- (OSZExpression*)parseVisualFormatLanguage:(NSString *)input
{
    OSZExpression* expression = [[OSZExpression alloc] init];
    
    NSMutableString* workingInput = [input mutableCopy];
    
    [self processOrientationWithString:workingInput withExpression:expression];
    [self processLeadingSuperviewWithString:workingInput withExpression:expression];
    [self processFirstViewWithString:workingInput withExpression:expression];

    while([self processConnectionAndViewWithString:workingInput withExpression:expression]) {}

    [self processTrailingSuperviewWithString:workingInput withExpression:expression];

    return expression;
}

- (void) processOrientationWithString:(NSMutableString*)input withExpression:(OSZExpression*)expression
{
    if ([input hasPrefix:@"V:"]) {
        expression.orientation = OSZExpressionOrientationVertical;
        [input deleteCharactersInRange:NSMakeRange(0, 2)];
        return;
    }

    if ([input hasPrefix:@"H:"]) {
        expression.orientation = OSZExpressionOrientationHorizontal;
        [input deleteCharactersInRange:NSMakeRange(0, 2)];
        return;
    }

    expression.orientation = OSZExpressionOrientationHorizontal;
}

- (void) processLeadingSuperviewWithString:(NSMutableString*)input withExpression:(OSZExpression*)expression
{
    if ([input hasPrefix:@"|"]) {
        expression.pinToLeadingSuperview = YES;
        [input deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    expression.leadingConnection = [self processConnectionWithString:input];
}

- (void) processFirstViewWithString:(NSMutableString*)input withExpression:(OSZExpression*)expression
{
    OSZView* view = [self processViewWithString:input];
    view.connection = expression.leadingConnection;
    [expression addView:view];
}

- (BOOL) processConnectionAndViewWithString:(NSMutableString*)input withExpression:(OSZExpression*)expression
{
    if ([input isMatch:self.viewRx]) {
        OSZConnection* connection = [self processConnectionWithString:input];
        OSZView* view = [self processViewWithString:input];
        if (view) {
            view.connection = connection;
            [expression addView:view];
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void) processTrailingSuperviewWithString:(NSMutableString*)input withExpression:(OSZExpression*)expression
{
    expression.trailingConnection = [self processConnectionWithString:input];
    if ([input hasPrefix:@"|"]) {
        expression.pinToTrailingSuperview = YES;
        [input deleteCharactersInRange:NSMakeRange(0, 1)];
    }
}

/**
 * Look for a connection in input string, consume the string and return it.
 * If connection not found, return nil.
 * @param input Input string
 * @return return a OSZConnection object, or nil if not found.
 */
- (OSZConnection*) processConnectionWithString:(NSMutableString*)input
{
    RxMatch* result = [self.connectionRx firstMatchWithDetails:input];
    if (!result) {
        return nil;
    }
    
    [input deleteCharactersInRange:result.range];
    OSZConnection* connection;
    if ([result.value isEqualToString:@"-"]) {
        connection = [[OSZConnection alloc] init];
    } else {
        NSArray* groups = [result groups];
        RxMatchGroup* numberGroup = groups[OshConnectionRxNumberGroup];
        connection = [[OSZConnection alloc] initWithValueString:[numberGroup value]];
    }
    return connection;
}

/**
 * Look for a view in input string, consume the string and return it.
 * If view not found, return nil.
 * @param input Input string
 * @return return a OSZView object, or nil if not found.
 */
- (OSZView*) processViewWithString:(NSMutableString*)input
{
    RxMatch* result = [self.viewRx firstMatchWithDetails:input];
    if (!result) {
        return nil;
    }

    OSZView* view = [[OSZView alloc] init];
    NSArray* groups = [result groups];
    RxMatchGroup* nameGroup = groups[OshViewRxNameGroup];
    if ([nameGroup value]) {
        view.name = [nameGroup value];
    }
    [input deleteCharactersInRange:result.range];
    return view;
}

@end
