//
//  OshizushiGrammarSpec.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OshizushiGrammar.h"


SPEC_BEGIN(OshizushiGrammarSpec)

describe(@"OshizushiGrammar", ^{
    __block OshizushiGrammar* grammar;
    
    beforeEach(^{
        grammar = [[OshizushiGrammar alloc] init];
    });

    context(@"-init", ^{
        it(@"should load a grammar", ^{
            [[grammar shouldNot] beNil];
        });
    });
});

SPEC_END
