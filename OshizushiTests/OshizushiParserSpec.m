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

#import "OSZDirection.h"
#import "OSZExpression.h"
#import "OSZView.h"

SPEC_BEGIN(OshizushiParserSpec)

describe(@"OshizushiParser", ^{
    __block OshizushiParser* parser;
    
    beforeEach(^{
        parser = [[OshizushiParser alloc] init];
    });

    context(@"-parseVisualFormatLanguage:error:", ^{
        context(@"for input string with V: or H:", ^{
            it(@"should parse direction", ^{
                NSError* error = nil;
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"V:[View]" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                [[theValue(expression.direction.value) should] equal:theValue(OSZDirectionVertical)];
                
                expression = [parser parseVisualFormatLanguage:@"H:[View]" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                [[theValue(expression.direction.value) should] equal:theValue(OSZDirectionHorizontal)];
            });
        });
        
        context(@"for input string [View]", ^{
            it(@"should parse view", ^{
                NSError* error = nil;
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"V:[View]" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                
                OSZView* view = [[expression views] firstObject];
                [[view.name should] equal:@"View"];
            });
        });
    });
});

SPEC_END
