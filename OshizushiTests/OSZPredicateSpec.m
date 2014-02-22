//
//  OSZPredicateSpec.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OSZPredicate.h"


SPEC_BEGIN(OSZPredicateSpec)

describe(@"OSZPredicate", ^{
    context(@"parse constant", ^{
        it(@"should parse constant", ^{
            OSZPredicate* predicate = [OSZPredicate predicateWithString:@"100"];
            [[theValue(predicate.constant) should] equal:theValue(100)];
            [[theValue(predicate.relation) should] equal:theValue(OSZPredicateRelationEqual)];
            [[theValue(predicate.priority) should] equal:theValue(1000)];
        });
    });
    
    context(@"parse metrics", ^{
        it(@"should parse constant", ^{
            OSZPredicate* predicate = [OSZPredicate predicateWithString:@"padding"];
            [[theValue(predicate.constant) should] equal:theValue(NSNotFound)];
            [[predicate.metricName should] equal:@"padding"];
            [[theValue(predicate.relation) should] equal:theValue(OSZPredicateRelationEqual)];
            [[theValue(predicate.priority) should] equal:theValue(1000)];
        });
    });

    context(@"parse relation", ^{
        it(@"should parse constant with relation", ^{
            OSZPredicate* predicate = [OSZPredicate predicateWithString:@">=100"];
            [[theValue(predicate.constant) should] equal:theValue(100)];
            [[theValue(predicate.relation) should] equal:theValue(OSZPredicateRelationGreaterThanOrEqualTo)];
            
            predicate = [OSZPredicate predicateWithString:@"<=60"];
            [[theValue(predicate.constant) should] equal:theValue(60)];
            [[theValue(predicate.relation) should] equal:theValue(OSZPredicateRelationLessThanOrEqualTo)];
        });
    });
    
    context(@"parse priority", ^{
        it(@"should parse constant with relation", ^{
            OSZPredicate* predicate = [OSZPredicate predicateWithString:@"100@50"];
            [[theValue(predicate.constant) should] equal:theValue(100)];
            [[theValue(predicate.relation) should] equal:theValue(OSZPredicateRelationEqual)];
            [[theValue(predicate.priority) should] equal:theValue(50)];
        });
    });
    
    context(@"complex cases", ^{
        it(@"should parse predicate with all input", ^{
            OSZPredicate* predicate = [OSZPredicate predicateWithString:@">=100@50"];
            [[theValue(predicate.constant) should] equal:theValue(100)];
            [[theValue(predicate.relation) should] equal:theValue(OSZPredicateRelationGreaterThanOrEqualTo)];
            [[theValue(predicate.priority) should] equal:theValue(50)];
            
            predicate = [OSZPredicate predicateWithString:@"<=width@100"];
            [[theValue(predicate.constant) should] equal:theValue(NSNotFound)];
            [[(predicate.metricName) should] equal:@"width"];
            [[theValue(predicate.relation) should] equal:theValue(OSZPredicateRelationLessThanOrEqualTo)];
            [[theValue(predicate.priority) should] equal:theValue(100)];
        });
    });
});

SPEC_END
