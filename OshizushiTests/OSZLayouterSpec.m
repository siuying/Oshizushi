//
//  OSZLayouterSpec.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

#import "OSZLayouter.h"

SPEC_BEGIN(OSZLayouterSpec)

describe(@"OSZLayouter", ^{
    __block OSZLayouter* layouter;
    __block UIView* superview;
    
    beforeEach(^{
        layouter = [[OSZLayouter alloc] init];
        superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDLog addLogger:[DDASLLogger sharedInstance]];
    });
    
    afterEach(^{
        [DDLog flushLog];
        [DDLog removeAllLoggers];
    });

    context(@"Pin to one edge", ^{
        it(@"should layout |-5-[view(100)]", ^{
            UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
            [superview addSubview:view];
            
            NSDictionary* views = NSDictionaryOfVariableBindings(view);
            [layouter layoutWithVisualFormat:@"|-5-[view(100)]" metrics:nil views:views];
            
            [[theValue(view.frame.origin.x) should] equal:theValue(5)];
            [[theValue(view.frame.origin.y) should] equal:theValue(0)];
            [[theValue(view.frame.size.width) should] equal:theValue(100)];
            [[theValue(view.autoresizingMask & UIViewAutoresizingFlexibleRightMargin) should] equal:theValue(UIViewAutoresizingFlexibleRightMargin)];
        });
        
        it(@"should layout V:|-10-[view(50)]", ^{
            UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
            [superview addSubview:view];
            
            NSDictionary* views = NSDictionaryOfVariableBindings(view);
            [layouter layoutWithVisualFormat:@"V:|-10-[view(50)]" metrics:nil views:views];
            
            [[theValue(view.frame.origin.x) should] equal:theValue(0)];
            [[theValue(view.frame.origin.y) should] equal:theValue(10)];
            [[theValue(view.frame.size.height) should] equal:theValue(50)];
            [[theValue(view.autoresizingMask & UIViewAutoresizingFlexibleBottomMargin) should] equal:theValue(UIViewAutoresizingFlexibleBottomMargin)];
        });
        
        it(@"should layout V:[view]|", ^{
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            [superview addSubview:view];
            
            NSDictionary* views = NSDictionaryOfVariableBindings(view);
            [layouter layoutWithVisualFormat:@"V:[view]|" metrics:nil views:views];

            [[theValue(view.frame.origin.x) should] equal:theValue(0)];
            [[theValue(view.frame.origin.y) should] equal:theValue(380)];
            [[theValue(view.frame.size.height) should] equal:theValue(100)];
            [[theValue(view.autoresizingMask & UIViewAutoresizingFlexibleTopMargin) should] equal:theValue(UIViewAutoresizingFlexibleTopMargin)];
        });
    });
    
    context(@"Pin to both edge", ^{
        it(@"should layout |-5-[view]-5-|", ^{
            UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
            [superview addSubview:view];
            
            NSDictionary* views = NSDictionaryOfVariableBindings(view);
            [layouter layoutWithVisualFormat:@"H:|-5-[view]-5-|" metrics:nil views:views];
            
            [[theValue(view.frame.origin.x) should] equal:theValue(5)];
            [[theValue(view.frame.origin.y) should] equal:theValue(0)];
            [[theValue(view.frame.size.width) should] equal:theValue(310)];
        });
    });

    context(@"Multiple views", ^{
        it(@"should layout |-5-[view(100)]-[view2(100)]", ^{
            UIView* view = [[UIView alloc] initWithFrame:CGRectZero];

            UIView* view2 = [[UIView alloc] initWithFrame:CGRectZero];
            [superview addSubview:view2];
            
            NSDictionary* views = NSDictionaryOfVariableBindings(view, view2);
            [layouter layoutWithVisualFormat:@"|-5-[view(100)]-5-[view2(100)]" metrics:nil views:views];

            [[theValue(view.frame.origin.x) should] equal:theValue(5)];
            [[theValue(view.frame.size.width) should] equal:theValue(100)];

            [[theValue(view2.frame.origin.x) should] equal:theValue(110)];
            [[theValue(view2.frame.size.width) should] equal:theValue(100)];
            [[theValue(view2.autoresizingMask & UIViewAutoresizingFlexibleRightMargin) should] equal:theValue(UIViewAutoresizingFlexibleRightMargin)];
        });
    });
});

SPEC_END