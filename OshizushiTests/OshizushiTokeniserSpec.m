//
//  OshizushiTokeniserSpec.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OshizushiTokeniser.h"
#import "CoreParse.h"

SPEC_BEGIN(OshizushiTokeniserSpec)

describe(@"OshizushiTokeniser", ^{
    __block OshizushiTokeniser *tokenizer;
    
    beforeEach(^{
        tokenizer = [[OshizushiTokeniser alloc] init];
    });

    context(@"[button]", ^{
        it(@"should tokenize a view", ^{
            CPTokenStream* stream = [tokenizer tokenise:@"[button]"];
            
            NSMutableArray* tokens = [NSMutableArray array];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"["]];
            [tokens addObject:[CPIdentifierToken tokenWithIdentifier:@"button"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"]"]];
            [tokens addObject:[CPEOFToken eof]];

            CPTokenStream* expectedStream = [[CPTokenStream alloc] initWithTokens:tokens];
            [[stream should] equal:expectedStream];
        });
    });
    
    context(@"[button]-[textField]", ^{
        it(@"should tokenize views with space", ^{
            CPTokenStream* stream = [tokenizer tokenise:@"[button]-[textField]"];
            
            NSMutableArray* tokens = [NSMutableArray array];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"["]];
            [tokens addObject:[CPIdentifierToken tokenWithIdentifier:@"button"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"]"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"-"]];            
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"["]];
            [tokens addObject:[CPIdentifierToken tokenWithIdentifier:@"textField"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"]"]];
            [tokens addObject:[CPEOFToken eof]];
            
            CPTokenStream* expectedStream = [[CPTokenStream alloc] initWithTokens:tokens];
            [[stream should] equal:expectedStream];
        });
    });

    context(@"[button(>=50)]", ^{
        it(@"should tokenize views with size", ^{
            CPTokenStream* stream = [tokenizer tokenise:@"[button(>=50)]"];
            
            NSMutableArray* tokens = [NSMutableArray array];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"["]];
            [tokens addObject:[CPIdentifierToken tokenWithIdentifier:@"button"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"("]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@">="]];
            [tokens addObject:[CPNumberToken tokenWithNumber:@(50)]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@")"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"]"]];
            [tokens addObject:[CPEOFToken eof]];

            CPTokenStream* expectedStream = [[CPTokenStream alloc] initWithTokens:tokens];
            [[stream should] equal:expectedStream];
        });
    });
    
    context(@"V:|-[find]-[findField(>=20)]-|", ^{
        it(@"should tokenize whole line", ^{
            CPTokenStream* stream = [tokenizer tokenise:@"V:|-[find]-[findField(>=20)]-|"];
            
            NSMutableArray* tokens = [NSMutableArray array];
            [tokens addObject:[CPIdentifierToken tokenWithIdentifier:@"V"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@":"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"|"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"-"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"["]];
            [tokens addObject:[CPIdentifierToken tokenWithIdentifier:@"find"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"]"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"-"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"["]];
            [tokens addObject:[CPIdentifierToken tokenWithIdentifier:@"findField"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"("]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@">="]];
            [tokens addObject:[CPNumberToken tokenWithNumber:@(20)]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@")"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"]"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"-"]];
            [tokens addObject:[CPKeywordToken tokenWithKeyword:@"|"]];
            [tokens addObject:[CPEOFToken eof]];

            CPTokenStream* expectedStream = [[CPTokenStream alloc] initWithTokens:tokens];
            [[stream should] equal:expectedStream];
        });
    });
});

SPEC_END
