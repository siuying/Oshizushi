//
//  OshizushiParserSpec.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OSZParser.h"

#import "OSZExpression.h"
#import "OSZView.h"
#import "OSZConnection.h"
#import "OSZPredicate.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

SPEC_BEGIN(OSZParserSpec)

describe(@"OSZParser", ^{
    __block OSZParser* parser;
    __block OSZExpression* expression;

    beforeEach(^{
        parser = [[OSZParser alloc] init];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    });
    
    afterEach(^{
        [DDLog flushLog];
        [DDLog removeAllLoggers];
    });

    context(@"-parseVisualFormatLanguage:error:", ^{
        context(@"input string with direction", ^{
            it(@"should set default direction", ^{
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"[View]"];
                [[expression shouldNot] beNil];
                [[theValue(expression.orientation) should] equal:theValue(OSZExpressionOrientationHorizontal)];
            });

            it(@"should parse V: and H: and set orientation", ^{
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"V:[View]"];
                [[expression shouldNot] beNil];
                [[theValue(expression.orientation) should] equal:theValue(OSZExpressionOrientationVertical)];

                expression = [parser parseVisualFormatLanguage:@"H:[View]"];
                [[expression shouldNot] beNil];
                [[theValue(expression.orientation) should] equal:theValue(OSZExpressionOrientationHorizontal)];
            });
        });

        context(@"input string with view name", ^{
            it(@"should parse [View] and set view name", ^{
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"V:[View]"];
                [[expression shouldNot] beNil];

                OSZView* view = [[expression views] firstObject];
                [[view.name should] equal:@"View"];
            });
        });

        context(@"input string with edge", ^{
            it(@"should parse H:|-[View]-| and pin to leading and trailing edge", ^{
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]-|"];
                [[expression shouldNot] beNil];
                
                [[theValue(expression.pinToLeadingSuperview) should] equal:theValue(YES)];
                [[theValue(expression.pinToTrailingSuperview) should] equal:theValue(YES)];
            });
            
            it(@"should parse H:|-[View] and only pin to leading edge", ^{
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]"];
                [[expression shouldNot] beNil];
                
                [[theValue(expression.pinToLeadingSuperview) should] equal:theValue(YES)];
                [[theValue(expression.pinToTrailingSuperview) should] equal:theValue(NO)];
            });
        });
        
        context(@"input string with connection", ^{
            it(@"should parse H:|-[View]-| and pin to leading and trailing edge", ^{
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]-|"];
                [[expression shouldNot] beNil];
                
                [[theValue(expression.pinToLeadingSuperview) should] equal:theValue(YES)];
                [[theValue(expression.pinToTrailingSuperview) should] equal:theValue(YES)];
            });
            
            it(@"should parse H:|-[View] and only pin to leading edge", ^{
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]"];
                [[expression shouldNot] beNil];
                
                [[theValue(expression.pinToLeadingSuperview) should] equal:theValue(YES)];
                [[theValue(expression.leadingConnection.value) should] equal:theValue(NSNotFound)];
                [[expression.leadingConnection.metricName should] beNil];
                [[theValue(expression.pinToTrailingSuperview) should] equal:theValue(NO)];
            });
            
            it(@"should parse H:|-10-[View]-4-| and pin to leading and trailing edge with 10 pixel", ^{
                expression = [parser parseVisualFormatLanguage:@"H:|-10-[View]-4-|"];
                [[expression shouldNot] beNil];
                
                [[expression.leadingConnection shouldNot] beNil];
                [[theValue(expression.leadingConnection.value) should] equal:theValue(10)];
                [[expression.leadingConnection.metricName should] beNil];

                [[expression.trailingConnection shouldNot] beNil];
                [[theValue(expression.trailingConnection.value) should] equal:theValue(4)];
                [[expression.trailingConnection.metricName should] beNil];
            });
        });
        
        context(@"input string with multiple views and connections", ^{
            it(@"should parse H:|-[View]-[Label]-| and pin to leading and trailing edge", ^{
                
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]-10-[Label]-|"];
                [[expression shouldNot] beNil];

                [[theValue(expression.views.count) should] equal:theValue(2)];
                OSZView* view1 = expression.views[0];
                [[[view1 name] should] equal:@"View"];
                [[theValue([[view1 predicate] isDefault]) should] beTrue];
                [[theValue([[view1 connection] isDefault]) should] beTrue];

                OSZView* view2 = expression.views[1];
                [[[view2 name] should] equal:@"Label"];
                [[theValue([[view2 predicate] isDefault]) should] beTrue];
                [[theValue([[view2 connection] isDefault]) should] beFalse];
                [[theValue([[view2 connection] value]) should] equal:theValue(10)];
            });
        });
        
        context(@"matching predicate in a view", ^{
            it(@"should parse [View(100)]", ^{
                expression = [parser parseVisualFormatLanguage:@"[View(100)]"];
                [[expression shouldNot] beNil];
                
                
            });
        });
    });
});

SPEC_END
