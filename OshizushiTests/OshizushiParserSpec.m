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

SPEC_BEGIN(OshizushiParserSpec)

describe(@"OshizushiParser", ^{
    __block OshizushiParser* parser;
    
    beforeEach(^{
        parser = [[OshizushiParser alloc] init];
    });

    context(@"-parseVisualFormatLanguage:error:", ^{
        context(@"parse V: and H:", ^{
            it(@"should parse direction", ^{
                NSError* error = nil;
                OSZExpression* expression = [parser parseVisualFormatLanguage:@"V:" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                [[theValue(expression.direction.value) should] equal:theValue(OSZDirectionVertical)];
                
                expression = [parser parseVisualFormatLanguage:@"H:" error:&error];
                [[expression shouldNot] beNil];
                [[error should] beNil];
                [[theValue(expression.direction.value) should] equal:theValue(OSZDirectionHorizontal)];
            });
        });
    });
});

SPEC_END
