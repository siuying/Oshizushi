//
//  OshizushiGrammarSpec.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OshizushiGrammar.h"
#import "OshizushiTokeniser.h"

#import "CoreParse.h"

SPEC_BEGIN(OshizushiGrammarSpec)

describe(@"OshizushiGrammar", ^{
    __block OshizushiGrammar* grammar;
    __block OshizushiTokeniser* tokenizer;
    __block CPLALR1Parser* parser;
    
    beforeEach(^{
        tokenizer = [[OshizushiTokeniser alloc] init];
        grammar = [[OshizushiGrammar alloc] init];
        parser = [[CPLALR1Parser alloc] initWithGrammar:grammar];

    });

    context(@"-init", ^{
        it(@"should load a grammar", ^{
            [[grammar shouldNot] beNil];
        });
    });
    
    context(@"OSZDirection", ^{
        it(@"should parse OSZDirection", ^{

        });
    });
});

SPEC_END
