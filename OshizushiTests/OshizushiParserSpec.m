//
//  OshizushiParserSpec.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OshizushiParser.h"
#import "CoreParse.h"

#import "OSZExpression.h"
#import "OSZView.h"

SPEC_BEGIN(OshizushiParserSpec)

describe(@"OshizushiParser", ^{
    __block OshizushiParser* parser;
    __block OSZExpression* expression;

    beforeEach(^{
        parser = [[OshizushiParser alloc] init];
    });

    context(@"-parseVisualFormatLanguage:error:", ^{
        context(@"input string with direction", ^{
            it(@"should set default direction", ^{
                NSError* error = nil;
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"[View]" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                [[theValue(expression.orientation) should] equal:theValue(OSZExpressionOrientationHorizontal)];
            });

            it(@"should parse V: and H: and set orientation", ^{
                NSError* error = nil;
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"V:[View]" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                [[theValue(expression.orientation) should] equal:theValue(OSZExpressionOrientationVertical)];

                expression = [parser parseVisualFormatLanguage:@"H:[View]" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                [[theValue(expression.orientation) should] equal:theValue(OSZExpressionOrientationHorizontal)];
            });
        });

        context(@"input string with view name", ^{
            it(@"should parse [View] and set view name", ^{
                NSError* error = nil;
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"V:[View]" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                
                OSZView* view = [[expression views] firstObject];
                [[view.name should] equal:@"View"];
            });
        });

        context(@"input string with edge", ^{
            it(@"should parse H:|-[View]-| and pin to leading and trailing edge", ^{
                NSError* error = nil;
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]-|" error:&error];
                [[expression shouldNot] beNil];
                
                [[theValue(expression.pinToLeadingSuperview) should] equal:theValue(YES)];
                [[theValue(expression.pinToTrailingSuperview) should] equal:theValue(YES)];
            });
            
            it(@"should parse H:|-[View] and only pin to leading edge", ^{
                NSError* error = nil;
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]" error:&error];
                [[expression shouldNot] beNil];
                
                [[theValue(expression.pinToLeadingSuperview) should] equal:theValue(YES)];
                [[theValue(expression.pinToTrailingSuperview) should] equal:theValue(NO)];
            });
        });
        
        context(@"input string with connection", ^{
            it(@"should parse H:|-[View]-| and pin to leading and trailing edge", ^{
                NSError* error = nil;
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]-|" error:&error];
                [[expression shouldNot] beNil];
                
                [[theValue(expression.pinToLeadingSuperview) should] equal:theValue(YES)];
                [[theValue(expression.pinToTrailingSuperview) should] equal:theValue(YES)];
            });
            
            it(@"should parse H:|-[View] and only pin to leading edge", ^{
                NSError* error = nil;
                expression = [parser parseVisualFormatLanguage:@"H:|-[View]" error:&error];
                [[expression shouldNot] beNil];
                
                [[theValue(expression.pinToLeadingSuperview) should] equal:theValue(YES)];
                [[theValue(expression.pinToTrailingSuperview) should] equal:theValue(NO)];
            });
        });
    });
});

SPEC_END
